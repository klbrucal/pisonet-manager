# WebSocket Messages

## Agent To Server

- `heartbeat`: active application, visible application list, and `idle_seconds` since the last keyboard or mouse input.
- `command_result`: command ID, success state, and result message.
- `screenshot`: in-memory JPEG preview while recording is active.

## Server To Agent

- `shutdown`
- `restart`
- `close_application`
- `start_screen_monitoring`
- `stop_screen_monitoring`

Every command includes a unique `command_id` that the agent returns in `command_result`.

## Server To Dashboard

- `clients`: current connected-client state, including `idle_seconds` and an `activity_status` of `active` or `idle`. The server uses the configured idle threshold.
- `command_result`: final command outcome.
- `screenshot`: latest in-memory screen preview.
