# Random bits for a gentoo raspberry pi5 installation

## make.conf
```
# mtune defaults to mcpu, which might break stuff
COMMON_FLAGS="-mcpu=cortex-a76+crc+crypto -mtune=cortex-a76 -O2 -pipe"
```

## Boot Order SD,USB, NVME

```
[all]
BOOT_UART=1
POWER_OFF_ON_HALT=0
PSU_MAX_CURRENT=3000
USB_MSD_DISCOVER_TIMEOUT=500
DTPARAM=PCIEX1_GEN=3
PCIE_PROBE=1
BOOT_ORDER=0x641
```
