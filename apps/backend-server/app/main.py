from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from hmac import compare_digest
import asyncio
import json
from pathlib import Path
import re
import secrets
from uuid import uuid4

from fastapi import Depends, FastAPI, HTTPException, Request, Response, WebSocket, WebSocketDisconnect
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

APP_DIR = Path(__file__).resolve().parent
SERVER_DIR = APP_DIR.parent
WEB_DASHBOARD_DIR = SERVER_DIR.parent / "frontend-dashboard-web"
ADMIN_COOKIE = "pisonet_manager_admin_session"
SETTINGS_PATH = SERVER_DIR / "settings.json"
ALL_LOCATIONS = "All"
DEFAULT_CLIENT_LOCATION = "Unassigned"
VALID_CLIENT_LOCATIONS = ("Test", "Aprang's Pisonet", DEFAULT_CLIENT_LOCATION)
VALID_DASHBOARD_LOCATIONS = (*VALID_CLIENT_LOCATIONS, ALL_LOCATIONS)


class Settings(BaseModel):
    admin_password: str
    client_secret: str
    idle_threshold_minutes: int = 5


def load_settings() -> Settings:
    return Settings.model_validate_json(SETTINGS_PATH.read_text(encoding="utf-8"))


def save_settings() -> None:
    SETTINGS_PATH.write_text(settings.model_dump_json(indent=2) + "\n", encoding="utf-8")


settings = load_settings()
app = FastAPI(title="Pisonet Manager")


@dataclass
class ConnectedClient:
    location: str
    pc_name: str
    websocket: WebSocket
    connected_at: datetime
    last_seen_at: datetime
    active_application: dict | None
    applications: list[dict]
    send_lock: asyncio.Lock
    screen_monitoring: bool
    idle_seconds: int
    activity_status: str


@dataclass
class PendingCommand:
    location: str
    pc_name: str
    command: str


class ApplicationSummary(BaseModel):
    pid: int
    process_name: str
    window_title: str


class ClientSummary(BaseModel):
    location: str
    pc_name: str
    online: bool
    connected_at: str
    last_seen_at: str
    active_application: ApplicationSummary | None
    applications: list[ApplicationSummary]
    screen_monitoring: bool
    idle_seconds: int
    activity_status: str


class LoginRequest(BaseModel):
    location: str
    password: str


class DashboardSettings(BaseModel):
    idle_threshold_minutes: int


class UpdateSettingsRequest(BaseModel):
    idle_threshold_minutes: int = Field(ge=1, le=1440)


clients: dict[tuple[str, str], ConnectedClient] = {}
dashboard_sockets: dict[WebSocket, tuple[asyncio.Lock, str]] = {}
admin_sessions: dict[str, str] = {}
pending_commands: dict[str, PendingCommand] = {}


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def require_admin(request: Request) -> str:
    session_id = request.cookies.get(ADMIN_COOKIE)
    location = admin_sessions.get(session_id or "")
    if location is None:
        raise HTTPException(status_code=401, detail="Authentication required")
    return location


def serialize_client(client: ConnectedClient) -> ClientSummary:
    return ClientSummary(
        location=client.location,
        pc_name=client.pc_name,
        online=True,
        connected_at=client.connected_at.isoformat(),
        last_seen_at=client.last_seen_at.isoformat(),
        active_application=client.active_application,
        applications=client.applications,
        screen_monitoring=client.screen_monitoring,
        idle_seconds=client.idle_seconds,
        activity_status=client.activity_status,
    )


def get_sorted_clients(location: str) -> list[ConnectedClient]:
    def natural_name_key(client: ConnectedClient) -> tuple[str | int, ...]:
        return tuple(
            int(part) if part.isdigit() else part
            for part in re.split(r"(\d+)", client.pc_name.casefold())
        )

    return sorted(
        (
            client
            for client in clients.values()
            if location == ALL_LOCATIONS or client.location == location
        ),
        key=natural_name_key,
    )


def get_activity_status(idle_seconds: int) -> str:
    return "idle" if idle_seconds >= settings.idle_threshold_minutes * 60 else "active"


def update_activity_status(client: ConnectedClient) -> None:
    activity_status = get_activity_status(client.idle_seconds)
    if activity_status == client.activity_status:
        return

    client.activity_status = activity_status


async def broadcast_dashboard(location: str, payload: dict) -> None:
    disconnected: list[WebSocket] = []
    for socket, (send_lock, socket_location) in list(dashboard_sockets.items()):
        if socket_location != location:
            continue
        try:
            async with send_lock:
                await socket.send_json(payload)
        except RuntimeError:
            disconnected.append(socket)

    for socket in disconnected:
        dashboard_sockets.pop(socket, None)


async def broadcast_clients(location: str) -> None:
    await broadcast_dashboard(
        location,
        {
            "type": "clients",
            "clients": [serialize_client(client).model_dump() for client in get_sorted_clients(location)],
        }
    )


async def broadcast_client_scope(location: str) -> None:
    await broadcast_clients(location)
    if location != ALL_LOCATIONS:
        await broadcast_clients(ALL_LOCATIONS)


def get_command_target(location: str, pc_name: str) -> ConnectedClient:
    if location != ALL_LOCATIONS:
        client = clients.get((location, pc_name))
        if client is None:
            raise HTTPException(status_code=404, detail=f"{pc_name} is not online")
        return client

    matches = [client for client in clients.values() if client.pc_name == pc_name]
    if not matches:
        raise HTTPException(status_code=404, detail=f"{pc_name} is not online")
    if len(matches) > 1:
        raise HTTPException(
            status_code=409,
            detail=f"{pc_name} is online in multiple locations. Sign in to a specific location to control it.",
        )
    return matches[0]


async def send_command(location: str, pc_name: str, command: str, **payload: object) -> dict[str, str]:
    client = get_command_target(location, pc_name)
    command_location = client.location

    command_id = str(uuid4())
    pending_commands[command_id] = PendingCommand(
        location=command_location,
        pc_name=pc_name,
        command=command,
    )
    try:
        async with client.send_lock:
            await client.websocket.send_json(
                {"type": command, "command_id": command_id, **payload}
            )
    except RuntimeError as error:
        pending_commands.pop(command_id, None)
        raise HTTPException(status_code=409, detail=f"{pc_name} disconnected") from error

    return {
        "status": "pending",
        "command_id": command_id,
        "pc_name": pc_name,
        "command": command,
    }


app.mount(
    "/dashboard-assets",
    StaticFiles(directory=WEB_DASHBOARD_DIR),
    name="dashboard-assets",
)


@app.get("/")
async def dashboard() -> FileResponse:
    return FileResponse(WEB_DASHBOARD_DIR / "index.html")


@app.post("/api/login")
async def login(request: LoginRequest, response: Response) -> dict[str, str]:
    location_matches = request.location in VALID_DASHBOARD_LOCATIONS
    password_matches = compare_digest(request.password, settings.admin_password)
    if not location_matches or not password_matches:
        raise HTTPException(status_code=401, detail="Incorrect location or password")

    session_id = secrets.token_urlsafe(32)
    admin_sessions[session_id] = request.location
    response.set_cookie(
        key=ADMIN_COOKIE,
        value=session_id,
        httponly=True,
        samesite="strict",
        max_age=8 * 60 * 60,
    )
    return {"status": "authenticated", "location": request.location}


@app.post("/api/logout")
async def logout(request: Request, response: Response) -> dict[str, str]:
    session_id = request.cookies.get(ADMIN_COOKIE)
    if session_id is not None:
        admin_sessions.pop(session_id, None)
    response.delete_cookie(ADMIN_COOKIE)
    return {"status": "logged_out"}


@app.get("/api/me")
async def current_admin(location: str = Depends(require_admin)) -> dict[str, bool | str]:
    return {"authenticated": True, "location": location}


@app.get(
    "/api/settings",
    response_model=DashboardSettings,
    dependencies=[Depends(require_admin)],
)
async def get_dashboard_settings() -> DashboardSettings:
    return DashboardSettings(idle_threshold_minutes=settings.idle_threshold_minutes)


@app.put(
    "/api/settings",
    response_model=DashboardSettings,
    dependencies=[Depends(require_admin)],
)
async def update_dashboard_settings(request: UpdateSettingsRequest) -> DashboardSettings:
    settings.idle_threshold_minutes = request.idle_threshold_minutes
    save_settings()
    for client in clients.values():
        update_activity_status(client)
    for location in VALID_DASHBOARD_LOCATIONS:
        await broadcast_clients(location)
    return DashboardSettings(idle_threshold_minutes=settings.idle_threshold_minutes)


@app.get(
    "/api/clients",
    response_model=list[ClientSummary],
)
async def get_clients(location: str = Depends(require_admin)) -> list[ClientSummary]:
    return [serialize_client(client) for client in get_sorted_clients(location)]


@app.post("/api/clients/{pc_name}/shutdown")
async def shutdown_client(pc_name: str, location: str = Depends(require_admin)) -> dict[str, str]:
    return await send_command(location, pc_name, "shutdown")


@app.post("/api/clients/{pc_name}/restart")
async def restart_client(pc_name: str, location: str = Depends(require_admin)) -> dict[str, str]:
    return await send_command(location, pc_name, "restart")


@app.post(
    "/api/clients/{pc_name}/applications/{pid}/close",
)
async def close_application(
    pc_name: str,
    pid: int,
    location: str = Depends(require_admin),
) -> dict[str, str]:
    client = get_command_target(location, pc_name)
    if not any(application.get("pid") == pid for application in client.applications):
        raise HTTPException(status_code=404, detail="Application is no longer running")

    return await send_command(client.location, pc_name, "close_application", pid=pid)


@app.post("/api/clients/{pc_name}/screen/start")
async def start_screen_monitoring(
    pc_name: str,
    location: str = Depends(require_admin),
) -> dict[str, str]:
    return await send_command(location, pc_name, "start_screen_monitoring")


@app.post("/api/clients/{pc_name}/screen/stop")
async def stop_screen_monitoring(
    pc_name: str,
    location: str = Depends(require_admin),
) -> dict[str, str]:
    return await send_command(location, pc_name, "stop_screen_monitoring")


@app.websocket("/ws/client/{pc_name}")
async def client_socket(websocket: WebSocket, pc_name: str) -> None:
    supplied_secret = websocket.headers.get("x-client-secret", "")
    location = websocket.headers.get("x-client-location", "").strip() or DEFAULT_CLIENT_LOCATION
    if not compare_digest(supplied_secret, settings.client_secret):
        await websocket.close(code=1008, reason="Invalid client secret")
        return
    if location not in VALID_CLIENT_LOCATIONS:
        await websocket.close(code=1008, reason="Invalid client location")
        return

    await websocket.accept()
    now = utc_now()
    client_key = (location, pc_name)
    old_client = clients.get(client_key)
    if old_client is not None:
        await old_client.websocket.close(code=4000, reason="New connection replaced this client")

    clients[client_key] = ConnectedClient(
        location=location,
        pc_name=pc_name,
        websocket=websocket,
        connected_at=now,
        last_seen_at=now,
        active_application=None,
        applications=[],
        send_lock=asyncio.Lock(),
        screen_monitoring=False,
        idle_seconds=0,
        activity_status="active",
    )
    await broadcast_client_scope(location)

    try:
        while True:
            raw_message = await websocket.receive_text()
            client = clients.get(client_key)
            if client is not None:
                client.last_seen_at = utc_now()

            try:
                message = json.loads(raw_message)
            except json.JSONDecodeError:
                continue

            message_type = message.get("type")
            if message_type == "heartbeat":
                client = clients.get(client_key)
                if client is not None:
                    client.active_application = message.get("active_application")
                    client.applications = message.get("applications", [])
                    idle_seconds = message.get("idle_seconds", 0)
                    if isinstance(idle_seconds, (int, float)):
                        client.idle_seconds = max(0, int(idle_seconds))
                        update_activity_status(client)
                await broadcast_client_scope(location)
            elif message_type == "command_result":
                command_id = message.get("command_id")
                pending = pending_commands.get(command_id)
                if (
                    pending is None
                    or pending.location != location
                    or pending.pc_name != pc_name
                ):
                    continue

                pending_commands.pop(command_id, None)
                command_succeeded = bool(message.get("success"))
                client = clients.get(client_key)
                if client is not None and command_succeeded:
                    if pending.command == "start_screen_monitoring":
                        client.screen_monitoring = True
                    elif pending.command == "stop_screen_monitoring":
                        client.screen_monitoring = False

                await broadcast_dashboard(
                    location,
                    {
                        "type": "command_result",
                        "command_id": command_id,
                        "pc_name": pc_name,
                        "command": pending.command,
                        "success": command_succeeded,
                        "message": str(message.get("message", "")),
                    }
                )
                await broadcast_dashboard(
                    ALL_LOCATIONS,
                    {
                        "type": "command_result",
                        "command_id": command_id,
                        "pc_name": pc_name,
                        "command": pending.command,
                        "success": command_succeeded,
                        "message": str(message.get("message", "")),
                    }
                )
                if pending.command in {"start_screen_monitoring", "stop_screen_monitoring"}:
                    await broadcast_client_scope(location)
            elif message_type == "screenshot":
                image_data = message.get("image_data")
                if not isinstance(image_data, str):
                    continue
                if not image_data.startswith("data:image/jpeg;base64,"):
                    continue
                if len(image_data) > 5_000_000:
                    continue

                await broadcast_dashboard(
                    location,
                    {
                        "type": "screenshot",
                        "pc_name": pc_name,
                        "image_data": image_data,
                        "captured_at": message.get("captured_at"),
                    }
                )
                await broadcast_dashboard(
                    ALL_LOCATIONS,
                    {
                        "type": "screenshot",
                        "pc_name": pc_name,
                        "image_data": image_data,
                        "captured_at": message.get("captured_at"),
                    }
                )
    except WebSocketDisconnect:
        current = clients.get(client_key)
        if current is not None and current.websocket is websocket:
            del clients[client_key]
            await broadcast_client_scope(location)


@app.websocket("/ws/dashboard")
async def dashboard_socket(websocket: WebSocket) -> None:
    session_id = websocket.cookies.get(ADMIN_COOKIE)
    location = admin_sessions.get(session_id or "")
    if location is None:
        await websocket.close(code=1008, reason="Authentication required")
        return

    await websocket.accept()
    send_lock = asyncio.Lock()
    dashboard_sockets[websocket] = (send_lock, location)
    async with send_lock:
        await websocket.send_json(
            {
                "type": "clients",
                "clients": [serialize_client(client).model_dump() for client in get_sorted_clients(location)],
            }
        )

    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        dashboard_sockets.pop(websocket, None)
