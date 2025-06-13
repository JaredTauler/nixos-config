# iso_boot.py  <domain> <path/to/Win11.iso> [path/to/virtio.iso]

import sys, time, libvirt, xml.etree.ElementTree as ET

dom_name, win_iso, virtio_iso = sys.argv[1:]

conn = libvirt.open("qemu:///system")
dom  = conn.lookupByName(dom_name)

# power off if running
if dom.isActive():
    dom.shutdown();            print("shutting down…")
    while dom.isActive(): time.sleep(1)

# detach every existing cdrom
tree = ET.fromstring(dom.XMLDesc())
for disk in tree.findall(".//disk[@device='cdrom']"):
    dom.detachDeviceFlags(ET.tostring(disk).decode(), 0)

# helper to build a <disk/> snippet
def cd_xml(path, target):
    return f"""
<disk type='file' device='cdrom'>
  <driver name='qemu' type='raw'/>
  <source file='{path}'/>
  <target dev='{target}' bus='sata'/>
</disk>"""

dom.attachDeviceFlags(cd_xml(win_iso, "sdc"), libvirt.VIR_DOMAIN_AFFECT_CONFIG)
if virtio_iso:
    dom.attachDeviceFlags(cd_xml(virtio_iso, "sdd"), libvirt.VIR_DOMAIN_AFFECT_CONFIG)

# boot from CD first
# dom.setBootOrder(
#     [libvirt.VIR_DOMAIN_BOOT_DEVICE_CDROM,
#                   libvirt.VIR_DOMAIN_BOOT_DEVICE_HD])

dom.create();      print("✔ booting", dom_name)
