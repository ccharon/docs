# Repair wrong physical dimensions in screen edit file
the steps of adding the new edid to initramfs and rebuilding the initramfs are distribution specific! in my case gentoo

## find the port the display is connected to
```
$ for p in /sys/class/drm/*/status; do con=${p%/status}; echo -n "${con#*/card?-}: "; cat $p; done

DP-1: disconnected
DP-2: connected
DP-3: disconnected
HDMI-A-1: disconnected

```

## get edid file
for me it was DP-2
```
$ cat /sys/class/drm/card0-DP-2/edid > broken.bin
```

## change to correct values
I simply used https://sourceforge.net/projects/wxedid/ (download tgz, ./configure, make then run wxedid) to edit  the bin file.
corrected the physical dimensions from 60cm x 34 cm to 94cm x 53cm and saved the new file to /usr/lib/firmware/edid/LG43UN700-B.bin (create directory if needed) 
LG43UN700-B is the model number of my display 

## add kernel command line option
using dracut i added the following to my kernel command line

/etc/dracut.conf
```
kernel_cmdline+=" drm_kms_helper.edid_firmware=DP-2:edid/LG43UN700-B.bin "
```
take care to pick the right port! for me it is DP-2

## add to initramfs
the LG43UN700-B.bin has to be added to initramfs, for dracut I created

/etc/dracut.conf.d/20-lg43un700edid.conf 
```
# Corrected EDID File reports real physical dimensions
install_items+=" /usr/lib/firmware/edid/LG43UN700-B.bin "
```

## rebuild uki
to recreate the initramfs for the current kernel (in my case gentoo uki)
```
$ emerge =sys-kernel/gentoo-kernel-6.6.47 --config
```

reboot and my 42" display is no longer reported as 27" DPI values will match better.
