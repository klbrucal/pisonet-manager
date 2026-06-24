using System.IO;
using System.ComponentModel;
using System.Net;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Windows;
using System.Windows.Input;
using Microsoft.Web.WebView2.Core;
using Drawing = System.Drawing;
using Forms = System.Windows.Forms;

namespace PisonetManager.Desktop;

public partial class MainWindow : Window
{
    private bool _webViewInitialized;
    private bool _allowExit;
    private bool _trayNoticeShown;
    private readonly Forms.NotifyIcon _notifyIcon;

    public MainWindow()
    {
        InitializeComponent();
        _notifyIcon = CreateNotifyIcon();
        Loaded += MainWindow_Loaded;
        Closing += MainWindow_Closing;
        Closed += MainWindow_Closed;
    }

    private Forms.NotifyIcon CreateNotifyIcon()
    {
        var menu = new Forms.ContextMenuStrip();
        menu.Items.Add("Open", null, (_, _) => RestoreFromTray());
        menu.Items.Add(new Forms.ToolStripSeparator());
        menu.Items.Add("Exit", null, (_, _) => ExitApplication());

        var notifyIcon = new Forms.NotifyIcon
        {
            ContextMenuStrip = menu,
            Icon = Drawing.SystemIcons.Application,
            Text = "Pisonet Manager",
            Visible = true,
        };
        notifyIcon.DoubleClick += (_, _) => RestoreFromTray();
        return notifyIcon;
    }

    private void MainWindow_Closing(object? sender, CancelEventArgs e)
    {
        if (_allowExit)
        {
            return;
        }

        e.Cancel = true;
        ShowInTaskbar = false;
        Hide();

        if (!_trayNoticeShown)
        {
            _notifyIcon.ShowBalloonTip(
                3000,
                "Pisonet Manager",
                "Pisonet Manager is still running in the notification area.",
                Forms.ToolTipIcon.Info);
            _trayNoticeShown = true;
        }
    }

    private void RestoreFromTray()
    {
        Dispatcher.Invoke(() =>
        {
            ShowInTaskbar = true;
            Show();
            if (WindowState == WindowState.Minimized)
            {
                WindowState = WindowState.Normal;
            }
            Activate();
        });
    }

    private void ExitApplication()
    {
        Dispatcher.Invoke(() =>
        {
            _allowExit = true;
            Close();
        });
    }

    private void MainWindow_Closed(object? sender, EventArgs e)
    {
        _notifyIcon.Visible = false;
        _notifyIcon.ContextMenuStrip?.Dispose();
        _notifyIcon.Dispose();
    }

    private void MainWindow_Loaded(object sender, RoutedEventArgs e)
    {
        try
        {
            var settings = DesktopSettings.Load();
            ServerInput.Text = settings.ServerUrl;
            LocationInput.SelectedIndex = 0;
            PasswordInput.Focus();
        }
        catch (Exception exception)
        {
            ShowLoginError(exception.Message);
        }
    }

    private async void LoginButton_Click(object sender, RoutedEventArgs e)
    {
        await LoginAsync();
    }

    private async void PasswordInput_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
    {
        if (e.Key == Key.Enter)
        {
            await LoginAsync();
        }
    }

    private async Task LoginAsync()
    {
        if (!TryGetServerUri(out var serverUri))
        {
            ShowLoginError("Server must be a valid HTTP or HTTPS address.");
            return;
        }

        LoginButton.IsEnabled = false;
        LoginError.Visibility = Visibility.Collapsed;

        try
        {
            await EnsureWebViewInitializedAsync();
            var loginError = await AuthenticateAsync(serverUri);
            if (loginError is not null)
            {
                ShowLoginError(loginError);
                PasswordInput.SelectAll();
                PasswordInput.Focus();
                return;
            }

            PasswordInput.Clear();
            await NavigateAsync(new Uri($"{serverUri.AbsoluteUri.TrimEnd('/')}?desktop=1"));
            ShowDashboard();
        }
        catch (Exception exception)
        {
            ShowLoginError($"Unable to connect: {exception.Message}");
        }
        finally
        {
            LoginButton.IsEnabled = true;
        }
    }

    private async Task<string?> AuthenticateAsync(Uri serverUri)
    {
        var cookieContainer = new CookieContainer();
        using var handler = new HttpClientHandler
        {
            CookieContainer = cookieContainer,
            UseCookies = true,
        };
        using var client = new HttpClient(handler)
        {
            BaseAddress = serverUri,
            Timeout = TimeSpan.FromSeconds(10),
        };

        using var response = await client.PostAsJsonAsync("/api/login", new
        {
            location = LocationInput.Text,
            password = PasswordInput.Password,
        });

        if (!response.IsSuccessStatusCode)
        {
            try
            {
                using var error = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
                if (error.RootElement.TryGetProperty("detail", out var detail))
                {
                    return detail.GetString() ?? "Unable to sign in.";
                }
            }
            catch (JsonException)
            {
            }

            return $"Unable to sign in ({(int)response.StatusCode}).";
        }

        Browser.CoreWebView2.CookieManager.DeleteAllCookies();
        foreach (Cookie cookie in cookieContainer.GetCookies(serverUri))
        {
            var webCookie = Browser.CoreWebView2.CookieManager.CreateCookie(
                cookie.Name,
                cookie.Value,
                serverUri.Host,
                string.IsNullOrWhiteSpace(cookie.Path) ? "/" : cookie.Path);
            webCookie.IsHttpOnly = cookie.HttpOnly;
            webCookie.IsSecure = cookie.Secure;
            Browser.CoreWebView2.CookieManager.AddOrUpdateCookie(webCookie);
        }

        return null;
    }

    private async Task EnsureWebViewInitializedAsync()
    {
        if (_webViewInitialized)
        {
            return;
        }

        var userDataFolder = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "PisonetManager",
            "Desktop",
            "WebView2");
        var environment = await CoreWebView2Environment.CreateAsync(userDataFolder: userDataFolder);
        await Browser.EnsureCoreWebView2Async(environment);
        Browser.CoreWebView2.Settings.AreDevToolsEnabled = false;
        Browser.CoreWebView2.NavigationStarting += (_, _) => StatusText.Text = "Connecting...";
        Browser.CoreWebView2.NavigationCompleted += (_, args) =>
            StatusText.Text = args.IsSuccess ? "Connected" : "Unable to connect";
        Browser.CoreWebView2.WebMessageReceived += CoreWebView2_WebMessageReceived;
        _webViewInitialized = true;
    }

    private Task NavigateAsync(Uri uri)
    {
        var completion = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);

        void NavigationCompleted(object? sender, CoreWebView2NavigationCompletedEventArgs args)
        {
            Browser.CoreWebView2.NavigationCompleted -= NavigationCompleted;
            if (args.IsSuccess)
            {
                completion.SetResult();
            }
            else
            {
                completion.SetException(new InvalidOperationException($"Navigation failed: {args.WebErrorStatus}"));
            }
        }

        Browser.CoreWebView2.NavigationCompleted += NavigationCompleted;
        Browser.CoreWebView2.Navigate(uri.AbsoluteUri);
        return completion.Task;
    }

    private void CoreWebView2_WebMessageReceived(object? sender, CoreWebView2WebMessageReceivedEventArgs e)
    {
        using var message = JsonDocument.Parse(e.WebMessageAsJson);
        if (!message.RootElement.TryGetProperty("type", out var type))
        {
            return;
        }

        var messageType = type.GetString();
        if (messageType == "authentication_required")
        {
            Dispatcher.Invoke(ShowLogin);
        }
        else if (messageType == "client_idle" &&
                 message.RootElement.TryGetProperty("pc_name", out var pcName))
        {
            var name = pcName.GetString();
            if (!string.IsNullOrWhiteSpace(name))
            {
                _notifyIcon.ShowBalloonTip(
                    5000,
                    "Client is idle",
                    $"{name} has become idle.",
                    Forms.ToolTipIcon.Info);
            }
        }
    }

    private bool TryGetServerUri(out Uri serverUri)
    {
        var value = ServerInput.Text.Trim().TrimEnd('/');
        if (Uri.TryCreate(value, UriKind.Absolute, out var parsed) &&
            parsed.Scheme is "http" or "https")
        {
            serverUri = parsed;
            ServerInput.Text = parsed.AbsoluteUri.TrimEnd('/');
            return true;
        }

        serverUri = null!;
        return false;
    }

    private void ShowDashboard()
    {
        LoginView.Visibility = Visibility.Collapsed;
        AppToolbar.Visibility = Visibility.Visible;
        Browser.Visibility = Visibility.Visible;
    }

    private void ShowLogin()
    {
        Browser.Visibility = Visibility.Collapsed;
        AppToolbar.Visibility = Visibility.Collapsed;
        LoginView.Visibility = Visibility.Visible;
        PasswordInput.Clear();
        PasswordInput.Focus();
    }

    private void ShowLoginError(string message)
    {
        LoginError.Text = message;
        LoginError.Visibility = Visibility.Visible;
    }

    private void ReloadButton_Click(object sender, RoutedEventArgs e)
    {
        if (Browser.CoreWebView2 is not null)
        {
            Browser.Reload();
        }
    }
}

internal sealed record DesktopSettings(string ServerUrl)
{
    public static DesktopSettings Load()
    {
        var path = Path.Combine(AppContext.BaseDirectory, "appsettings.json");
        string json;

        if (File.Exists(path))
        {
            json = File.ReadAllText(path);
        }
        else
        {
            using var stream = typeof(DesktopSettings).Assembly
                .GetManifestResourceStream("appsettings.json")
                ?? throw new InvalidOperationException("Embedded appsettings.json was not found.");
            using var reader = new StreamReader(stream);
            json = reader.ReadToEnd();
        }

        var settings = JsonSerializer.Deserialize<DesktopSettings>(
            json,
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        if (settings is null ||
            !Uri.TryCreate(settings.ServerUrl, UriKind.Absolute, out var serverUri) ||
            serverUri.Scheme is not ("http" or "https"))
        {
            throw new InvalidOperationException("ServerUrl must be a valid HTTP or HTTPS address.");
        }

        return settings;
    }
}
