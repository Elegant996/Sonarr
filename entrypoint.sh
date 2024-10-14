#!/bin/sh
set -eu
USER_NAME="${USER_NAME:-sonarr}"
GROUP_NAME="${GROUP_NAME:-sonarr}"
USER_HOME="${USER_HOME:-/data}"
PUID="${PUID:-1001}"
PGID="${PGID:-1001}"
if [ "$(id -u)" = "0" ] && [ -z "${DISABLE_PERM_DROP:-}" ]; then
  if ! getent group "$PGID" >/dev/null; then
    groupadd -g "$PGID" "$GROUP_NAME"
  fi
  if ! getent passwd "$PUID" >/dev/null; then
    useradd -m -d "$USER_HOME" -g "$PGID" -u "$PUID" "$USER_NAME"
  fi
  exec sudo -u "#$PUID" -g "#$PGID" -- "$@"
else
  exec "$@"
fi