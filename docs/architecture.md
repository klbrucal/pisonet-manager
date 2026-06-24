# Architecture

```text
Browser dashboard ---------+
                           +--> FastAPI server --> Windows agents
Desktop dashboard/WebView2-+
```

The browser and desktop dashboards share one web interface and API contract. FastAPI serves `frontend-dashboard-web` locally for same-origin cookies and WebSockets. The Windows agent maintains an outbound authenticated WebSocket connection to `backend-server`.

`frontend-dashboard-android` is reserved for a future Android client that will consume the same HTTP and WebSocket contracts.

The current server keeps connection and command state in memory. PostgreSQL and Redis can be introduced before cloud deployment without changing the dashboard or agent boundaries.
