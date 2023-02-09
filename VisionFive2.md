# Gentoo on Sifive VisionFive2 
Work in progress

## getting anything usefull to boot at all
my device needed a firmware update to be able to boot an debian image which acutally had a proc file system available
to do so i did the following.

1. download necessary files from
(when I did this Version 2.8 was the most recent.)
https://github.com/starfive-tech/VisionFive2/releases/tag/VF2_v2.8.0

the files needed are:
```
sdcard.img
u-boot-spl.bin.normal.out 
visionfive2_fw_payload.img 
```

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
```bash 
cd /root/update
flashcp -v u-boot-spl.bin.normal.out /dev/mtd0
flashcp -v visionfive2_fw_payload.img /dev/mtd1
```

thats it ... firmware updated, now shutdown


## getting debian to run





.. i am sorting later ....


### Compiling the kernel
download the latest sifive kernel
for me it was https://github.com/starfive-tech/linux/tree/59cf9af678dbfa3d73f6cb86ed1ae7219da9f5c9 (included in v 2.8 Release)

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





### /etc/portage/make.conf
```
# Instruction sets JH7110 supports 
# march explained 
# rv64 = riscv 64bit
# i = Base Integer ISA
# m = Standard Integer Multiplication/Division Extension
# a = Standard Atomics Extension
# f = Standard Single-precision Floating-point extension
# d = Standard Double-precision floating-point extension

# g = i, m, a, f, d
# c = Compressed Instructions Extension

# _zicsr    = Control and Status Register Intructions, since ISA 20191213 not part of i
# _zifencei = Instruction-Fetch Fence, Version 2.0
# _zba      = address generation 
# _zbb      = basic bit manipulation 

COMMON_FLAGS="-march=rv64gc_zicsr_zifencei_zba_zbb -O2 -pipe -mabi=lp64d -mcpu=sifive-u74 -mtune=sifive-7-series --param l1-cache-size=32 --param l2-cache-size=2048"

CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"

# WARNING: Changing your CHOST is not something that should be done lightly.
# Please consult https://wiki.gentoo.org/wiki/Changing_the_CHOST_variable befor>
CHOST="riscv64-unknown-linux-gnu"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C

ACCEPT_KEYWORDS="riscv ~riscv"

MAKEOPTS="-j4"
L10N="de en"
USE="-qt5 -bluetooth -cups samba vulkan x265 pulseaudio"

```



