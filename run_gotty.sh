#!/usr/bin/env bash
set -euo pipefail

# Defaults (from Dockerfile envs)
PORT="${GOTTY_PORT:-8080}"
SHELL_CMD="${SHELL:-/bin/bash}"
AUTH="${GOTTY_AUTH:-password}"    # none | basic | password
PASSWORD="${GOTTY_PASSWORD:-changeme}"
TITLE="${GOTTY_TITLE:-VPS}"
CORS="${GOTTY_CORS:-*}"

# Minimal validation
if [[ "$AUTH" == "password" && -z "$PASSWORD" ]]; then
  echo "Error: GOTTY_PASSWORD must be set when GOTTY_AUTH=password" >&2
  exit 1
fi

# Construct gotty args
GOTTY_ARGS=( 
  "--port" "$PORT"
  "--title-format" "$TITLE"
  "--permit-write"         # allow input to terminal
  "--idle-timeout" "0"     # never timeout
  "--cors" "$CORS"
)

if [[ "$AUTH" == "basic" ]]; then
  # basic expects "user:pass"
  # ensure the value is provided in GOTTY_PASSWORD env as "user:pass"
  GOTTY_ARGS+=("--credential" "${PASSWORD}")
elif [[ "$AUTH" == "password" ]]; then
  GOTTY_ARGS+=("--password" "${PASSWORD}")
elif [[ "$AUTH" == "none" ]]; then
  # no auth
  :
else
  echo "Unsupported GOTTY_AUTH value: $AUTH" >&2
  exit 1
fi

# Exec gotty with the chosen shell
exec gotty "${GOTTY_ARGS[@]}" "${SHELL_CMD}"
