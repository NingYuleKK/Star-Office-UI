#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Port 17291 固定，避开 OpenClaw Gateway (占用 18791)
export STAR_BACKEND_PORT="${STAR_BACKEND_PORT:-17291}"
exec python3 "$ROOT_DIR/backend/app.py"
