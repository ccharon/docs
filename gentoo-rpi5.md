# Random bits for a gentoo raspberry pi5 installation

## make.conf
```
# mtune defaults to mcpu, which might break stuff
COMMON_FLAGS="-mcpu=cortex-a76+crc+crypto -mtune=cortex-a76 -O2 -pipe"
```

## Boot Order SD,USB, NVME
modify boot.conf and write eeprom
```bash
$ sudo -E rpi-eeprom-config --edit
```

```
[all]
BOOT_UART=1
POWER_OFF_ON_HALT=0
PSU_MAX_CURRENT=5000
USB_MSD_DISCOVER_TIMEOUT=1000
DTPARAM=PCIEX1_GEN=3
PCIE_PROBE=1
BOOT_ORDER=0x641
```

## Build kernel
```
git clone --depth=1 --branch stable_20241008 https://github.com/raspberrypi/linux
cd linux
make bcm2712_defconfig
# make any config changes needed 'make menuconfig'
make -j4 Image.gz modules dtbs
make modules_install
cp arch/arm64/boot/dts/broadcom/*.dtb /boot/
cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
cp /boot/kernel_2712.img /boot/kernel_2712.img.old
cp arch/arm64/boot/Image.gz /boot/kernel_2712.img
```
