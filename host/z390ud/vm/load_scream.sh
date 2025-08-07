#!/run/current-system/sw/bin/bash
set -euo pipefail

echo "[HOOK] Starting scream via sudo" >> /tmp/qemu-hooks.log

sudo -u jared XDG_RUNTIME_DIR=/run/user/$(id -u jared) \
  scream -v -p 4010 -i virbr0 -o pulse >> /tmp/scream.log 2>&1 &

disown
