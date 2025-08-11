#!/usr/bin/env bash
set -euo pipefail

# run_gotty.sh - start gotty with secure defaults
PORT="${GOTTY_PORT:-8080}"
SHELL_CMD="${SHELL:-/bin/bash}"
AUTH="${GOTTY_AUTH:-basic}"
PASSWORD="${GOTTY_PASSWORD:-}"
TITLE="${GOTTY_TITLE:-VPS}"
CORS="${GOTTY_CORS:-*}"

# Ensure user dotfiles exist and run neofetch on new shell
if [ ! -f "$HOME/.bashrc" ]; then
  /usr/local/bin/default_bashrc.sh "$HOME"
fi

# Validate auth
if [ "$AUTH" = "basic" ] && [ -z "$PASSWORD" ]; then
  echo "GOTTY_AUTH=basic requires GOTTY_PASSWORD to be set to 'user:pass'" >&2
  exit 1
fi

GOTTY_ARGS=(
  --port "$PORT"
  --title-format "$TITLE"
  --permit-write
  --idle-timeout 0
  --cors "$CORS"
)

case "$AUTH" in
  basic)
    GOTTY_ARGS+=(--credential "$PASSWORD")
    ;;
  password)
    GOTTY_ARGS+=(--password "$PASSWORD")
    ;;
  none)
    # no creds
    ;;
  *)
    echo "Unsupported GOTTY_AUTH: $AUTH" >&2
    exit 1
    ;;
esac

echo "Starting gotty on :${PORT} (auth=${AUTH})"
exec gotty "${GOTTY_ARGS[@]}" "$SHELL_CMD"
