using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Net.WebSockets;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Windows.Forms;
using Microsoft.Win32;

var config = AgentConfig.Load();
var pcName = Environment.MachineName;
var serverUrl = $"{config.ServerUrl.TrimEnd('/')}/{Uri.EscapeDataString(pcName)}";

Console.WriteLine($"Starting agent for {pcName}");
Console.WriteLine($"Server: {serverUrl}");

Console.WriteLine("Removing unwanted applications...");
ApplicationUninstaller.UninstallUnwantedApplications();

Console.WriteLine("Removing unwanted startup applications...");
StartupUtilities.RemoveRobloxStartupEntries();

// Clean up desktop on startup
Console.WriteLine("Cleaning up desktop...");
DesktopUtilities.SetWindowsCustomTheme();
DesktopUtilities.SetDesktopBackgroundSolidBlack();
DesktopUtilities.DeleteDesktopFilesAndShortcuts();
DesktopUtilities.EmptyRecycleBinIfNeeded();
DesktopUtilities.ClearPinnedTaskbarShortcuts();
DesktopUtilities.SetDesktopIconSizeToSmall();
DesktopUtilities.AlignDesktopIconsToGrid();
DesktopUtilities.CreateChromeShortcutOnDesktop();
DesktopUtilities.CreateRobloxShortcutOnDesktop();
DesktopUtilities.CreateValorantShortcutOnDesktop();
DesktopUtilities.CreateGrandTheftAutoVShortcutOnDesktop();
DesktopUtilities.CloseOpenFileExplorerWindows();
Console.WriteLine("Desktop cleanup completed.");

while (true)
{
    using var socket = new ClientWebSocket();
    using var sendLock = new SemaphoreSlim(1, 1);
    using var screenMonitoring = new ScreenMonitoringSession(
        payload => SendJsonAsync(socket, sendLock, payload));

    try
    {
        socket.Options.SetRequestHeader("X-Client-Secret", config.ClientSecret);
        if (!string.IsNullOrWhiteSpace(config.Location))
        {
            socket.Options.SetRequestHeader("X-Client-Location", config.Location);
        }
        await socket.ConnectAsync(new Uri(serverUrl), CancellationToken.None);
        Console.WriteLine("Connected to server.");

        var receiveTask = ReceiveCommandsAsync(socket, sendLock, screenMonitoring);
        var heartbeatTask = SendHeartbeatsAsync(socket, sendLock);

        await Task.WhenAny(receiveTask, heartbeatTask);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Connection error: {ex.Message}");
    }

    Console.WriteLine("Reconnecting in 5 seconds...");
    await Task.Delay(TimeSpan.FromSeconds(5));
}

static async Task SendHeartbeatsAsync(ClientWebSocket socket, SemaphoreSlim sendLock)
{
    while (socket.State == WebSocketState.Open)
    {
        await SendJsonAsync(socket, sendLock, new
        {
            type = "heartbeat",
            active_application = WindowsActivity.GetActiveApplication(),
            applications = WindowsActivity.GetVisibleApplications(),
            idle_seconds = WindowsActivity.GetIdleSeconds(),
        });
        await Task.Delay(TimeSpan.FromSeconds(3));
    }
}

static async Task ReceiveCommandsAsync(
    ClientWebSocket socket,
    SemaphoreSlim sendLock,
    ScreenMonitoringSession screenMonitoring)
{
    var buffer = new byte[4096];

    while (socket.State == WebSocketState.Open)
    {
        using var messageBuffer = new MemoryStream();
        WebSocketReceiveResult result;

        do
        {
            result = await socket.ReceiveAsync(buffer, CancellationToken.None);

            if (result.MessageType == WebSocketMessageType.Close)
            {
                await socket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Server closed connection", CancellationToken.None);
                return;
            }

            messageBuffer.Write(buffer, 0, result.Count);
        } while (!result.EndOfMessage);

        var messageJson = Encoding.UTF8.GetString(messageBuffer.ToArray());
        using var document = JsonDocument.Parse(messageJson);

        if (!document.RootElement.TryGetProperty("type", out var typeProperty))
        {
            continue;
        }

        var type = typeProperty.GetString();
        if (!document.RootElement.TryGetProperty("command_id", out var commandIdProperty))
        {
            continue;
        }

        var commandId = commandIdProperty.GetString();
        if (string.IsNullOrWhiteSpace(commandId))
        {
            continue;
        }

        CommandOutcome outcome;
        switch (type)
        {
            case "shutdown":
                Console.WriteLine("Shutdown command received.");
                outcome = RunShutdownCommand("/s /t 2", "Shutdown scheduled.");
                break;
            case "restart":
                Console.WriteLine("Restart command received.");
                outcome = RunShutdownCommand("/r /t 2", "Restart scheduled.");
                break;
            case "close_application":
                if (document.RootElement.TryGetProperty("pid", out var pidProperty))
                {
                    outcome = CloseApplication(pidProperty.GetInt32());
                }
                else
                {
                    outcome = new CommandOutcome(false, "The command did not include a process ID.");
                }
                break;
            case "start_screen_monitoring":
                outcome = await screenMonitoring.StartAsync();
                break;
            case "stop_screen_monitoring":
                outcome = screenMonitoring.Stop();
                break;
            default:
                outcome = new CommandOutcome(false, $"Unknown command: {type}");
                break;
        }

        await SendJsonAsync(socket, sendLock, new
        {
            type = "command_result",
            command_id = commandId,
            success = outcome.Success,
            message = outcome.Message,
        });
    }
}

static async Task SendJsonAsync(ClientWebSocket socket, SemaphoreSlim sendLock, object payload)
{
    var json = JsonSerializer.Serialize(payload, new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
    });
    var bytes = Encoding.UTF8.GetBytes(json);
    await sendLock.WaitAsync();
    try
    {
        await socket.SendAsync(bytes, WebSocketMessageType.Text, true, CancellationToken.None);
    }
    finally
    {
        sendLock.Release();
    }
}

static CommandOutcome RunShutdownCommand(string arguments, string successMessage)
{
    try
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = "shutdown",
            Arguments = arguments,
            CreateNoWindow = true,
            UseShellExecute = false,
        };

        Process.Start(startInfo);
        return new CommandOutcome(true, successMessage);
    }
    catch (Exception ex)
    {
        return new CommandOutcome(false, ex.Message);
    }
}

static CommandOutcome CloseApplication(int pid)
{
    try
    {
        using var process = Process.GetProcessById(pid);
        Console.WriteLine($"Closing {process.ProcessName} ({pid}).");
        var closeRequested = process.CloseMainWindow();
        return closeRequested
            ? new CommandOutcome(true, $"Close request sent to {process.ProcessName}.")
            : new CommandOutcome(false, $"{process.ProcessName} did not accept the close request.");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Unable to close process {pid}: {ex.Message}");
        return new CommandOutcome(false, ex.Message);
    }
}

internal sealed record CommandOutcome(bool Success, string Message);
internal sealed record ApplicationInfo(int Pid, string ProcessName, string WindowTitle);

internal static class StartupUtilities
{
    private static readonly string[] StartupRegistryPaths =
    [
        @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        @"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
    ];

    private static readonly string[] StartupApprovedRegistryPaths =
    [
        @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
        @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32",
        @"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
    ];

    public static void RemoveRobloxStartupEntries()
    {
        var removedCount = 0;

        removedCount += RemoveRobloxRegistryStartupEntries();
        removedCount += RemoveRobloxStartupFolderEntries();

        Console.WriteLine(removedCount == 0
            ? "No Roblox startup entries were found."
            : $"Removed {removedCount} Roblox startup entries.");
    }

    private static int RemoveRobloxRegistryStartupEntries()
    {
        var removedCount = 0;

        foreach (var hive in new[] { Registry.CurrentUser, Registry.LocalMachine })
        {
            foreach (var registryPath in StartupRegistryPaths)
            {
                removedCount += RemoveMatchingRegistryValues(hive, registryPath, ValueMatchesRoblox);
            }

            foreach (var registryPath in StartupApprovedRegistryPaths)
            {
                removedCount += RemoveMatchingRegistryValues(hive, registryPath, NameMatchesRoblox);
            }
        }

        return removedCount;
    }

    private static int RemoveMatchingRegistryValues(
        RegistryKey hive,
        string registryPath,
        Func<string, object?, bool> isMatch)
    {
        try
        {
            using var key = hive.OpenSubKey(registryPath, writable: true);
            if (key is null)
            {
                return 0;
            }

            var removedCount = 0;
            foreach (var valueName in key.GetValueNames())
            {
                var value = key.GetValue(valueName);
                if (!isMatch(valueName, value))
                {
                    continue;
                }

                key.DeleteValue(valueName, throwOnMissingValue: false);
                removedCount++;
                Console.WriteLine($"Removed startup registry entry: {valueName}");
            }

            return removedCount;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error cleaning startup registry path {registryPath}: {ex.Message}");
            return 0;
        }
    }

    private static int RemoveRobloxStartupFolderEntries()
    {
        var startupFolders = new[]
        {
            Environment.GetFolderPath(Environment.SpecialFolder.Startup),
            Environment.GetFolderPath(Environment.SpecialFolder.CommonStartup),
        };

        var removedCount = 0;
        foreach (var startupFolder in startupFolders.Where(Directory.Exists).Distinct(StringComparer.OrdinalIgnoreCase))
        {
            foreach (var entry in Directory.EnumerateFileSystemEntries(startupFolder))
            {
                if (!Path.GetFileName(entry).Contains("Roblox", StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                try
                {
                    if (Directory.Exists(entry))
                    {
                        Directory.Delete(entry, recursive: true);
                    }
                    else
                    {
                        File.Delete(entry);
                    }

                    removedCount++;
                    Console.WriteLine($"Removed startup folder entry: {Path.GetFileName(entry)}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Could not remove startup folder entry {Path.GetFileName(entry)}: {ex.Message}");
                }
            }
        }

        return removedCount;
    }

    private static bool ValueMatchesRoblox(string name, object? value)
    {
        return NameMatchesRoblox(name, value) ||
            value?.ToString()?.Contains("Roblox", StringComparison.OrdinalIgnoreCase) == true;
    }

    private static bool NameMatchesRoblox(string name, object? _)
    {
        return name.Contains("Roblox", StringComparison.OrdinalIgnoreCase);
    }
}

internal static class ApplicationUninstaller
{
    private static readonly string[] UnwantedApplicationNames =
    [
        "Brave",
        "Brave Browser",
        "Opera",
        "Opera Stable",
        "Opera GX",
        "Opera GX Stable",
        "Firefox",
        "Mozilla Firefox",
        "Avast Secure Browser",
        "360 Total Security",
        "OP Auto Clicker",
        "TikTok Live Studio",
        "Wire VPN",
        "WPS Office",
    ];

    private static readonly string[] UninstallRegistryPaths =
    [
        @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        @"SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    ];

    private static readonly (string ApplicationName, string[] ProcessNames)[] UnwantedApplicationProcesses =
    [
        ("Brave", ["brave"]),
        ("Opera", ["opera", "opera_gx_splash", "opera_autoupdate", "opera_crashreporter", "opera_assistant", "browser_assistant"]),
        ("Firefox", ["firefox"]),
        ("Mozilla Firefox", ["firefox"]),
        ("Avast Secure Browser", ["AvastBrowser", "AvastBrowserCrashHandler", "AvastBrowserUpdate", "AvastBrowserElevationService", "AvastSecureBrowserElevationService"]),
        ("360 Total Security", ["360safe", "360tray", "QHSafeTray", "QHActiveDefense"]),
        ("OP Auto Clicker", ["AutoClicker", "OPAutoClicker"]),
        ("TikTok Live Studio", ["TikTok Live Studio", "TikTokLiveStudio", "TikTokLiveStudioLauncher"]),
        ("Wire VPN", ["WireVPN", "WireVPNpc", "WireGuard", "wireguard"]),
        ("WPS Office", ["wps", "wpp", "et", "wpscenter", "wpscloudsvr"]),
    ];

    public static void UninstallUnwantedApplications()
    {
        var applications = FindInstalledApplications()
            .DistinctBy(application => application.UninstallString ?? application.QuietUninstallString ?? application.DisplayName)
            .ToList();

        if (applications.Count == 0)
        {
            Console.WriteLine("No unwanted applications were found.");
        }

        foreach (var application in applications)
        {
            Uninstall(application);
        }

        RemoveOperaFallback();
        RemoveAvastSecureBrowserWpsOfficeAndWireVpnRemnants();
    }

    private static IEnumerable<InstalledApplication> FindInstalledApplications()
    {
        foreach (var application in FindInstalledApplicationsInHive(Registry.CurrentUser, "HKEY_CURRENT_USER"))
        {
            yield return application;
        }

        foreach (var application in FindInstalledApplicationsInHive(Registry.LocalMachine, "HKEY_LOCAL_MACHINE"))
        {
            yield return application;
        }

        foreach (var userSid in Registry.Users.GetSubKeyNames())
        {
            if (userSid.EndsWith("_Classes", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            using var userHive = Registry.Users.OpenSubKey(userSid);
            if (userHive is null)
            {
                continue;
            }

            foreach (var application in FindInstalledApplicationsInHive(userHive, $@"HKEY_USERS\{userSid}"))
            {
                yield return application;
            }
        }
    }

    private static IEnumerable<InstalledApplication> FindInstalledApplicationsInHive(RegistryKey hive, string hiveName)
    {
        foreach (var registryPath in UninstallRegistryPaths)
        {
            using var uninstallKey = hive.OpenSubKey(registryPath);
            if (uninstallKey is null)
            {
                continue;
            }

            foreach (var subKeyName in uninstallKey.GetSubKeyNames())
            {
                using var appKey = uninstallKey.OpenSubKey(subKeyName);
                if (appKey is null)
                {
                    continue;
                }

                var displayName = appKey.GetValue("DisplayName") as string;
                if (string.IsNullOrWhiteSpace(displayName) ||
                    !IsUnwantedApplication(displayName))
                {
                    continue;
                }

                var quietUninstallString = appKey.GetValue("QuietUninstallString") as string;
                var uninstallString = appKey.GetValue("UninstallString") as string;
                if (string.IsNullOrWhiteSpace(quietUninstallString) &&
                    string.IsNullOrWhiteSpace(uninstallString))
                {
                    Console.WriteLine($"{displayName} was found in {hiveName}\\{registryPath}\\{subKeyName} but has no uninstall command.");
                    continue;
                }

                yield return new InstalledApplication(
                    displayName,
                    quietUninstallString,
                    uninstallString,
                    $@"{hiveName}\{registryPath}\{subKeyName}");
            }
        }
    }

    private static void Uninstall(InstalledApplication application)
    {
        var commands = BuildUninstallCommands(application).ToList();
        if (commands.Count == 0)
        {
            Console.WriteLine($"Could not prepare uninstall command for {application.DisplayName}.");
            return;
        }

        try
        {
            Console.WriteLine($"Uninstalling {application.DisplayName} from {application.RegistryPath}...");
            StopRunningApplicationProcesses(application.DisplayName);

            foreach (var command in commands)
            {
                if (!File.Exists(command.FileName) && !IsMsiExec(command.FileName))
                {
                    Console.WriteLine($"Uninstall command skipped because file was not found: \"{command.FileName}\"");
                    continue;
                }

                Console.WriteLine($"Uninstall command: \"{command.FileName}\" {command.Arguments}");

                using var process = Process.Start(new ProcessStartInfo
                {
                    FileName = command.FileName,
                    Arguments = command.Arguments,
                    WorkingDirectory = Path.GetDirectoryName(command.FileName),
                    CreateNoWindow = true,
                    UseShellExecute = false,
                });

                if (process is null)
                {
                    Console.WriteLine($"Could not start uninstaller for {application.DisplayName}.");
                    continue;
                }

                if (!process.WaitForExit((int)TimeSpan.FromMinutes(3).TotalMilliseconds))
                {
                    Console.WriteLine($"{application.DisplayName} uninstaller is still running.");
                    continue;
                }

                if (process.ExitCode == 0)
                {
                    Console.WriteLine($"{application.DisplayName} uninstall command completed.");
                }
                else
                {
                    Console.WriteLine($"{application.DisplayName} uninstall command exited with code {process.ExitCode}.");
                }

                if (!IsOperaBrowser(application.DisplayName, command.FileName) || !File.Exists(command.FileName))
                {
                    break;
                }
            }

            if (IsOperaBrowser(application.DisplayName, application.UninstallString ?? application.QuietUninstallString ?? string.Empty))
            {
                RemoveOperaFallback(application.RegistryPath);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error uninstalling {application.DisplayName}: {ex.Message}");
        }
    }

    private static void StopRunningApplicationProcesses(string displayName)
    {
        var processNames = UnwantedApplicationProcesses
            .Where(entry => displayName.Contains(entry.ApplicationName, StringComparison.OrdinalIgnoreCase))
            .SelectMany(entry => entry.ProcessNames)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();

        if (processNames.Length == 0)
        {
            return;
        }

        foreach (var processName in processNames)
        {
            foreach (var process in Process.GetProcessesByName(processName))
            {
                using (process)
                {
                    try
                    {
                        Console.WriteLine($"Stopping running process before uninstall: {process.ProcessName}");
                        if (process.MainWindowHandle != IntPtr.Zero)
                        {
                            process.CloseMainWindow();
                            if (process.WaitForExit(5000))
                            {
                                continue;
                            }
                        }

                        process.Kill(entireProcessTree: true);
                        process.WaitForExit(5000);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Could not stop {process.ProcessName}: {ex.Message}");
                    }
                }
            }
        }
    }

    private static void RemoveOperaFallback(string? uninstallRegistryPath = null)
    {
        Console.WriteLine("Running Opera fallback cleanup...");
        StopRunningApplicationProcesses("Opera");

        foreach (var directory in GetOperaRemovalDirectories()
            .Where(Directory.Exists)
            .Distinct(StringComparer.OrdinalIgnoreCase))
        {
            TryDeleteDirectory(directory, "Opera");
        }

        foreach (var shortcut in GetOperaShortcutFiles()
            .Where(File.Exists)
            .Distinct(StringComparer.OrdinalIgnoreCase))
        {
            TryDeleteFile(shortcut, "Opera");
        }

        RemoveOperaStartupRegistryEntries();
        RemoveOperaScheduledTasks();
        RemoveOperaUninstallRegistryEntries();
        if (!string.IsNullOrWhiteSpace(uninstallRegistryPath))
        {
            TryDeleteRegistryKey(uninstallRegistryPath);
        }

        StopRunningApplicationProcesses("Opera");
    }

    private static void RemoveAvastSecureBrowserWpsOfficeAndWireVpnRemnants()
    {
        Console.WriteLine("Removing Avast Secure Browser, WPS Office, and Wire VPN remnants...");
        StopRunningApplicationProcesses("Avast Secure Browser");
        StopRunningApplicationProcesses("WPS Office");
        StopRunningApplicationProcesses("Wire VPN");
        StopAndDeleteWindowsServices("Avast Secure Browser", "AvastBrowser", "AvastSecureBrowser");
        RemoveScheduledTasksContaining("Avast Secure Browser", "Avast", "AvastBrowser", "AvastSecureBrowser");

        foreach (var directory in GetAvastSecureBrowserWpsOfficeAndWireVpnRemovalDirectories()
            .Where(Directory.Exists)
            .Distinct(StringComparer.OrdinalIgnoreCase))
        {
            var label = directory.Contains("WPS", StringComparison.OrdinalIgnoreCase) ||
                directory.Contains("Kingsoft", StringComparison.OrdinalIgnoreCase)
                ? "WPS Office"
                : directory.Contains("Wire", StringComparison.OrdinalIgnoreCase)
                    ? "Wire VPN"
                    : "Avast Secure Browser";
            TryDeleteDirectory(directory, label);
        }

        RemoveEmptyAvastWpsAndWireParentDirectories();

        StopRunningApplicationProcesses("Avast Secure Browser");
        StopRunningApplicationProcesses("WPS Office");
        StopRunningApplicationProcesses("Wire VPN");
    }

    private static void StopAndDeleteWindowsServices(string label, params string[] serviceNameParts)
    {
        foreach (var serviceName in GetWindowsServiceNames(serviceNameParts))
        {
            RunScCommand(label, "stop", serviceName);
            RunScCommand(label, "delete", serviceName);
        }
    }

    private static IEnumerable<string> GetWindowsServiceNames(string[] serviceNameParts)
    {
        using var servicesKey = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services");
        if (servicesKey is null)
        {
            yield break;
        }

        foreach (var serviceName in servicesKey.GetSubKeyNames())
        {
            using var serviceKey = servicesKey.OpenSubKey(serviceName);
            var displayName = serviceKey?.GetValue("DisplayName")?.ToString();
            var imagePath = serviceKey?.GetValue("ImagePath")?.ToString();
            if (serviceNameParts.Any(part =>
                    serviceName.Contains(part, StringComparison.OrdinalIgnoreCase) ||
                    displayName?.Contains(part, StringComparison.OrdinalIgnoreCase) == true ||
                    imagePath?.Contains(part, StringComparison.OrdinalIgnoreCase) == true))
            {
                yield return serviceName;
            }
        }
    }

    private static void RunScCommand(string label, string command, string serviceName)
    {
        try
        {
            using var process = Process.Start(new ProcessStartInfo
            {
                FileName = "sc.exe",
                Arguments = $"{command} \"{serviceName}\"",
                CreateNoWindow = true,
                UseShellExecute = false,
            });
            process?.WaitForExit(5000);
            Console.WriteLine($"{label} service {command} attempted: {serviceName}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not {command} {label} service {serviceName}: {ex.Message}");
        }
    }

    private static void RemoveScheduledTasksContaining(string label, params string[] patterns)
    {
        try
        {
            var scheduleServiceType = Type.GetTypeFromProgID("Schedule.Service");
            if (scheduleServiceType is null)
            {
                return;
            }

            dynamic scheduleService = Activator.CreateInstance(scheduleServiceType)
                ?? throw new InvalidOperationException("Could not start Task Scheduler COM service.");
            scheduleService.Connect();
            dynamic rootFolder = scheduleService.GetFolder("\\");
            RemoveScheduledTasksContainingFromFolder(rootFolder, label, patterns);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error removing {label} scheduled tasks: {ex.Message}");
        }
    }

    private static void RemoveScheduledTasksContainingFromFolder(dynamic folder, string label, string[] patterns)
    {
        try
        {
            dynamic tasks = folder.GetTasks(0);
            foreach (dynamic task in tasks)
            {
                try
                {
                    var taskName = task.Name as string ?? string.Empty;
                    var taskXml = task.Xml as string ?? string.Empty;
                    if (patterns.Any(pattern =>
                            taskName.Contains(pattern, StringComparison.OrdinalIgnoreCase) ||
                            taskXml.Contains(pattern, StringComparison.OrdinalIgnoreCase)))
                    {
                        folder.DeleteTask(taskName, 0);
                        Console.WriteLine($"Removed {label} scheduled task: {taskName}");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Could not remove {label} scheduled task: {ex.Message}");
                }
            }

            dynamic subFolders = folder.GetFolders(0);
            foreach (dynamic subFolder in subFolders)
            {
                RemoveScheduledTasksContainingFromFolder(subFolder, label, patterns);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not inspect {label} scheduled task folder: {ex.Message}");
        }
    }

    private static IEnumerable<string> GetAvastSecureBrowserWpsOfficeAndWireVpnRemovalDirectories()
    {
        var programRoots = new[]
        {
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86),
        }
        .Where(path => !string.IsNullOrWhiteSpace(path))
        .Distinct(StringComparer.OrdinalIgnoreCase);

        foreach (var programRoot in programRoots)
        {
            yield return Path.Combine(programRoot, "AVAST Software");
            yield return Path.Combine(programRoot, "Avast Software");
            yield return Path.Combine(programRoot, "AVAST Software", "Browser");
            yield return Path.Combine(programRoot, "Avast Software", "Browser");
            yield return Path.Combine(programRoot, "AvastSecureBrowser");
            yield return Path.Combine(programRoot, "Avast Secure Browser");
            yield return Path.Combine(programRoot, "WPS Office");
            yield return Path.Combine(programRoot, "Kingsoft", "WPS Office");
            yield return Path.Combine(programRoot, "WireVPNpc");
            yield return Path.Combine(programRoot, "Wire VPN");

            var commonFilesPath = Path.Combine(programRoot, "Common Files");
            yield return Path.Combine(commonFilesPath, "AVAST Software");
            yield return Path.Combine(commonFilesPath, "Avast Software");
            yield return Path.Combine(commonFilesPath, "AvastSecureBrowser");
            yield return Path.Combine(commonFilesPath, "Avast Secure Browser");
            yield return Path.Combine(commonFilesPath, "WPS Office");
            yield return Path.Combine(commonFilesPath, "Kingsoft", "WPS Office");
            yield return Path.Combine(commonFilesPath, "WireVPNpc");
            yield return Path.Combine(commonFilesPath, "Wire VPN");

            if (!Directory.Exists(programRoot))
            {
                continue;
            }

            foreach (var avastDirectory in Directory.EnumerateDirectories(programRoot, "*Avast*"))
            {
                var browserPath = Path.Combine(avastDirectory, "Browser");
                if (Directory.Exists(browserPath))
                {
                    yield return browserPath;
                }
            }

            foreach (var wpsDirectory in Directory.EnumerateDirectories(programRoot, "*WPS*"))
            {
                yield return wpsDirectory;
            }

            foreach (var wireDirectory in Directory.EnumerateDirectories(programRoot, "*Wire*"))
            {
                yield return wireDirectory;
            }

            if (!Directory.Exists(commonFilesPath))
            {
                continue;
            }

            foreach (var avastCommonDirectory in Directory.EnumerateDirectories(commonFilesPath, "*Avast*"))
            {
                yield return avastCommonDirectory;
            }

            foreach (var wpsCommonDirectory in Directory.EnumerateDirectories(commonFilesPath, "*WPS*"))
            {
                yield return wpsCommonDirectory;
            }

            foreach (var kingsoftCommonDirectory in Directory.EnumerateDirectories(commonFilesPath, "*Kingsoft*"))
            {
                yield return kingsoftCommonDirectory;
            }

            foreach (var wireCommonDirectory in Directory.EnumerateDirectories(commonFilesPath, "*Wire*"))
            {
                yield return wireCommonDirectory;
            }
        }

        var programDataPath = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
        if (!string.IsNullOrWhiteSpace(programDataPath) && Directory.Exists(programDataPath))
        {
            yield return Path.Combine(programDataPath, "AVAST Software");
            yield return Path.Combine(programDataPath, "Avast Software");
            yield return Path.Combine(programDataPath, "AVAST Software", "Browser");
            yield return Path.Combine(programDataPath, "Avast Software", "Browser");
            yield return Path.Combine(programDataPath, "AvastSecureBrowser");
            yield return Path.Combine(programDataPath, "Avast Secure Browser");
            yield return Path.Combine(programDataPath, "WPS Office");
            yield return Path.Combine(programDataPath, "Kingsoft", "WPS Office");
            yield return Path.Combine(programDataPath, "WireVPNpc");
            yield return Path.Combine(programDataPath, "Wire VPN");

            foreach (var avastDirectory in Directory.EnumerateDirectories(programDataPath, "*Avast*"))
            {
                if (Directory.Exists(Path.Combine(avastDirectory, "Browser")) ||
                    avastDirectory.Contains("Browser", StringComparison.OrdinalIgnoreCase))
                {
                    yield return avastDirectory;
                }
            }

            foreach (var wpsDirectory in Directory.EnumerateDirectories(programDataPath, "*WPS*"))
            {
                yield return wpsDirectory;
            }

            foreach (var kingsoftDirectory in Directory.EnumerateDirectories(programDataPath, "*Kingsoft*"))
            {
                yield return kingsoftDirectory;
            }

            foreach (var wireDirectory in Directory.EnumerateDirectories(programDataPath, "*Wire*"))
            {
                yield return wireDirectory;
            }
        }

        var usersRoot = Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile));
        if (string.IsNullOrWhiteSpace(usersRoot) || !Directory.Exists(usersRoot))
        {
            yield break;
        }

        foreach (var userDirectory in Directory.EnumerateDirectories(usersRoot))
        {
            foreach (var appDataFolder in new[] { "Local", "Roaming", "LocalLow" })
            {
                var appDataPath = Path.Combine(userDirectory, "AppData", appDataFolder);
                if (!Directory.Exists(appDataPath))
                {
                    continue;
                }

                yield return Path.Combine(appDataPath, "AVAST Software");
                yield return Path.Combine(appDataPath, "Avast Software");
                yield return Path.Combine(appDataPath, "AVAST Software", "Browser");
                yield return Path.Combine(appDataPath, "Avast Software", "Browser");
                yield return Path.Combine(appDataPath, "AvastSecureBrowser");
                yield return Path.Combine(appDataPath, "Avast Secure Browser");
                yield return Path.Combine(appDataPath, "WPS Office");
                yield return Path.Combine(appDataPath, "Kingsoft", "WPS Office");
                yield return Path.Combine(appDataPath, "WireVPNpc");
                yield return Path.Combine(appDataPath, "Wire VPN");

                foreach (var avastDirectory in Directory.EnumerateDirectories(appDataPath, "*Avast*"))
                {
                    if (Directory.Exists(Path.Combine(avastDirectory, "Browser")) ||
                        avastDirectory.Contains("Browser", StringComparison.OrdinalIgnoreCase))
                    {
                        yield return avastDirectory;
                    }
                }

                foreach (var wpsDirectory in Directory.EnumerateDirectories(appDataPath, "*WPS*"))
                {
                    yield return wpsDirectory;
                }

                foreach (var kingsoftDirectory in Directory.EnumerateDirectories(appDataPath, "*Kingsoft*"))
                {
                    yield return kingsoftDirectory;
                }

                foreach (var wireDirectory in Directory.EnumerateDirectories(appDataPath, "*Wire*"))
                {
                    yield return wireDirectory;
                }
            }
        }
    }

    private static void RemoveEmptyAvastWpsAndWireParentDirectories()
    {
        foreach (var directory in GetEmptyParentCleanupDirectories()
            .Where(Directory.Exists)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderByDescending(path => path.Length))
        {
            TryDeleteDirectoryIfEmpty(directory);
        }
    }

    private static IEnumerable<string> GetEmptyParentCleanupDirectories()
    {
        var programRoots = new[]
        {
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86),
            Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData),
        }
        .Where(path => !string.IsNullOrWhiteSpace(path))
        .Distinct(StringComparer.OrdinalIgnoreCase);

        foreach (var root in programRoots)
        {
            yield return Path.Combine(root, "AVAST Software");
            yield return Path.Combine(root, "Avast Software");
            yield return Path.Combine(root, "Kingsoft");
        }

        foreach (var programRoot in new[]
        {
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86),
        }.Where(path => !string.IsNullOrWhiteSpace(path)).Distinct(StringComparer.OrdinalIgnoreCase))
        {
            var commonFilesPath = Path.Combine(programRoot, "Common Files");
            yield return Path.Combine(commonFilesPath, "AVAST Software");
            yield return Path.Combine(commonFilesPath, "Avast Software");
            yield return Path.Combine(commonFilesPath, "Kingsoft");
        }

        var usersRoot = Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile));
        if (string.IsNullOrWhiteSpace(usersRoot) || !Directory.Exists(usersRoot))
        {
            yield break;
        }

        foreach (var userDirectory in Directory.EnumerateDirectories(usersRoot))
        {
            foreach (var appDataFolder in new[] { "Local", "Roaming", "LocalLow" })
            {
                var appDataPath = Path.Combine(userDirectory, "AppData", appDataFolder);
                yield return Path.Combine(appDataPath, "AVAST Software");
                yield return Path.Combine(appDataPath, "Avast Software");
                yield return Path.Combine(appDataPath, "Kingsoft");
            }
        }
    }

    private static IEnumerable<string> GetOperaRemovalDirectories()
    {
        foreach (var installRoot in GetOperaInstallRoots())
        {
            yield return installRoot;
        }

        var usersRoot = Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile));
        if (string.IsNullOrWhiteSpace(usersRoot) || !Directory.Exists(usersRoot))
        {
            yield break;
        }

        foreach (var userDirectory in Directory.EnumerateDirectories(usersRoot))
        {
            yield return Path.Combine(userDirectory, "AppData", "Local", "Opera Software");
            yield return Path.Combine(userDirectory, "AppData", "Roaming", "Opera Software");

            var localProgramsPath = Path.Combine(userDirectory, "AppData", "Local", "Programs");
            if (Directory.Exists(localProgramsPath))
            {
                foreach (var operaDirectory in Directory.EnumerateDirectories(localProgramsPath, "*Opera*"))
                {
                    yield return operaDirectory;
                }
            }
        }
    }

    private static IEnumerable<string> GetOperaShortcutFiles()
    {
        var shortcutRoots = new[]
        {
            Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
            Environment.GetFolderPath(Environment.SpecialFolder.CommonDesktopDirectory),
            Environment.GetFolderPath(Environment.SpecialFolder.StartMenu),
            Environment.GetFolderPath(Environment.SpecialFolder.CommonStartMenu),
        }
        .Where(path => !string.IsNullOrWhiteSpace(path) && Directory.Exists(path));

        foreach (var shortcutRoot in shortcutRoots)
        {
            foreach (var shortcut in Directory.EnumerateFiles(shortcutRoot, "*Opera*.lnk", SearchOption.AllDirectories))
            {
                yield return shortcut;
            }
        }

        var usersRoot = Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile));
        if (string.IsNullOrWhiteSpace(usersRoot) || !Directory.Exists(usersRoot))
        {
            yield break;
        }

        foreach (var userDirectory in Directory.EnumerateDirectories(usersRoot))
        {
            var userStartMenu = Path.Combine(userDirectory, "AppData", "Roaming", "Microsoft", "Windows", "Start Menu");
            if (!Directory.Exists(userStartMenu))
            {
                continue;
            }

            foreach (var shortcut in Directory.EnumerateFiles(userStartMenu, "*Opera*.lnk", SearchOption.AllDirectories))
            {
                yield return shortcut;
            }
        }
    }

    private static void RemoveOperaStartupRegistryEntries()
    {
        foreach (var hive in new[] { Registry.CurrentUser, Registry.LocalMachine })
        {
            RemoveOperaStartupRegistryEntriesFromHive(hive);
        }

        foreach (var userSid in Registry.Users.GetSubKeyNames())
        {
            if (userSid.EndsWith("_Classes", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            using var userHive = Registry.Users.OpenSubKey(userSid, writable: true);
            if (userHive is not null)
            {
                RemoveOperaStartupRegistryEntriesFromHive(userHive);
            }
        }
    }

    private static void RemoveOperaStartupRegistryEntriesFromHive(RegistryKey hive)
    {
        foreach (var runPath in new[]
        {
            @"Software\Microsoft\Windows\CurrentVersion\Run",
            @"Software\Microsoft\Windows\CurrentVersion\RunOnce",
        })
        {
            using var runKey = hive.OpenSubKey(runPath, writable: true);
            if (runKey is null)
            {
                continue;
            }

            foreach (var valueName in runKey.GetValueNames())
            {
                var value = runKey.GetValue(valueName)?.ToString();
                if (valueName.Contains("Opera", StringComparison.OrdinalIgnoreCase) ||
                    value?.Contains("Opera", StringComparison.OrdinalIgnoreCase) == true)
                {
                    runKey.DeleteValue(valueName, throwOnMissingValue: false);
                    Console.WriteLine($"Removed Opera startup registry entry: {valueName}");
                }
            }
        }
    }

    private static void RemoveOperaUninstallRegistryEntries()
    {
        foreach (var hive in new[] { Registry.CurrentUser, Registry.LocalMachine })
        {
            RemoveOperaUninstallRegistryEntriesFromHive(hive);
        }

        foreach (var userSid in Registry.Users.GetSubKeyNames())
        {
            if (userSid.EndsWith("_Classes", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            using var userHive = Registry.Users.OpenSubKey(userSid, writable: true);
            if (userHive is not null)
            {
                RemoveOperaUninstallRegistryEntriesFromHive(userHive);
            }
        }
    }

    private static void RemoveOperaScheduledTasks()
    {
        try
        {
            var scheduleServiceType = Type.GetTypeFromProgID("Schedule.Service");
            if (scheduleServiceType is null)
            {
                Console.WriteLine("Task Scheduler COM service is unavailable; Opera scheduled task cleanup skipped.");
                return;
            }

            dynamic scheduleService = Activator.CreateInstance(scheduleServiceType)
                ?? throw new InvalidOperationException("Could not start Task Scheduler COM service.");
            scheduleService.Connect();
            dynamic rootFolder = scheduleService.GetFolder("\\");

            RemoveOperaScheduledTasksFromFolder(rootFolder);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error removing Opera scheduled tasks: {ex.Message}");
        }
    }

    private static void RemoveOperaScheduledTasksFromFolder(dynamic folder)
    {
        try
        {
            dynamic tasks = folder.GetTasks(0);
            foreach (dynamic task in tasks)
            {
                try
                {
                    var taskName = task.Name as string ?? string.Empty;
                    var taskXml = task.Xml as string ?? string.Empty;
                    if (taskName.Contains("Opera", StringComparison.OrdinalIgnoreCase) ||
                        taskName.Contains("browser_assistant", StringComparison.OrdinalIgnoreCase) ||
                        taskXml.Contains("Opera", StringComparison.OrdinalIgnoreCase) ||
                        taskXml.Contains("browser_assistant", StringComparison.OrdinalIgnoreCase))
                    {
                        folder.DeleteTask(taskName, 0);
                        Console.WriteLine($"Removed Opera scheduled task: {taskName}");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Could not remove Opera scheduled task: {ex.Message}");
                }
            }

            dynamic subFolders = folder.GetFolders(0);
            foreach (dynamic subFolder in subFolders)
            {
                RemoveOperaScheduledTasksFromFolder(subFolder);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not inspect scheduled task folder: {ex.Message}");
        }
    }

    private static void RemoveOperaUninstallRegistryEntriesFromHive(RegistryKey hive)
    {
        foreach (var registryPath in UninstallRegistryPaths)
        {
            using var uninstallKey = hive.OpenSubKey(registryPath, writable: true);
            if (uninstallKey is null)
            {
                continue;
            }

            foreach (var subKeyName in uninstallKey.GetSubKeyNames())
            {
                using var appKey = uninstallKey.OpenSubKey(subKeyName);
                var displayName = appKey?.GetValue("DisplayName") as string;
                var uninstallString = appKey?.GetValue("UninstallString")?.ToString();
                var quietUninstallString = appKey?.GetValue("QuietUninstallString")?.ToString();

                if (displayName?.Contains("Opera", StringComparison.OrdinalIgnoreCase) == true ||
                    uninstallString?.Contains("Opera", StringComparison.OrdinalIgnoreCase) == true ||
                    quietUninstallString?.Contains("Opera", StringComparison.OrdinalIgnoreCase) == true)
                {
                    uninstallKey.DeleteSubKeyTree(subKeyName, throwOnMissingSubKey: false);
                    Console.WriteLine($"Removed Opera uninstall registry entry: {registryPath}\\{subKeyName}");
                }
            }
        }
    }

    private static void TryDeleteDirectory(string directory, string label)
    {
        try
        {
            ClearDirectoryAttributes(directory);
            Directory.Delete(directory, recursive: true);
            Console.WriteLine($"Removed {label} directory: {directory}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not remove {label} directory {directory}: {ex.Message}");
            ScheduleDirectoryDeletionOnReboot(directory, label);
        }
    }

    private static void ScheduleDirectoryDeletionOnReboot(string directory, string label)
    {
        try
        {
            foreach (var file in Directory.EnumerateFiles(directory, "*", SearchOption.AllDirectories))
            {
                _ = MoveFileEx(file, null, MoveFileFlags.DelayUntilReboot);
            }

            foreach (var childDirectory in Directory.EnumerateDirectories(directory, "*", SearchOption.AllDirectories)
                .OrderByDescending(path => path.Length))
            {
                _ = MoveFileEx(childDirectory, null, MoveFileFlags.DelayUntilReboot);
            }

            _ = MoveFileEx(directory, null, MoveFileFlags.DelayUntilReboot);
            Console.WriteLine($"{label} directory scheduled for deletion on reboot: {directory}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not schedule {label} directory for deletion on reboot {directory}: {ex.Message}");
        }
    }

    private static void TryDeleteDirectoryIfEmpty(string directory)
    {
        try
        {
            if (Directory.EnumerateFileSystemEntries(directory).Any())
            {
                return;
            }

            File.SetAttributes(directory, FileAttributes.Normal);
            Directory.Delete(directory);
            Console.WriteLine($"Removed empty remnant directory: {directory}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not remove empty remnant directory {directory}: {ex.Message}");
        }
    }

    private static void TryDeleteFile(string file, string label)
    {
        try
        {
            File.SetAttributes(file, FileAttributes.Normal);
            File.Delete(file);
            Console.WriteLine($"Removed {label} shortcut/file: {file}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not remove {label} shortcut/file {file}: {ex.Message}");
        }
    }

    private static void ClearDirectoryAttributes(string directoryPath)
    {
        foreach (var file in Directory.EnumerateFiles(directoryPath, "*", SearchOption.AllDirectories))
        {
            File.SetAttributes(file, FileAttributes.Normal);
        }

        foreach (var directory in Directory.EnumerateDirectories(directoryPath, "*", SearchOption.AllDirectories))
        {
            File.SetAttributes(directory, FileAttributes.Normal);
        }

        File.SetAttributes(directoryPath, FileAttributes.Normal);
    }

    private static void TryDeleteRegistryKey(string registryPath)
    {
        try
        {
            if (!TryOpenRegistryParent(registryPath, out var parentKey, out var subKeyName))
            {
                return;
            }

            var registryParent = parentKey;
            if (registryParent is null)
            {
                return;
            }

            using (registryParent)
            {
                registryParent.DeleteSubKeyTree(subKeyName, throwOnMissingSubKey: false);
            }

            Console.WriteLine($"Removed Opera uninstall registry entry: {registryPath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not remove Opera uninstall registry entry {registryPath}: {ex.Message}");
        }
    }

    private static bool TryOpenRegistryParent(string registryPath, out RegistryKey? parentKey, out string subKeyName)
    {
        parentKey = null;
        subKeyName = string.Empty;

        var separatorIndex = registryPath.LastIndexOf('\\');
        if (separatorIndex <= 0 || separatorIndex >= registryPath.Length - 1)
        {
            return false;
        }

        var parentPath = registryPath[..separatorIndex];
        subKeyName = registryPath[(separatorIndex + 1)..];

        parentKey = OpenRegistryKey(parentPath, writable: true);
        return parentKey is not null;
    }

    private static RegistryKey? OpenRegistryKey(string registryPath, bool writable)
    {
        foreach (var root in new[]
        {
            ("HKEY_CURRENT_USER", Registry.CurrentUser),
            ("HKEY_LOCAL_MACHINE", Registry.LocalMachine),
            ("HKEY_USERS", Registry.Users),
        })
        {
            if (registryPath.Equals(root.Item1, StringComparison.OrdinalIgnoreCase))
            {
                return root.Item2;
            }

            var prefix = root.Item1 + "\\";
            if (registryPath.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
            {
                return root.Item2.OpenSubKey(registryPath[prefix.Length..], writable);
            }
        }

        return null;
    }

    private static IEnumerable<UninstallCommand> BuildUninstallCommands(InstalledApplication application)
    {
        var commandLine = !string.IsNullOrWhiteSpace(application.QuietUninstallString)
            ? application.QuietUninstallString
            : application.UninstallString;

        if (string.IsNullOrWhiteSpace(commandLine) ||
            !TrySplitCommandLine(commandLine, out var fileName, out var arguments))
        {
            yield break;
        }

        if (IsAvastSecureBrowser(application.DisplayName, fileName))
        {
            fileName = FindAvastSecureBrowserSetup(fileName) ?? fileName;
            arguments = "--uninstall --multi-install --chrome --system-level --force-uninstall --silent";
            yield return new UninstallCommand(fileName, arguments);
            yield break;
        }

        if (IsOperaBrowser(application.DisplayName, fileName))
        {
            foreach (var launcherPath in FindOperaLaunchers(fileName))
            {
                yield return new UninstallCommand(launcherPath, "/uninstall /silent");
                yield return new UninstallCommand(launcherPath, "--uninstall --silent");
                yield return new UninstallCommand(launcherPath, "/uninstall /runimmediately /silent");
                yield return new UninstallCommand(launcherPath, "--uninstall --runimmediately --silent");
            }

            yield break;
        }

        if (IsMsiExec(fileName))
        {
            arguments = arguments
                .Replace("/I", "/X", StringComparison.OrdinalIgnoreCase)
                .Replace("-I", "/X", StringComparison.OrdinalIgnoreCase);

            if (!arguments.Contains("/qn", StringComparison.OrdinalIgnoreCase))
            {
                arguments += " /qn";
            }

            if (!arguments.Contains("/norestart", StringComparison.OrdinalIgnoreCase))
            {
                arguments += " /norestart";
            }
        }
        else
        {
            arguments = AddSilentArguments(application.DisplayName, fileName, arguments);
        }

        yield return new UninstallCommand(fileName, arguments.Trim());
    }

    private static string AddSilentArguments(string displayName, string fileName, string arguments)
    {
        if (displayName.Contains("Brave", StringComparison.OrdinalIgnoreCase) ||
            fileName.Contains("Brave", StringComparison.OrdinalIgnoreCase))
        {
            return AppendMissingArguments(arguments, "--force-uninstall", "--uninstall", "--silent");
        }

        if (displayName.Contains("Opera", StringComparison.OrdinalIgnoreCase) ||
            fileName.Contains("Opera", StringComparison.OrdinalIgnoreCase))
        {
            return AppendMissingArguments(arguments, "--uninstall", "--silent");
        }

        if (displayName.Contains("Firefox", StringComparison.OrdinalIgnoreCase) ||
            fileName.Contains("Firefox", StringComparison.OrdinalIgnoreCase))
        {
            return AppendMissingArguments(arguments, "/S");
        }

        if (displayName.Contains("OP Auto Clicker", StringComparison.OrdinalIgnoreCase))
        {
            return AppendMissingArguments(arguments, "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART");
        }

        if (displayName.Contains("360 Total Security", StringComparison.OrdinalIgnoreCase) ||
            displayName.Contains("Wire VPN", StringComparison.OrdinalIgnoreCase) ||
            displayName.Contains("WPS Office", StringComparison.OrdinalIgnoreCase))
        {
            return AppendMissingArguments(arguments, "/S");
        }

        if (displayName.Contains("TikTok Live Studio", StringComparison.OrdinalIgnoreCase))
        {
            return AppendMissingArguments(arguments, "/S");
        }

        return arguments;
    }

    private static bool IsAvastSecureBrowser(string displayName, string fileName)
    {
        return displayName.Contains("Avast Secure Browser", StringComparison.OrdinalIgnoreCase) ||
            fileName.Contains("Avast", StringComparison.OrdinalIgnoreCase);
    }

    private static string? FindAvastSecureBrowserSetup(string registryFileName)
    {
        if (File.Exists(registryFileName) &&
            string.Equals(Path.GetFileName(registryFileName), "setup.exe", StringComparison.OrdinalIgnoreCase))
        {
            return registryFileName;
        }

        var browserRoots = new[]
        {
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "AVAST Software", "Browser", "Application"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "AVAST Software", "Browser", "Application"),
        };

        foreach (var browserRoot in browserRoots.Where(Directory.Exists))
        {
            var setupPath = Directory.EnumerateDirectories(browserRoot)
                .Select(directory => Path.Combine(directory, "Installer", "setup.exe"))
                .Where(File.Exists)
                .OrderByDescending(File.GetLastWriteTimeUtc)
                .FirstOrDefault();

            if (setupPath is not null)
            {
                return setupPath;
            }
        }

        return null;
    }

    private static bool IsOperaBrowser(string displayName, string fileName)
    {
        return displayName.Contains("Opera", StringComparison.OrdinalIgnoreCase) ||
            fileName.Contains("Opera", StringComparison.OrdinalIgnoreCase);
    }

    private static IEnumerable<string> FindOperaLaunchers(string registryFileName)
    {
        if (File.Exists(registryFileName) &&
            string.Equals(Path.GetFileName(registryFileName), "launcher.exe", StringComparison.OrdinalIgnoreCase))
        {
            yield return registryFileName;
        }

        foreach (var launcherPath in GetOperaInstallRoots()
            .Where(Directory.Exists)
            .Select(root => Path.Combine(root, "launcher.exe"))
            .Where(File.Exists)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderByDescending(File.GetLastWriteTimeUtc))
        {
            yield return launcherPath;
        }
    }

    private static IEnumerable<string> GetOperaInstallRoots()
    {
        var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var operaFolderNames = new[] { "Opera GX", "Opera GX Stable", "Opera Browser", "Opera", "Opera Stable" };

        foreach (var folderName in operaFolderNames)
        {
            yield return Path.Combine(localAppData, "Programs", folderName);
            yield return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), folderName);
            yield return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), folderName);
        }

        var usersRoot = Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile));
        if (string.IsNullOrWhiteSpace(usersRoot) || !Directory.Exists(usersRoot))
        {
            yield break;
        }

        foreach (var userDirectory in Directory.EnumerateDirectories(usersRoot))
        {
            foreach (var folderName in operaFolderNames)
            {
                yield return Path.Combine(userDirectory, "AppData", "Local", "Programs", folderName);
            }
        }
    }

    private static bool IsUnwantedApplication(string displayName)
    {
        return UnwantedApplicationNames.Any(name =>
            displayName.Contains(name, StringComparison.OrdinalIgnoreCase));
    }

    private static string AppendMissingArguments(string arguments, params string[] additions)
    {
        foreach (var addition in additions)
        {
            if (!arguments.Contains(addition, StringComparison.OrdinalIgnoreCase))
            {
                arguments = string.IsNullOrWhiteSpace(arguments)
                    ? addition
                    : $"{arguments} {addition}";
            }
        }

        return arguments;
    }

    private static bool TrySplitCommandLine(string commandLine, out string fileName, out string arguments)
    {
        commandLine = commandLine.Trim();
        fileName = string.Empty;
        arguments = string.Empty;

        if (commandLine.Length == 0)
        {
            return false;
        }

        if (commandLine[0] == '"')
        {
            var closingQuoteIndex = commandLine.IndexOf('"', 1);
            if (closingQuoteIndex <= 1)
            {
                return false;
            }

            fileName = commandLine[1..closingQuoteIndex];
            arguments = commandLine[(closingQuoteIndex + 1)..].Trim();
            return true;
        }

        var exeIndex = commandLine.IndexOf(".exe", StringComparison.OrdinalIgnoreCase);
        if (exeIndex >= 0)
        {
            var executableEndIndex = exeIndex + ".exe".Length;
            fileName = commandLine[..executableEndIndex].Trim().Trim('"');
            arguments = commandLine[executableEndIndex..].Trim();
            return true;
        }

        var firstSpaceIndex = commandLine.IndexOf(' ');
        if (firstSpaceIndex < 0)
        {
            fileName = commandLine;
            return true;
        }

        fileName = commandLine[..firstSpaceIndex];
        arguments = commandLine[(firstSpaceIndex + 1)..].Trim();
        return true;
    }

    private static bool IsMsiExec(string fileName)
    {
        return string.Equals(Path.GetFileNameWithoutExtension(fileName), "msiexec", StringComparison.OrdinalIgnoreCase);
    }

    private sealed record InstalledApplication(
        string DisplayName,
        string? QuietUninstallString,
        string? UninstallString,
        string RegistryPath);

    private sealed record UninstallCommand(string FileName, string Arguments);

    [Flags]
    private enum MoveFileFlags
    {
        DelayUntilReboot = 0x00000004,
    }

    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern bool MoveFileEx(string existingFileName, string? newFileName, MoveFileFlags flags);
}

internal sealed class ScreenMonitoringSession : IDisposable
{
    private readonly Func<object, Task> _send;
    private readonly object _sync = new();
    private CancellationTokenSource? _cancellation;
    private Task? _captureTask;

    public ScreenMonitoringSession(Func<object, Task> send)
    {
        _send = send;
    }

    public async Task<CommandOutcome> StartAsync()
    {
        lock (_sync)
        {
            if (_cancellation is not null)
            {
                return new CommandOutcome(true, "Screen monitoring is already active.");
            }

            _cancellation = new CancellationTokenSource();
        }

        ScreenMonitoringIndicator.Show();

        try
        {
            await CaptureAndSendAsync();
            var cancellation = _cancellation;
            if (cancellation is not null)
            {
                _captureTask = CaptureLoopAsync(cancellation.Token);
            }
            return new CommandOutcome(true, "Screen monitoring started.");
        }
        catch (Exception ex)
        {
            Stop();
            return new CommandOutcome(false, $"Unable to capture the screen: {ex.Message}");
        }
    }

    public CommandOutcome Stop()
    {
        CancellationTokenSource? cancellation;
        lock (_sync)
        {
            cancellation = _cancellation;
            _cancellation = null;
            _captureTask = null;
        }

        cancellation?.Cancel();
        cancellation?.Dispose();
        ScreenMonitoringIndicator.Hide();

        return cancellation is null
            ? new CommandOutcome(true, "Screen monitoring was already stopped.")
            : new CommandOutcome(true, "Screen monitoring stopped.");
    }

    public void Dispose()
    {
        Stop();
    }

    private async Task CaptureLoopAsync(CancellationToken cancellationToken)
    {
        try
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                await Task.Delay(TimeSpan.FromSeconds(1), cancellationToken);
                await CaptureAndSendAsync();
            }
        }
        catch (OperationCanceledException)
        {
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Screen monitoring stopped: {ex.Message}");
            Stop();
        }
    }

    private Task CaptureAndSendAsync()
    {
        return _send(new
        {
            type = "screenshot",
            image_data = ScreenCapture.CaptureJpegDataUrl(),
            captured_at = DateTimeOffset.UtcNow,
        });
    }
}

internal static class ScreenCapture
{
    public static string CaptureJpegDataUrl()
    {
        var bounds = SystemInformation.VirtualScreen;
        using var screenshot = new Bitmap(bounds.Width, bounds.Height, PixelFormat.Format24bppRgb);
        using (var graphics = Graphics.FromImage(screenshot))
        {
            graphics.CopyFromScreen(bounds.Left, bounds.Top, 0, 0, bounds.Size);
        }

        const int maxWidth = 1280;
        var outputWidth = Math.Min(screenshot.Width, maxWidth);
        var outputHeight = (int)Math.Round(screenshot.Height * (outputWidth / (double)screenshot.Width));

        using var output = new Bitmap(outputWidth, outputHeight, PixelFormat.Format24bppRgb);
        using (var graphics = Graphics.FromImage(output))
        {
            graphics.DrawImage(screenshot, 0, 0, outputWidth, outputHeight);
        }

        using var stream = new MemoryStream();
        var jpegEncoder = ImageCodecInfo.GetImageEncoders()
            .First(encoder => encoder.MimeType == "image/jpeg");
        using var encoderParameters = new EncoderParameters(1);
        encoderParameters.Param[0] = new EncoderParameter(
            System.Drawing.Imaging.Encoder.Quality,
            55L);
        output.Save(stream, jpegEncoder, encoderParameters);

        return $"data:image/jpeg;base64,{Convert.ToBase64String(stream.ToArray())}";
    }
}

internal static class ScreenMonitoringIndicator
{
    private static readonly object Sync = new();
    private static MonitoringIndicatorForm? _form;

    public static void Show()
    {
        lock (Sync)
        {
            if (_form is not null)
            {
                return;
            }
        }

        using var ready = new ManualResetEventSlim();
        var thread = new Thread(() =>
        {
            using var form = new MonitoringIndicatorForm();
            form.Shown += (_, _) => ready.Set();
            lock (Sync)
            {
                _form = form;
            }
            Application.Run(form);
            lock (Sync)
            {
                _form = null;
            }
        })
        {
            IsBackground = true,
            Name = "Screen monitoring indicator",
        };
        thread.SetApartmentState(ApartmentState.STA);
        thread.Start();
        ready.Wait();
    }

    public static void Hide()
    {
        MonitoringIndicatorForm? form;
        lock (Sync)
        {
            form = _form;
        }

        if (form?.IsHandleCreated == true)
        {
            form.BeginInvoke((Action)form.Close);
        }
    }
}

internal sealed class MonitoringIndicatorForm : Form
{
    public MonitoringIndicatorForm()
    {
        AutoScaleMode = AutoScaleMode.Dpi;
        BackColor = Color.Firebrick;
        ClientSize = new Size(110, 34);
        FormBorderStyle = FormBorderStyle.None;
        ShowInTaskbar = false;
        StartPosition = FormStartPosition.Manual;
        TopMost = true;

        Controls.Add(new Label
        {
            Dock = DockStyle.Fill,
            ForeColor = Color.White,
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            Text = "Recording",
            TextAlign = ContentAlignment.MiddleCenter,
        });

        var workingArea = Screen.PrimaryScreen?.WorkingArea ?? SystemInformation.WorkingArea;
        Location = new Point(workingArea.Right - Width - 12, workingArea.Top + 12);
    }
}

internal static class WindowsActivity
{
    public static uint GetIdleSeconds()
    {
        var inputInfo = new LastInputInfo
        {
            Size = (uint)Marshal.SizeOf<LastInputInfo>(),
        };

        if (!GetLastInputInfo(ref inputInfo))
        {
            return 0;
        }

        var elapsedMilliseconds = unchecked((uint)Environment.TickCount - inputInfo.Time);
        return elapsedMilliseconds / 1000;
    }

    public static ApplicationInfo? GetActiveApplication()
    {
        var windowHandle = GetForegroundWindow();
        if (windowHandle == IntPtr.Zero)
        {
            return null;
        }

        GetWindowThreadProcessId(windowHandle, out var processId);

        try
        {
            using var process = Process.GetProcessById((int)processId);
            return new ApplicationInfo(process.Id, process.ProcessName, GetWindowTitle(windowHandle));
        }
        catch
        {
            return null;
        }
    }

    public static IReadOnlyList<ApplicationInfo> GetVisibleApplications()
    {
        var currentProcessId = Environment.ProcessId;
        var applications = new List<ApplicationInfo>();

        foreach (var process in Process.GetProcesses())
        {
            using (process)
            {
                try
                {
                    if (process.Id == currentProcessId ||
                        process.MainWindowHandle == IntPtr.Zero ||
                        string.IsNullOrWhiteSpace(process.MainWindowTitle))
                    {
                        continue;
                    }

                    applications.Add(new ApplicationInfo(
                        process.Id,
                        process.ProcessName,
                        process.MainWindowTitle));
                }
                catch
                {
                    // Processes can exit or become inaccessible while being inspected.
                }
            }
        }

        return applications
            .OrderBy(application => application.ProcessName, StringComparer.OrdinalIgnoreCase)
            .ToList();
    }

    private static string GetWindowTitle(IntPtr windowHandle)
    {
        var length = GetWindowTextLength(windowHandle);
        if (length == 0)
        {
            return string.Empty;
        }

        var title = new StringBuilder(length + 1);
        GetWindowText(windowHandle, title, title.Capacity);
        return title.ToString();
    }

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    private static extern uint GetWindowThreadProcessId(IntPtr windowHandle, out uint processId);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern int GetWindowText(IntPtr windowHandle, StringBuilder text, int maxCount);

    [DllImport("user32.dll")]
    private static extern int GetWindowTextLength(IntPtr windowHandle);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool GetLastInputInfo(ref LastInputInfo inputInfo);

    [StructLayout(LayoutKind.Sequential)]
    private struct LastInputInfo
    {
        public uint Size;
        public uint Time;
    }
}

internal static class DesktopUtilities
{
    private delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SendMessageTimeout(IntPtr hWnd, int msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    private static extern IntPtr FindWindow(string? className, string? windowName);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    private static extern IntPtr FindWindowEx(IntPtr parent, IntPtr childAfter, string? className, string? windowName);

    [DllImport("user32.dll")]
    private static extern bool EnumWindows(EnumWindowsProc callback, IntPtr lParam);

    [DllImport("user32.dll")]
    private static extern IntPtr SendMessage(IntPtr hWnd, uint message, IntPtr wParam, IntPtr lParam);

    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    private static extern int SHEmptyRecycleBin(IntPtr hwnd, string? pszRootPath, uint dwFlags);

    private static void SendSettingChange(string setting)
    {
        const int WM_SETTINGCHANGE = 0x001A;
        const uint HWND_BROADCAST = 0xFFFF;
        _ = SendMessageTimeout(new IntPtr(HWND_BROADCAST), WM_SETTINGCHANGE, IntPtr.Zero, setting, 2, 1000, out _);
    }

    public static void SetWindowsCustomTheme()
    {
        const int appsUseLightTheme = 1;
        const int systemUsesLightTheme = 0;

        try
        {
            using var key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize");
            if (key is not null)
            {
                var currentAppsUseLightTheme = key.GetValue("AppsUseLightTheme");
                var currentSystemUsesLightTheme = key.GetValue("SystemUsesLightTheme");
                if (currentAppsUseLightTheme is appsUseLightTheme &&
                    currentSystemUsesLightTheme is systemUsesLightTheme)
                {
                    Console.WriteLine("Custom theme already applied.");
                    return;
                }

                key.SetValue("AppsUseLightTheme", appsUseLightTheme, RegistryValueKind.DWord);
                key.SetValue("SystemUsesLightTheme", systemUsesLightTheme, RegistryValueKind.DWord);
                Console.WriteLine("Custom theme enabled: Windows mode dark, app mode light.");
            }

            SendSettingChange("ImmersiveColorSet");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error setting Windows dark theme: {ex.Message}");
        }
    }

    public static void SetDesktopBackgroundSolidBlack()
    {
        const string wallpaper = "";
        const string wallpaperStyle = "0";
        const string tileWallpaper = "0";
        const string background = "0 0 0";

        try
        {
            var desktopAlreadyConfigured = false;
            var colorAlreadyConfigured = false;

            using var desktopKey = Registry.CurrentUser.OpenSubKey(@"Control Panel\Desktop", writable: true);
            if (desktopKey is not null)
            {
                desktopAlreadyConfigured =
                    string.Equals(desktopKey.GetValue("Wallpaper") as string, wallpaper, StringComparison.Ordinal) &&
                    string.Equals(desktopKey.GetValue("WallpaperStyle") as string, wallpaperStyle, StringComparison.Ordinal) &&
                    string.Equals(desktopKey.GetValue("TileWallpaper") as string, tileWallpaper, StringComparison.Ordinal);

                if (!desktopAlreadyConfigured)
                {
                    desktopKey.SetValue("Wallpaper", wallpaper, RegistryValueKind.String);
                    desktopKey.SetValue("WallpaperStyle", wallpaperStyle, RegistryValueKind.String);
                    desktopKey.SetValue("TileWallpaper", tileWallpaper, RegistryValueKind.String);
                    Console.WriteLine("Desktop wallpaper configured for solid black.");
                }
            }

            using var colorKey = Registry.CurrentUser.OpenSubKey(@"Control Panel\Colors", writable: true);
            if (colorKey is not null)
            {
                colorAlreadyConfigured = string.Equals(
                    colorKey.GetValue("Background") as string,
                    background,
                    StringComparison.Ordinal);

                if (!colorAlreadyConfigured)
                {
                    colorKey.SetValue("Background", background, RegistryValueKind.String);
                    Console.WriteLine("Desktop background color set to black.");
                }
            }

            if (desktopAlreadyConfigured && colorAlreadyConfigured)
            {
                Console.WriteLine("Desktop background already configured for solid black.");
                return;
            }

            SendSettingChange("Environment");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error setting desktop background color: {ex.Message}");
        }
    }

    public static void SetDesktopIconSizeToSmall()
    {
        try
        {
            const int smallIconSize = 32;
            var alreadyConfigured = false;
            using var key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\Shell\Bags\1\Desktop");
            if (key is not null)
            {
                alreadyConfigured = key.GetValue("IconSize") is smallIconSize;
                if (!alreadyConfigured)
                {
                    key.SetValue("IconSize", smallIconSize, RegistryValueKind.DWord);
                }
            }

            if (alreadyConfigured)
            {
                Console.WriteLine("Desktop icon size already set to small.");
                return;
            }

            var desktopView = FindDesktopShellView();
            if (desktopView != IntPtr.Zero)
            {
                const uint WM_COMMAND = 0x0111;
                var smallIconsCommand = new IntPtr(28715);
                _ = SendMessage(desktopView, WM_COMMAND, smallIconsCommand, IntPtr.Zero);
                Console.WriteLine("Desktop icon size set to small.");
            }
            else
            {
                Console.WriteLine("Desktop view was not available; small icon size will apply when Explorer refreshes.");
            }

            SendSettingChange("ShellState");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error setting desktop icon size: {ex.Message}");
        }
    }

    private static IntPtr FindDesktopShellView()
    {
        var progman = FindWindow("Progman", null);
        var shellView = FindWindowEx(progman, IntPtr.Zero, "SHELLDLL_DefView", null);
        if (shellView != IntPtr.Zero)
        {
            return shellView;
        }

        _ = EnumWindows((window, _) =>
        {
            shellView = FindWindowEx(window, IntPtr.Zero, "SHELLDLL_DefView", null);
            return shellView == IntPtr.Zero;
        }, IntPtr.Zero);

        return shellView;
    }

    public static void AlignDesktopIconsToGrid()
    {
        try
        {
            const int mode = 2;
            const int arrangeBy = 4;
            const int groupView = 0;
            var alreadyConfigured = false;

            using var key = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\Shell\Bags\1\Desktop", writable: true);
            if (key is not null)
            {
                alreadyConfigured =
                    key.GetValue("Mode") is mode &&
                    key.GetValue("ArrangeBy") is arrangeBy &&
                    key.GetValue("GroupView") is groupView;

                if (!alreadyConfigured)
                {
                    key.SetValue("Mode", mode, RegistryValueKind.DWord);
                    key.SetValue("ArrangeBy", arrangeBy, RegistryValueKind.DWord);
                    key.SetValue("GroupView", groupView, RegistryValueKind.DWord);
                    Console.WriteLine("Desktop icon grid alignment configured.");
                }
            }

            if (alreadyConfigured)
            {
                Console.WriteLine("Desktop icons are already aligned to grid.");
                return;
            }

            try
            {
                dynamic shell = Activator.CreateInstance(Type.GetTypeFromProgID("Shell.Application"));
                dynamic desktop = shell.NameSpace(0);
                if (desktop is not null)
                {
                    dynamic items = desktop.Items();
                    if (items is not null)
                    {
                        int count = items.Count;
                        Console.WriteLine($"Desktop items aligned: {count} items found.");
                    }
                }
            }
            catch
            {
                // COM-based method is optional
            }

            SendSettingChange("ShellState");
            Console.WriteLine("Desktop icons aligned to grid.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error aligning desktop icons to grid: {ex.Message}");
        }
    }

    public static void CreateRobloxShortcutOnDesktop()
    {
        try
        {
            string? robloxExePath = null;
            string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string robloxBasePath = Path.Combine(localAppData, "Roblox");

            if (Directory.Exists(robloxBasePath))
            {
                string versionsPath = Path.Combine(robloxBasePath, "Versions");
                if (Directory.Exists(versionsPath))
                {
                    var versionDirs = new DirectoryInfo(versionsPath)
                        .EnumerateDirectories()
                        .OrderByDescending(directory => directory.LastWriteTimeUtc);
                    foreach (var versionDir in versionDirs)
                    {
                        string[] possibleExePaths = new[]
                        {
                            Path.Combine(versionDir.FullName, "RobloxPlayerBeta.exe"),
                            Path.Combine(versionDir.FullName, "RobloxPlayerLauncher.exe"),
                            Path.Combine(versionDir.FullName, "RobloxPlayer.exe"),
                        };

                        foreach (var exePath in possibleExePaths)
                        {
                            if (File.Exists(exePath))
                            {
                                robloxExePath = exePath;
                                break;
                            }
                        }

                        if (robloxExePath != null)
                            break;
                    }
                }
            }

            if (robloxExePath == null)
            {
                string[] robloxProgramPaths = new[]
                {
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "Roblox", "Versions"),
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "Roblox", "Versions"),
                };

                foreach (var programPath in robloxProgramPaths)
                {
                    if (Directory.Exists(programPath))
                    {
                        var versionDirs = new DirectoryInfo(programPath)
                            .EnumerateDirectories()
                            .OrderByDescending(directory => directory.LastWriteTimeUtc);
                        foreach (var versionDir in versionDirs)
                        {
                            var possibleExePaths = new[]
                            {
                                Path.Combine(versionDir.FullName, "RobloxPlayerBeta.exe"),
                                Path.Combine(versionDir.FullName, "RobloxPlayerLauncher.exe"),
                                Path.Combine(versionDir.FullName, "RobloxPlayer.exe"),
                            };
                            robloxExePath = possibleExePaths.FirstOrDefault(File.Exists);
                            if (robloxExePath is not null)
                            {
                                break;
                            }
                        }

                        if (robloxExePath != null)
                            break;
                    }
                }
            }

            if (robloxExePath == null)
            {
                Console.WriteLine("Roblox not found in common installation paths.");
                return;
            }

            string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            string shortcutPath = Path.Combine(desktopPath, "Roblox.lnk");

            var shellType = Type.GetTypeFromProgID("WScript.Shell")
                ?? throw new InvalidOperationException("Windows Script Host is unavailable.");
            dynamic shell = Activator.CreateInstance(shellType)
                ?? throw new InvalidOperationException("Could not start Windows Script Host.");
            dynamic shortcut = shell.CreateShortcut(shortcutPath);

            shortcut.TargetPath = robloxExePath;
            shortcut.WorkingDirectory = Path.GetDirectoryName(robloxExePath);
            shortcut.Description = "Roblox Player";
            shortcut.IconLocation = robloxExePath;
            shortcut.Save();

            Console.WriteLine($"Roblox shortcut created at: {shortcutPath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error creating Roblox shortcut: {ex.Message}");
        }
    }

    public static void CreateGrandTheftAutoVShortcutOnDesktop()
    {
        const string executablePath = @"C:\Games\Grand Theft Auto V\PlayGTAV.exe";

        try
        {
            if (!File.Exists(executablePath))
            {
                Console.WriteLine($"Grand Theft Auto V was not found at: {executablePath}");
                return;
            }

            var desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            var shortcutPath = Path.Combine(desktopPath, "Grand Theft Auto V.lnk");
            var shellType = Type.GetTypeFromProgID("WScript.Shell")
                ?? throw new InvalidOperationException("Windows Script Host is unavailable.");
            dynamic shell = Activator.CreateInstance(shellType)
                ?? throw new InvalidOperationException("Could not start Windows Script Host.");
            dynamic shortcut = shell.CreateShortcut(shortcutPath);

            shortcut.TargetPath = executablePath;
            shortcut.WorkingDirectory = Path.GetDirectoryName(executablePath);
            shortcut.Description = "Grand Theft Auto V";
            shortcut.IconLocation = executablePath;
            shortcut.Save();

            Console.WriteLine($"Grand Theft Auto V shortcut created at: {shortcutPath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error creating Grand Theft Auto V shortcut: {ex.Message}");
        }
    }

    public static void CreateValorantShortcutOnDesktop()
    {
        try
        {
            var riotClientPath = FindValorantRiotClientPath();
            if (riotClientPath is null)
            {
                Console.WriteLine("Valorant Riot Client was not found in common installation paths.");
                return;
            }

            var valorantIconPath = FindValorantIconPath() ?? riotClientPath;
            var desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            var shortcutPath = Path.Combine(desktopPath, "VALORANT.lnk");
            CreateDesktopShortcut(
                shortcutPath,
                riotClientPath,
                Path.GetDirectoryName(riotClientPath),
                "VALORANT",
                valorantIconPath,
                "--launch-product=valorant --launch-patchline=live");

            Console.WriteLine($"Valorant shortcut created at: {shortcutPath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error creating Valorant shortcut: {ex.Message}");
        }
    }

    private static string? FindValorantRiotClientPath()
    {
        var commonPaths = new[]
        {
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "Riot Games", "Riot Client", "RiotClientServices.exe"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "Riot Games", "Riot Client", "RiotClientServices.exe"),
            @"C:\Riot Games\Riot Client\RiotClientServices.exe",
        };

        var riotClientPath = commonPaths.FirstOrDefault(File.Exists);
        if (riotClientPath is not null)
        {
            return riotClientPath;
        }

        var localRiotMetadataPath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData),
            "Riot Games",
            "Metadata",
            "valorant.live",
            "valorant.live.product_settings.yaml");

        if (!File.Exists(localRiotMetadataPath))
        {
            return null;
        }

        foreach (var line in File.ReadLines(localRiotMetadataPath))
        {
            const string installPathKey = "product_install_full_path:";
            var trimmedLine = line.Trim();
            if (!trimmedLine.StartsWith(installPathKey, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var installPath = trimmedLine[installPathKey.Length..].Trim().Trim('"', '\'');
            if (string.IsNullOrWhiteSpace(installPath))
            {
                continue;
            }

            var metadataRiotClientPath = Path.Combine(
                Directory.GetParent(installPath)?.Parent?.FullName ?? string.Empty,
                "Riot Client",
                "RiotClientServices.exe");
            if (File.Exists(metadataRiotClientPath))
            {
                return metadataRiotClientPath;
            }
        }

        return null;
    }

    private static string? FindValorantIconPath()
    {
        var commonPaths = new[]
        {
            Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData),
                "Riot Games",
                "Metadata",
                "valorant.live",
                "valorant.live.ico"),
            @"C:\Riot Games\VALORANT\live\VALORANT.exe",
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "Riot Games", "VALORANT", "live", "VALORANT.exe"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "Riot Games", "VALORANT", "live", "VALORANT.exe"),
            @"C:\Riot Games\VALORANT\live\ShooterGame\Binaries\Win64\VALORANT-Win64-Shipping.exe",
        };

        var iconPath = commonPaths.FirstOrDefault(File.Exists);
        if (iconPath is not null)
        {
            return iconPath;
        }

        var installPath = FindValorantInstallPathFromMetadata();
        if (installPath is null)
        {
            return null;
        }

        var metadataPaths = new[]
        {
            Path.Combine(installPath, "VALORANT.exe"),
            Path.Combine(installPath, "ShooterGame", "Binaries", "Win64", "VALORANT-Win64-Shipping.exe"),
        };

        return metadataPaths.FirstOrDefault(File.Exists);
    }

    private static string? FindValorantInstallPathFromMetadata()
    {
        var localRiotMetadataPath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData),
            "Riot Games",
            "Metadata",
            "valorant.live",
            "valorant.live.product_settings.yaml");

        if (!File.Exists(localRiotMetadataPath))
        {
            return null;
        }

        foreach (var line in File.ReadLines(localRiotMetadataPath))
        {
            const string installPathKey = "product_install_full_path:";
            var trimmedLine = line.Trim();
            if (!trimmedLine.StartsWith(installPathKey, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var installPath = trimmedLine[installPathKey.Length..].Trim().Trim('"', '\'');
            return string.IsNullOrWhiteSpace(installPath) ? null : installPath;
        }

        return null;
    }

    public static void CreateChromeShortcutOnDesktop()
    {
        try
        {
            string[] chromePaths = new[]
            {
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "Google", "Chrome", "Application", "chrome.exe"),
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "Google", "Chrome", "Application", "chrome.exe"),
                Path.Combine(Environment.GetEnvironmentVariable("LOCALAPPDATA"), "Google", "Chrome", "Application", "chrome.exe"),
                Path.Combine(Environment.GetEnvironmentVariable("ProgramFiles"), "Google", "Chrome", "Application", "chrome.exe"),
            };

            string chromeExePath = null;
            foreach (var path in chromePaths)
            {
                if (File.Exists(path))
                {
                    chromeExePath = path;
                    break;
                }
            }

            if (chromeExePath == null)
            {
                Console.WriteLine("Google Chrome not found in common installation paths.");
                return;
            }

            string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            string shortcutPath = Path.Combine(desktopPath, "Google Chrome.lnk");

            dynamic shell = Activator.CreateInstance(Type.GetTypeFromProgID("WScript.Shell"));
            dynamic shortcut = shell.CreateShortcut(shortcutPath);

            shortcut.TargetPath = chromeExePath;
            shortcut.WorkingDirectory = Path.GetDirectoryName(chromeExePath);
            shortcut.Description = "Google Chrome Web Browser";
            shortcut.IconLocation = chromeExePath;
            shortcut.Save();

            Console.WriteLine($"Google Chrome shortcut created at: {shortcutPath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error creating Chrome shortcut: {ex.Message}");
        }
    }

    private static void CreateDesktopShortcut(
        string shortcutPath,
        string targetPath,
        string? workingDirectory,
        string description,
        string iconLocation,
        string arguments = "")
    {
        var shellType = Type.GetTypeFromProgID("WScript.Shell")
            ?? throw new InvalidOperationException("Windows Script Host is unavailable.");
        dynamic shell = Activator.CreateInstance(shellType)
            ?? throw new InvalidOperationException("Could not start Windows Script Host.");
        dynamic shortcut = shell.CreateShortcut(shortcutPath);

        shortcut.TargetPath = targetPath;
        shortcut.WorkingDirectory = workingDirectory ?? Path.GetDirectoryName(targetPath);
        shortcut.Description = description;
        shortcut.IconLocation = iconLocation;
        shortcut.Arguments = arguments;
        shortcut.Save();
    }

    public static void DeleteDesktopFilesAndShortcuts()
    {
        try
        {
            var desktopPaths = new[]
            {
                Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
                Environment.GetFolderPath(Environment.SpecialFolder.CommonDesktopDirectory),
            }
            .Where(path => !string.IsNullOrWhiteSpace(path))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();

            var deletedCount = 0;

            foreach (var desktopPath in desktopPaths)
            {
                if (!Directory.Exists(desktopPath))
                {
                    Console.WriteLine($"Desktop directory not found: {desktopPath}");
                    continue;
                }

                Console.WriteLine($"Cleaning desktop directory: {desktopPath}");

                foreach (var file in Directory.GetFiles(desktopPath))
                {
                    try
                    {
                        ClearFileAttributes(file);
                        File.Delete(file);
                        deletedCount++;
                        Console.WriteLine($"Deleted: {Path.GetFileName(file)}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Could not delete {Path.GetFileName(file)}: {ex.Message}");
                    }
                }

                foreach (var dir in Directory.GetDirectories(desktopPath))
                {
                    try
                    {
                        ClearDirectoryAttributes(dir);
                        Directory.Delete(dir, recursive: true);
                        deletedCount++;
                        Console.WriteLine($"Deleted folder: {Path.GetFileName(dir)}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Could not delete folder {Path.GetFileName(dir)}: {ex.Message}");
                    }
                }
            }

            Console.WriteLine($"Desktop cleanup completed. {deletedCount} items removed.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error deleting desktop files and shortcuts: {ex.Message}");
        }
    }

    private static void ClearFileAttributes(string filePath)
    {
        File.SetAttributes(filePath, FileAttributes.Normal);
    }

    private static void ClearDirectoryAttributes(string directoryPath)
    {
        foreach (var file in Directory.EnumerateFiles(directoryPath, "*", SearchOption.AllDirectories))
        {
            ClearFileAttributes(file);
        }

        foreach (var directory in Directory.EnumerateDirectories(directoryPath, "*", SearchOption.AllDirectories))
        {
            File.SetAttributes(directory, FileAttributes.Normal);
        }

        File.SetAttributes(directoryPath, FileAttributes.Normal);
    }

    public static void EmptyRecycleBinIfNeeded()
    {
        try
        {
            if (!RecycleBinHasItems())
            {
                Console.WriteLine("Recycle Bin is already empty.");
                return;
            }

            const uint SHERB_NOCONFIRMATION = 0x00000001;
            const uint SHERB_NOPROGRESSUI = 0x00000002;
            const uint SHERB_NOSOUND = 0x00000004;
            var result = SHEmptyRecycleBin(
                IntPtr.Zero,
                null,
                SHERB_NOCONFIRMATION | SHERB_NOPROGRESSUI | SHERB_NOSOUND);

            if (result == 0)
            {
                Console.WriteLine("Recycle Bin emptied.");
            }
            else
            {
                Console.WriteLine($"Could not empty Recycle Bin. Error code: {result}");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error checking or emptying Recycle Bin: {ex.Message}");
        }
    }

    private static bool RecycleBinHasItems()
    {
        try
        {
            var shellType = Type.GetTypeFromProgID("Shell.Application");
            if (shellType is null)
            {
                return true;
            }

            dynamic shell = Activator.CreateInstance(shellType)
                ?? throw new InvalidOperationException("Could not start Shell.Application.");
            dynamic recycleBin = shell.NameSpace(10);
            if (recycleBin is null)
            {
                return true;
            }

            dynamic items = recycleBin.Items();
            return items is not null && items.Count > 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Could not inspect Recycle Bin contents: {ex.Message}");
            return true;
        }
    }

    public static void CloseOpenFileExplorerWindows()
    {
        try
        {
            var shellType = Type.GetTypeFromProgID("Shell.Application");
            if (shellType is null)
            {
                Console.WriteLine("Shell.Application is unavailable; File Explorer window check skipped.");
                return;
            }

            dynamic shell = Activator.CreateInstance(shellType)
                ?? throw new InvalidOperationException("Could not start Shell.Application.");
            var closedCount = 0;

            for (var attempt = 1; attempt <= 5; attempt++)
            {
                dynamic windows = shell.Windows();
                var closedThisAttempt = 0;

                foreach (dynamic window in windows)
                {
                    try
                    {
                        var executablePath = window.FullName as string;
                        if (!string.Equals(
                                Path.GetFileName(executablePath),
                                "explorer.exe",
                                StringComparison.OrdinalIgnoreCase))
                        {
                            continue;
                        }

                        window.Quit();
                        closedCount++;
                        closedThisAttempt++;
                    }
                    catch
                    {
                        // Some shell windows can disappear while being inspected.
                    }
                }

                if (closedThisAttempt == 0)
                    break;

                Thread.Sleep(500);
            }

            Console.WriteLine(closedCount == 0
                ? "No File Explorer windows were open after desktop cleanup."
                : $"Closed {closedCount} File Explorer window(s) after desktop cleanup.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error checking File Explorer windows: {ex.Message}");
        }
    }

    public static void ClearPinnedTaskbarShortcuts()
    {
        var explorerWasRunning = false;
        var taskbandPath = @"Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband";
        var pinnedTaskbarPath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
            @"Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar");

        try
        {
            if (!HasPinnedTaskbarShortcuts(taskbandPath, pinnedTaskbarPath))
            {
                Console.WriteLine("No pinned taskbar shortcuts found; taskbar cleanup skipped.");
                return;
            }

            var explorerProcesses = Process.GetProcessesByName("explorer");
            explorerWasRunning = explorerProcesses.Length > 0;
            foreach (var explorer in explorerProcesses)
            {
                using (explorer)
                {
                    explorer.Kill();
                    explorer.WaitForExit(5000);
                }
            }

            Registry.CurrentUser.DeleteSubKeyTree(taskbandPath, throwOnMissingSubKey: false);

            if (Directory.Exists(pinnedTaskbarPath))
            {
                foreach (var entry in Directory.EnumerateFileSystemEntries(pinnedTaskbarPath))
                {
                    try
                    {
                        if (Directory.Exists(entry))
                        {
                            Directory.Delete(entry, recursive: true);
                        }
                        else
                        {
                            File.Delete(entry);
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Could not remove pinned taskbar item {Path.GetFileName(entry)}: {ex.Message}");
                    }
                }
            }

            Console.WriteLine("Taskbar cleanup completed.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error clearing pinned taskbar shortcuts: {ex.Message}");
        }
        finally
        {
            if (explorerWasRunning)
            {
                try
                {
                    if (WaitForExplorerProcess(TimeSpan.FromSeconds(3)))
                    {
                        Console.WriteLine("Explorer restarted automatically.");
                    }
                    else
                    {
                        Process.Start(new ProcessStartInfo(
                            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Windows), "explorer.exe"))
                        {
                            UseShellExecute = false,
                        });
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error restarting Explorer: {ex.Message}");
                }
            }
        }
    }

    private static bool HasPinnedTaskbarShortcuts(string taskbandPath, string pinnedTaskbarPath)
    {
        if (Directory.Exists(pinnedTaskbarPath) &&
            Directory.EnumerateFiles(pinnedTaskbarPath, "*.lnk", SearchOption.AllDirectories).Any())
        {
            return true;
        }

        using var taskbandKey = Registry.CurrentUser.OpenSubKey(taskbandPath);
        if (taskbandKey is null)
        {
            return false;
        }

        return HasNonEmptyBinaryValue(taskbandKey, "Favorites") ||
            HasNonEmptyBinaryValue(taskbandKey, "FavoritesResolve");
    }

    private static bool HasNonEmptyBinaryValue(RegistryKey key, string valueName)
    {
        return key.GetValue(valueName) is byte[] bytes && bytes.Length > 0;
    }

    private static bool WaitForExplorerProcess(TimeSpan timeout)
    {
        var deadline = DateTime.UtcNow + timeout;
        while (DateTime.UtcNow < deadline)
        {
            if (Process.GetProcessesByName("explorer").Length > 0)
            {
                return true;
            }

            Thread.Sleep(250);
        }

        return Process.GetProcessesByName("explorer").Length > 0;
    }
}

internal sealed record AgentConfig(string ServerUrl, string? Location, string ClientSecret)
{
    public static AgentConfig Load()
    {
        using var stream = typeof(AgentConfig).Assembly
            .GetManifestResourceStream("appsettings.json")
            ?? throw new InvalidOperationException("Embedded appsettings.json was not found.");
        using var reader = new StreamReader(stream);
        var json = reader.ReadToEnd();
        var config = JsonSerializer.Deserialize<AgentConfig>(json, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true,
        });

        if (config is null ||
            string.IsNullOrWhiteSpace(config.ServerUrl) ||
            config.Location is not (null or "" or "Test" or "Aprang's Pisonet") ||
            string.IsNullOrWhiteSpace(config.ClientSecret))
        {
            throw new InvalidOperationException(
                "appsettings.json must contain ServerUrl and ClientSecret. Location is optional, but must be Test or Aprang's Pisonet when provided.");
        }

        return config;
    }
}
