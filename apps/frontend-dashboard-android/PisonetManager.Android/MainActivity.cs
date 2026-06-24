using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.Graphics;
using Android.OS;
using Android.Text;
using Android.Views;
using Android.Views.InputMethods;
using Android.Webkit;
using Android.Widget;
using Java.Interop;

namespace PisonetManager.Android;

[Activity(
    Label = "@string/app_name",
    MainLauncher = true,
    Exported = true,
    ConfigurationChanges = ConfigChanges.Orientation | ConfigChanges.ScreenSize)]
public sealed class MainActivity : Activity
{
    private const string AuthenticationRequiredUrl = "pisonet-manager://authentication-required";
    private const string IdleNotificationChannelId = "client-idle";
    private const int NotificationPermissionRequestCode = 1001;

    private ScrollView _loginView = null!;
    private EditText _serverInput = null!;
    private Spinner _locationInput = null!;
    private EditText _passwordInput = null!;
    private TextView _loginError = null!;
    private Button _loginButton = null!;
    private ProgressBar _loginProgress = null!;
    private WebView _webView = null!;
    private ProgressBar _refreshProgress = null!;
    private DashboardJavascriptBridge _javascriptBridge = null!;
    private float _pullStartY;
    private bool _trackingPull;

    protected override void OnCreate(Bundle? savedInstanceState)
    {
        base.OnCreate(savedInstanceState);
        Window?.SetStatusBarColor(Color.Rgb(31, 97, 141));
        ConfigureNotifications();
        CreateViews();
        ConfigureWebView();

        var preferences = GetSharedPreferences("dashboard", FileCreationMode.Private);
        _serverInput.Text = preferences?.GetString("server_url", GetString(Resource.String.default_server));
        _loginButton.Click += async (_, _) => await LoginAsync();
        _passwordInput.EditorAction += async (_, eventArgs) =>
        {
            if (eventArgs.ActionId == ImeAction.Done)
            {
                await LoginAsync();
            }
        };
    }

    private void CreateViews()
    {
        var root = new FrameLayout(this)
        {
            LayoutParameters = MatchParentLayout(),
        };
        root.SetBackgroundColor(Color.Rgb(244, 246, 248));

        _loginView = new ScrollView(this)
        {
            FillViewport = true,
            LayoutParameters = MatchParentLayout(),
        };

        var form = new LinearLayout(this)
        {
            Orientation = Orientation.Vertical,
            LayoutParameters = MatchParentLayout(),
        };
        form.SetGravity(GravityFlags.CenterVertical);
        form.SetPadding(Dp(24), Dp(24), Dp(24), Dp(24));

        var title = new TextView(this)
        {
            Text = "Pisonet Manager",
            TextSize = 28,
        };
        title.SetTextColor(Color.Rgb(23, 32, 42));
        title.SetTypeface(null, TypefaceStyle.Bold);
        form.AddView(title, MarginLayout(bottom: 28));

        _serverInput = AddInput(form, "Server", InputTypes.ClassText | InputTypes.TextVariationUri);
        _locationInput = AddLocationInput(form);
        _passwordInput = AddInput(
            form,
            "Password",
            InputTypes.ClassText | InputTypes.TextVariationPassword);
        _passwordInput.ImeOptions = ImeAction.Done;

        _loginError = new TextView(this)
        {
            Visibility = ViewStates.Gone,
        };
        _loginError.SetTextColor(Color.Rgb(169, 50, 38));
        form.AddView(_loginError, MarginLayout(bottom: 12));

        _loginButton = new Button(this)
        {
            Text = "Sign in",
        };
        _loginButton.SetAllCaps(false);
        form.AddView(_loginButton, new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MatchParent,
            Dp(48)));

        _loginProgress = new ProgressBar(this)
        {
            Indeterminate = true,
            Visibility = ViewStates.Gone,
        };
        var progressLayout = new LinearLayout.LayoutParams(Dp(36), Dp(36))
        {
            Gravity = GravityFlags.CenterHorizontal,
            TopMargin = Dp(14),
        };
        form.AddView(_loginProgress, progressLayout);

        _loginView.AddView(form);
        root.AddView(_loginView);

        _webView = new WebView(this)
        {
            LayoutParameters = MatchParentLayout(),
            Visibility = ViewStates.Gone,
        };
        root.AddView(_webView);

        _refreshProgress = new ProgressBar(this)
        {
            Indeterminate = true,
            Visibility = ViewStates.Gone,
        };
        var refreshProgressLayout = new FrameLayout.LayoutParams(Dp(40), Dp(40))
        {
            Gravity = GravityFlags.Top | GravityFlags.CenterHorizontal,
            TopMargin = Dp(12),
        };
        root.AddView(_refreshProgress, refreshProgressLayout);
        SetContentView(root);
    }

    private EditText AddInput(LinearLayout form, string labelText, InputTypes inputType)
    {
        var label = new TextView(this)
        {
            Text = labelText,
        };
        label.SetTextColor(Color.Rgb(52, 73, 94));
        label.SetTypeface(null, TypefaceStyle.Bold);
        form.AddView(label, MarginLayout(bottom: 6));

        var input = new EditText(this)
        {
            InputType = inputType,
        };
        input.SetSingleLine(true);
        input.SetPadding(Dp(12), 0, Dp(12), 0);
        form.AddView(input, new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MatchParent,
            Dp(48))
        {
            BottomMargin = Dp(14),
        });
        return input;
    }

    private Spinner AddLocationInput(LinearLayout form)
    {
        var label = new TextView(this)
        {
            Text = "Location",
        };
        label.SetTextColor(Color.Rgb(52, 73, 94));
        label.SetTypeface(null, TypefaceStyle.Bold);
        form.AddView(label, MarginLayout(bottom: 6));

        var input = new Spinner(this);
        input.Adapter = new ArrayAdapter<string>(
            this,
            global::Android.Resource.Layout.SimpleSpinnerDropDownItem,
            new[] { "All", "Test", "Aprang's Pisonet" });
        input.SetSelection(2);
        form.AddView(input, new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MatchParent,
            Dp(48))
        {
            BottomMargin = Dp(14),
        });
        return input;
    }

    private void ConfigureWebView()
    {
        WebView.SetWebContentsDebuggingEnabled(false);
        _webView.Settings.JavaScriptEnabled = true;
        _webView.Settings.DomStorageEnabled = true;
        _webView.Settings.AllowFileAccess = false;
        _webView.Settings.AllowContentAccess = false;
        _webView.SetWebViewClient(new DashboardWebViewClient(this));
        _webView.SetWebChromeClient(new DashboardWebChromeClient(this));
        _javascriptBridge = new DashboardJavascriptBridge(this);
        _webView.AddJavascriptInterface(_javascriptBridge, "PisonetAndroid");
        _webView.Touch += (_, eventArgs) =>
        {
            HandleDashboardTouch(eventArgs.Event);
            eventArgs.Handled = false;
        };
        global::Android.Webkit.CookieManager.Instance?.SetAcceptCookie(true);
    }

    private void HandleDashboardTouch(MotionEvent? motionEvent)
    {
        if (motionEvent is null)
        {
            return;
        }

        switch (motionEvent.ActionMasked)
        {
            case MotionEventActions.Down:
                _trackingPull = _webView.ScrollY <= 0;
                _pullStartY = motionEvent.RawY;
                break;
            case MotionEventActions.Move:
                if (_webView.ScrollY > 0)
                {
                    _trackingPull = false;
                }
                break;
            case MotionEventActions.Up:
                if (_trackingPull && motionEvent.RawY - _pullStartY >= Dp(80))
                {
                    _refreshProgress.Visibility = ViewStates.Visible;
                    _webView.Reload();
                }
                _trackingPull = false;
                break;
            case MotionEventActions.Cancel:
                _trackingPull = false;
                break;
        }
    }

    internal void SetRefreshProgress(bool refreshing)
    {
        RunOnUiThread(() =>
        {
            _refreshProgress.Visibility = refreshing && _webView.Visibility == ViewStates.Visible
                ? ViewStates.Visible
                : ViewStates.Gone;
        });
    }

    private void ConfigureNotifications()
    {
        var manager = GetSystemService(NotificationService) as NotificationManager;
        if (OperatingSystem.IsAndroidVersionAtLeast(26))
        {
            var channel = new NotificationChannel(
                IdleNotificationChannelId,
                "Idle clients",
                NotificationImportance.Default)
            {
                Description = "Alerts when a client PC becomes idle.",
            };
            manager?.CreateNotificationChannel(channel);
        }

        if (OperatingSystem.IsAndroidVersionAtLeast(33) &&
            CheckSelfPermission(global::Android.Manifest.Permission.PostNotifications) != Permission.Granted)
        {
            RequestPermissions(
                [global::Android.Manifest.Permission.PostNotifications],
                NotificationPermissionRequestCode);
        }
    }

    internal void HandleDashboardMessage(string message)
    {
        try
        {
            using var document = JsonDocument.Parse(message);
            var root = document.RootElement;
            if (root.TryGetProperty("type", out var type) &&
                type.GetString() == "client_idle" &&
                root.TryGetProperty("pc_name", out var pcName))
            {
                var name = pcName.GetString();
                if (!string.IsNullOrWhiteSpace(name))
                {
                    ShowIdleNotification(name);
                }
            }
        }
        catch (JsonException)
        {
        }
    }

    private void ShowIdleNotification(string pcName)
    {
        if (OperatingSystem.IsAndroidVersionAtLeast(33) &&
            CheckSelfPermission(global::Android.Manifest.Permission.PostNotifications) != Permission.Granted)
        {
            return;
        }

        var openAppIntent = new Intent(this, typeof(MainActivity));
        openAppIntent.SetFlags(ActivityFlags.ClearTop | ActivityFlags.SingleTop);
        var pendingIntent = PendingIntent.GetActivity(
            this,
            0,
            openAppIntent,
            PendingIntentFlags.UpdateCurrent | PendingIntentFlags.Immutable);

        Notification.Builder builder;
        if (OperatingSystem.IsAndroidVersionAtLeast(26))
        {
            builder = new Notification.Builder(this, IdleNotificationChannelId);
        }
        else
        {
            builder = new Notification.Builder(this);
        }
        builder
            .SetSmallIcon(global::Android.Resource.Drawable.IcDialogInfo)
            .SetContentTitle("Client is idle")
            .SetContentText($"{pcName} has become idle.")
            .SetContentIntent(pendingIntent)
            .SetAutoCancel(true);

        var manager = GetSystemService(NotificationService) as NotificationManager;
        manager?.Notify(pcName.GetHashCode(), builder.Build());
    }

    private async Task LoginAsync()
    {
        if (!TryGetServerUri(out var serverUri))
        {
            ShowLoginError("Server must be a valid HTTP or HTTPS address.");
            return;
        }

        SetLoginBusy(true);
        _loginError.Visibility = ViewStates.Gone;
        try
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
                location = _locationInput.SelectedItem?.ToString() ?? "Test",
                password = _passwordInput.Text ?? string.Empty,
            });

            if (!response.IsSuccessStatusCode)
            {
                ShowLoginError(await ReadLoginErrorAsync(response));
                return;
            }

            TransferCookies(cookieContainer, serverUri);
            GetSharedPreferences("dashboard", FileCreationMode.Private)?
                .Edit()?
                .PutString("server_url", serverUri.AbsoluteUri.TrimEnd('/'))?
                .Apply();
            _passwordInput.Text = string.Empty;
            HideKeyboard();
            _loginView.Visibility = ViewStates.Gone;
            _webView.Visibility = ViewStates.Visible;
            _webView.LoadUrl($"{serverUri.AbsoluteUri.TrimEnd('/')}?android=1");
        }
        catch (Exception exception)
        {
            ShowLoginError($"Unable to connect: {exception.Message}");
        }
        finally
        {
            SetLoginBusy(false);
        }
    }

    private bool TryGetServerUri(out System.Uri serverUri)
    {
        var value = (_serverInput.Text ?? string.Empty).Trim().TrimEnd('/');
        if (System.Uri.TryCreate(value, UriKind.Absolute, out var parsed) &&
            parsed.Scheme is "http" or "https")
        {
            serverUri = parsed;
            _serverInput.Text = parsed.AbsoluteUri.TrimEnd('/');
            return true;
        }

        serverUri = null!;
        return false;
    }

    private static async Task<string> ReadLoginErrorAsync(HttpResponseMessage response)
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

    private static void TransferCookies(CookieContainer cookies, System.Uri serverUri)
    {
        var manager = global::Android.Webkit.CookieManager.Instance;
        if (manager is null)
        {
            return;
        }

        manager.RemoveAllCookies(null);
        var origin = serverUri.GetLeftPart(UriPartial.Authority);
        foreach (Cookie cookie in cookies.GetCookies(serverUri))
        {
            manager.SetCookie(origin, $"{cookie.Name}={cookie.Value}; Path=/; SameSite=Strict");
        }
        manager.Flush();
    }

    internal void ShowNativeLogin()
    {
        RunOnUiThread(() =>
        {
            _webView.StopLoading();
            _webView.Visibility = ViewStates.Gone;
            _loginView.Visibility = ViewStates.Visible;
            _passwordInput.Text = string.Empty;
            _passwordInput.RequestFocus();
        });
    }

    private void SetLoginBusy(bool busy)
    {
        _loginButton.Enabled = !busy;
        _loginProgress.Visibility = busy ? ViewStates.Visible : ViewStates.Gone;
    }

    private void ShowLoginError(string message)
    {
        _loginError.Text = message;
        _loginError.Visibility = ViewStates.Visible;
    }

    private void HideKeyboard()
    {
        var manager = GetSystemService(InputMethodService) as InputMethodManager;
        manager?.HideSoftInputFromWindow(_passwordInput.WindowToken, HideSoftInputFlags.None);
    }

    public override void OnBackPressed()
    {
        if (_webView.Visibility == ViewStates.Visible && _webView.CanGoBack())
        {
            _webView.GoBack();
            return;
        }
#pragma warning disable CA1422
        base.OnBackPressed();
#pragma warning restore CA1422
    }

    protected override void OnDestroy()
    {
        _webView.StopLoading();
        _webView.Destroy();
        base.OnDestroy();
    }

    private FrameLayout.LayoutParams MatchParentLayout() => new(
        ViewGroup.LayoutParams.MatchParent,
        ViewGroup.LayoutParams.MatchParent);

    private LinearLayout.LayoutParams MarginLayout(int bottom) => new(
        ViewGroup.LayoutParams.MatchParent,
        ViewGroup.LayoutParams.WrapContent)
    {
        BottomMargin = Dp(bottom),
    };

    private int Dp(int value) => (int)(value * (Resources?.DisplayMetrics?.Density ?? 1f) + 0.5f);

    private sealed class DashboardWebViewClient(MainActivity activity) : WebViewClient
    {
        public override void OnPageStarted(WebView? view, string? url, Bitmap? favicon)
        {
            activity.SetRefreshProgress(true);
            base.OnPageStarted(view, url, favicon);
        }

        public override void OnPageFinished(WebView? view, string? url)
        {
            activity.SetRefreshProgress(false);
            base.OnPageFinished(view, url);
        }

        public override bool ShouldOverrideUrlLoading(WebView? view, IWebResourceRequest? request)
        {
            return HandleUrl(request?.Url?.ToString());
        }

#pragma warning disable CS0672
        public override bool ShouldOverrideUrlLoading(WebView? view, string? url)
#pragma warning restore CS0672
        {
            return HandleUrl(url);
        }

        private bool HandleUrl(string? url)
        {
            if (string.Equals(url, AuthenticationRequiredUrl, StringComparison.OrdinalIgnoreCase))
            {
                activity.ShowNativeLogin();
                return true;
            }
            return false;
        }
    }

    private sealed class DashboardWebChromeClient(MainActivity activity) : WebChromeClient
    {
        public override bool OnJsConfirm(
            WebView? view,
            string? url,
            string? message,
            JsResult? result)
        {
            if (result is null)
            {
                return false;
            }

            var dialog = new AlertDialog.Builder(activity);
            dialog.SetTitle(Resource.String.app_name);
            dialog.SetMessage(message ?? "Confirm this action?");
            dialog.SetPositiveButton("Confirm", (_, _) => result.Confirm());
            dialog.SetNegativeButton("Cancel", (_, _) => result.Cancel());
            dialog.SetCancelable(false);
            dialog.Show();
            return true;
        }
    }

    private sealed class DashboardJavascriptBridge(MainActivity activity) : Java.Lang.Object
    {
        [JavascriptInterface]
        [Export("postMessage")]
        public void PostMessage(string message)
        {
            activity.HandleDashboardMessage(message);
        }
    }
}
