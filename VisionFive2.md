# Gentoo on Sifive VisionFive2 
Work in progress

## getting anything usefull to boot at all
my device needed a firmware update to be able to boot an debian image which acutally had a proc file system available
to do so i did the following.

1. download necessary files from
(when I did this Version 2.8 was the most recent.)
https://github.com/starfive-tech/VisionFive2/releases/tag/VF2_v2.8.0

the files needed are:

sdcard.img
u-boot-spl.bin.normal.out 
visionfive2_fw_payload.img 

2. copy the sdcard image to an sd card (all previous data gets destroyed)
```bash 
dd if=sdcard.img of=/dev/yoursdcarddevice bs=2M status=progress conv=fdatasync
```
3. mount the rootfs of the sd card (for me it was the 4. partition)
```bash 
mount /dev/yoursdcarddevice4 /mnt
```
4. copy the 2 files to the mounted fs 
```bash 
mkdir -p /mnt/root/update
cp u-boot-spl.bin.normal.out /mnt/root/update
cp visionfive2_fw_payload.img /mnt/root/update
```

5. unmount /mnt

6. put sdcard into visionfive2 and boot



7. after boot login (via serial console, or terminal) user: root, pw: starfive
´´´bash 
cd /root/update
...
´´´




for me the approach of using the build image, putting it on a sd card and then mounting it and adding the two files to update bootloader and firm





.. i am sorting later ....


## Compiling the kernel
download the latest sifive kernel
for me it was https://github.com/starfive-tech/linux/tree/VF2_v2.8.0

extract to /usr/src

then you have /usr/src/linux--bla
create a symlink to /usr/src/linux 

```bash
cd /usr/src
ln -s linux-bla linux
```

now change the makefile (necessary because of the binutils version being > 2.38

https://lore.kernel.org/lkml/20220126171442.1338740-1-aurelien@aurel32.net/T/

this is needed at least for kernel version 5.15.x which is provided with VF2 v2.8.0

```
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 8a107ed18b0d..7d81102cffd4 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+
+# Newer binutils versions default to ISA spec version 20191213 which moves some
+# instructions from the I extension to the Zicsr and Zifencei extensions.
+toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
+riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+
 KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
-- 
```








