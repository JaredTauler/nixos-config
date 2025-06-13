#!/usr/bin/env bash
# install‑iso.sh  —  usage:  ./install‑iso.sh <domain-name> <path/to/Win11.iso>

set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <domain> <iso-path>" >&2
  exit 1
fi

DOMAIN="$1"
WIN_ISO="$2"
VIRTIO_ISO="$3"

# TODO is all this really necessary
[[ -f "$WIN_ISO" ]] || { echo "ISO not found: $ISO" >&2; exit 1; }
virsh dominfo "$DOMAIN" >/dev/null || { echo "No such domain: $DOMAIN" >&2; exit 1; }


# Power off if needed
if virsh domstate "$DOMAIN" | grep -q running; then
  echo "Shutting down $DOMAIN…"
  virsh shutdown "$DOMAIN"
  until virsh domstate "$DOMAIN" | grep -q "shut off"; do sleep 1; done
fi

echo "Attaching ISO…"
# Wipe any existing CD‑ROM definitions
virt-xml "$DOMAIN"                          \
  --remove-device --disk device=cdrom

# Add the new CD‑ROM
virt-xml "$DOMAIN"                          \
  --add-device --disk "device=cdrom,path=$WIN_ISO,bus=sata,target.dev=sdc"

virt-xml "$DOMAIN"                          \
  --add-device --disk "device=cdrom,path=$VIRTIO_ISO,bus=sata,target.dev=sdc"

echo "Setting boot order (CD‑ROM first)…"
virt-xml "$DOMAIN" --boot cdrom,hd --update

echo "Starting VM…"
virsh start "$DOMAIN"

echo "✅  $DOMAIN is now booting from $ISO"
echo "➡  Open virt‑viewer/Remote‑viewer to finish the Windows setup."
!/usr/bin/env sh
