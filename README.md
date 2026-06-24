# Pisonet Manager

Local-first computer shop management with browser and Windows desktop dashboards.

## Applications

```text
pisonet-manager/
  apps/
    backend-server/         FastAPI API and WebSocket server
      app/
        api/
        models/
        schemas/
        services/
        websockets/
        main.py
    frontend-dashboard-web/       Browser dashboard shared with desktop
    frontend-dashboard-windows/   WPF and WebView2 Windows dashboard
    frontend-dashboard-android/   Native .NET Android dashboard
    client-agent/           Background C# agent for managed PCs
  packages/
    api-contracts/          Generated OpenAPI and WebSocket contracts
  infrastructure/
    scripts/
  docs/
  PisonetManager.sln
```

## Run The Server

```powershell
cd apps\backend-server
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Open the browser dashboard at `http://localhost:8000`.

Default dashboard credentials:

```text
Location: Test
Password: Admin
```

For other LAN devices, replace `localhost` with the server PC's reserved LAN IP and allow inbound TCP port `8000` in Windows Firewall.

## Run The Desktop Dashboard

Set `ServerUrl` in `apps/frontend-dashboard-windows/PisonetManager.Desktop/appsettings.json`, then run:

```powershell
dotnet run --project apps\frontend-dashboard-windows\PisonetManager.Desktop
```

The Windows dashboard login includes Server, Location, and Password. Server defaults to `http://192.168.0.5:8000`, Location defaults to `All`, and Password remains blank until entered. `All` shows agents from every location; choosing a specific location limits the dashboard to agents with that embedded location. The desktop app hosts the same dashboard in WebView2, so browser and desktop features stay synchronized.

Closing the Windows dashboard hides it in the notification area. Double-click its tray icon or choose `Open` to restore it; choose `Exit` from the tray menu to quit completely.

The Android dashboard is a native .NET Android WebView application with its own Server, Location, and Password login. Its installable APK is published by the release script to `PisonetManager.Dashboard.Android.apk` in the project folder.

Connected PCs report the time since their last Windows keyboard or mouse input. The dashboards show `Active` until the configurable idle threshold is reached; the default is 5 minutes.

For agents on other LAN computers, set the embedded agent `ServerUrl` to the server computer's LAN address (for example, `ws://192.168.0.5:8000/ws/client`) before publishing. `localhost` only works when the agent and server run on the same computer. If an agent config omits `Location`, the backend accepts it as `Unassigned`; it is visible from the `All` dashboard.

Publish the Windows dashboard directly:

```powershell
dotnet publish apps\frontend-dashboard-windows\PisonetManager.Desktop -c Release -o .build-temp\desktop-dashboard
```

The backend URL from `appsettings.json` is embedded during publishing, so `PisonetManager.Desktop.exe` can run by itself. An external `appsettings.json` beside the executable can optionally override the embedded setting.

## Build The Windows Agent

Before publishing, set the server WebSocket URL and matching client secret in `apps/client-agent/PisonetManager.Agent/appsettings.json`.

```powershell
dotnet publish apps\client-agent\PisonetManager.Agent -c Release -o .build-temp\client-agent\Test
```

The default client-agent build is for the `Test` location. To publish both location variants:

```powershell
dotnet publish apps\client-agent\PisonetManager.Agent -c Release -o .build-temp\client-agent\Test -p:AgentLocation=Test
dotnet publish apps\client-agent\PisonetManager.Agent -c Release -o .build-temp\client-agent\Aprang -p:AgentLocation=Aprang
```

Deploy the generated `PisonetManager.Agent.exe` to each client PC. The configuration is embedded during publishing, and the Windows computer name is detected automatically.

## Build All Release Apps

To publish the client-agent variants, Windows dashboard, and Android dashboard APK into one folder:

```powershell
.\build-release.ps1
```

The release files are written directly to the project folder.

## Shared Contracts

`packages/api-contracts/openapi.json` is generated from FastAPI. WebSocket message types are documented in `packages/api-contracts/websocket-messages.md`.

## Current Deployment

FastAPI serves the separate frontend-dashboard-web project to keep cookies and WebSockets same-origin during local deployment. Before exposing the system outside a trusted LAN, add HTTPS/WSS, persistent storage, per-device credentials, and production secret management.
