# RISC-V Gentoo

https://colatkinson.site/linux/riscv/2021/01/27/riscv-qemu/

https://wiki.gentoo.org/wiki/Project:RISC-V


I want gentoo  on risc-v hardware, someday I'd like to buy a VisionFive V2 JH7110 (if it ever becomes available). Until then this document helps with qemu setup.

this is not a tutorial, just a list of reminders


## Installing qemu

add to /etc/portage/make.conf
QEMU_SOFTMMU_TARGETS="riscv64" 

emerge qemu >=7 maybe accept_keyword is needed as 7.x is not stable yet


## Getting uboot
i could not find a gentoo package ... so

```bash 
wget "http://ftp.us.debian.org/debian/pool/main/u/u-boot/u-boot-qemu_2022.04+dfsg-2_all.deb" -O u-boot-qemu.deb
mkdir u-boot-qemu
cd u-boot-qemu
ar -x ../u-boot-qemu.deb
tar xvf data.tar.xz
cp ./usr/lib/u-boot/qemu-riscv64_smode/uboot.elf ./uboot.elf
```


## Installing Gentoo

### download ubuntu server installer
... to install gentoo first install ubuntu as host
https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04-live-server-riscv64.img.gz

after download gunzip ubuntu-22.04-live-server-riscv64.img.gz

### create virtual harddrives 

```bash
qemu-img create -f qcow2 ubuntu.qcow2 20G
qemu-img create -f qcow2 gentoo.qcow2 20G
```

### start vm and install ubuntu 

sbi firmware as -bios argument is not required, qemu 7 provides this 

```bash 
qemu-system-riscv64 \
-machine virt \
-nographic \
-m 8G \
-smp 4 \
-kernel ./u-boot-qemu/uboot.elf \
-object rng-random,filename=/dev/urandom,id=rng \
-device virtio-rng-device,rng=rng \
-device virtio-net-device,netdev=eth0 \
-netdev bridge,br=virbr0,id=eth0 \
-drive file=ubuntu-22.04-live-server-riscv64.img,id=ubuntu,format=raw,if=virtio,index=0 \
-drive file=ubuntu.qcow2,if=virtio,id=ubuntu,index=1 
```

follow install instructions, once finished shutdown the vm

### reboot with installed ubuntu and gentoo as second disk
```bash
qemu-system-riscv64 \
-machine virt \
-nographic \
-m 8G \
-smp 4 \
-kernel ./u-boot-qemu/uboot.elf \
-object rng-random,filename=/dev/urandom,id=rng \
-device virtio-rng-device,rng=rng \
-device virtio-net-device,netdev=eth0 \
-netdev bridge,br=virbr0,id=eth0 \
-drive file=ubuntu.qcow2,if=virtio,id=ubuntu,index=0 \
-drive file=gentoo.qcow2,if=virtio,id=gentoo,index=1
```

now there is a second disk /dev/vdb ... start following the gentoo handbook for maybe amd64 :P
but use stage3 risc-v abi
https://www.gentoo.org/downloads/ riscv stage3 lp64d systemd


### special things in /etc/portage/make.conf (for the riscv machine)
COMMON_FLAGS="-march=rv64imafdc -O2 -pipe"
ACCEPT_KEYWORDS="riscv ~riscv"



### booting installed gentoo
... soon
