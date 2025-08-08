#!/run/current-system/sw/bin/bash
set -euo pipefail

echo "[HOOK] Killing scream mercilessly" >> /tmp/qemu-hooks.log

# Nuke all screams
pkill -9 scream || true
