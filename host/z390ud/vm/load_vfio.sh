#!/usr/bin/env bash
# Switch NVIDIA GPU + Audio to vfio-pci
set -euo pipefail

PCI_DEVICES=(
  "0000:01:00.0"  # GPU
  "0000:01:00.1"  # HDMI Audio
  "0000:01:00.2"  # USB 3.1 Controller
  "0000:01:00.3"  # USB Type-C UCSI
)

VFIO_IDS=(
  "10de 1f07"  # GPU
  "10de 10f9"  # Audio
  "10de 1ada"  # USB 3.1
  "10de 1adb"  # UCSI
)

echo "[*] Loading vfio-pci kernel module…"
modprobe vfio-pci

for dev in "${PCI_DEVICES[@]}"; do
  driver_link="/sys/bus/pci/devices/$dev/driver"
  if [[ -L "$driver_link" ]]; then
    echo "[*] Unbinding $dev from $(basename "$(readlink "$driver_link")")"
    echo -n "$dev" | tee "$driver_link/unbind"
  else
    echo "[ ] $dev is already unbound"
  fi
done

echo "[*] Binding devices to vfio-pci…"
for id in "${VFIO_IDS[@]}"; do
  vendor="${id%% *}"
  device="${id##* }"
  echo "[*] Registering vfio-pci ID $vendor:$device"
  # echo "$vendor $device" | tee /sys/bus/pci/drivers/vfio-pci/new_id > /dev/null
done

echo "[✓] NVIDIA GPU and audio bound to vfio-pci."



# TODO nuke anything running on nvidia
#
# FIXME errors in here dont care to fix it right now
# journalctl -u libvirtd -f
