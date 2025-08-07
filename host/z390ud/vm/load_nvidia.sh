#!/usr/bin/env bash
# Switch NVIDIA GPU + friends back to the NVIDIA kernel driver
set -euo pipefail

PCI_DEVICES=(
  "0000:01:00.0"  # GPU
  "0000:01:00.1"  # HDMI Audio

  "0000:01:00.2"  # USB 3.1 Controller
  "0000:01:00.3"  # USB Type-C / UCSI
)

VFIO_IDS=(
  "10de 1f07"  # GPU
  "10de 10f9"  # Audio

  "10de 1ada"  # USB 3.1
  "10de 1adb"  # UCSI
)

echo "[*] Unbinding devices from current driver (vfio-pci or otherwise)…"
for dev in "${PCI_DEVICES[@]}"; do
  driver_link="/sys/bus/pci/devices/$dev/driver"
  if [[ -L "$driver_link" ]]; then
    cur=$(basename "$(readlink "$driver_link")")
    echo "    − $dev  (was $cur)"
    echo -n "$dev" | tee "$driver_link/unbind" > /dev/null
  else
    echo "    · $dev  (already driver-less)"
  fi
  # clear any previous override we might have set
  echo "" | tee "/sys/bus/pci/devices/$dev/driver_override" > /dev/null
done

echo "[*] Dropping vfio-pci ID registrations (so it won't auto-grab again)…"
for id in "${VFIO_IDS[@]}"; do
  vendor="${id%% *}"
  device="${id##* }"
  path="/sys/bus/pci/drivers/vfio-pci/remove_id"
  [[ -w "$path" ]] && echo "$vendor $device" | sudo tee "$path" > /dev/null
done

echo "[*] Loading NVIDIA kernel modules…"
sudo modprobe nvidia nvidia_uvm nvidia_modeset nvidia_drm

echo "[*] Rebinding devices to the NVIDIA driver…"
for dev in "${PCI_DEVICES[@]}"; do
  echo "nvidia" | tee "/sys/bus/pci/devices/$dev/driver_override" > /dev/null
  echo -n "$dev" | tee /sys/bus/pci/drivers_probe > /dev/null
done

echo "[✓] Done.  Current status:"
# nvidia-smi || echo "(!) nvidia-smi failed — check dmesg for details"
