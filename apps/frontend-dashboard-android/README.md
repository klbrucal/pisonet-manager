# Android Dashboard

Native .NET Android shell for the shared Pisonet Manager dashboard.

## Features

- Native Server, Location, and Password login
- Server address remembered after a successful login
- Authenticated Android WebView dashboard
- Dashboard and Settings pages shared with the browser and Windows apps
- Automatic return to native login when the session expires
- HTTP LAN support for the local FastAPI server

The default server is `http://192.168.0.5:8000`. It can be changed on the login screen.

## Build An Installable APK

From the repo root, build the release bundle with:

```powershell
.\build-release.ps1
```

The packaged APK is written to `PisonetManager.Dashboard.Android.apk` in the project folder.

To build only the Android project directly:

```powershell
cd apps\frontend-dashboard-android\PisonetManager.Android
dotnet build -c Debug `
  -p:JavaSdkDirectory="$env:LOCALAPPDATA\Android\jdk-17" `
  -p:AndroidSdkDirectory="$env:LOCALAPPDATA\Android\Sdk"
```

The debug-signed APK is written to:

```text
bin\Debug\net8.0-android\com.pisonetmanager.dashboard-Signed.apk
```
