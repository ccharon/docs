# Gentoo Installation on encrypted ZFS
This document helps to install Gentoo Linux on an encrypted zfs pool
Ideas taken from:
- [Debian Bookworm ZFS Root](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Bookworm%20Root%20on%20ZFS.html)

The final layout will be this. There will be just one EFI Partition that holds systemd boot and UKI unified kernel images to boot, so no grub and boot pool and such. also there is no swap. partition.

```
SSD (GPT) nvme0n1
   ├── nvme0n1p1 EFI(fat32) /boot/efi
   └── nvme0n1p2 ZPOOL (system)
       ├── moon                             /
       ├── moon/tmp                         /tmp
       ├── moon/var                         /var
       ├── moon/var/cache                   /var/cache
       ├── moon/var/lib                     /var/lib
       ├── moon/var/lib/AccountsService     /var/lib/AccountsService
       ├── moon/var/lib/NetworkManager      /var/lib/NetworkManager
       ├── moon/var/lib/docker              /var/lib/docker
       ├── moon/var/lib/libvirt             /var/lib/libvirt
       ├── moon/var/log                     /var/log
       ├── moon/var/spool                   /var/spool
       ├── moon/var/tmp                     /var/tmp
       ├── moon/home                    ---
       ├── moon/home/kevin                  /home/kevin
       └── moon/home/root                   /root
```
I choose to name the pool "system" and then have all datasets start with the systemname, this should allow for easy backup to a backup pool used by more than one system

Asf for the datasets, it is a mixture of what the debian on zfs root shows, of things that are reasonable for gentoo (binpkgs, distfiles) and what I would prefer :P

For this document the the example username will be "gru" the systems name will be "moon" (not the small one from las vegas)

## Preparing the disk
```bash
# always use the long /dev/disk/by-id/* aliases with ZFS
DISK=/dev/disk/by-id/nvme-WD_Blue_SN570_2TB_XXXXXXXXXXXX

# clear the partition table
sgdisk --zap-all $DISK

# create efi partition, 1gb uki can be big :)
sgdisk     -n1:1M:+1G   -t1:EF00 $DISK

# format efi partition
mkfs.fat -F32 -n EFI ${DISK}-part1

# create the partition for the zfs pool
sgdisk     -n2:0:0        -t2:BF00 $DISK

```

## Creating the ZPOOL and Datasets

### Pool
```bash
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -O encryption=aes-256-gcm -O keylocation=prompt -O keyformat=passphrase \
    -O acltype=posixacl -O xattr=sa -O dnodesize=auto -O aclinherit=passthrough \
    -O compression=lz4 \
    -O normalization=formD \
    -O relatime=on \
    -O canmount=off -O mountpoint=/ -R /mnt \
    backup ${DISK}-part2
```

### Datasets
```bash
zfs create -o canmount=noauto -o mountpoint=/ system/moon
zfs mount system/moon

zfs create -o com.sun:auto-snapshot=false   system/moon/tmp
chmod 1777 /mnt/tmp
zfs create -o canmount=off                  system/moon/var
zfs create -o com.sun:auto-snapshot=false   system/moon/var/cache
zfs create -o canmount=off                  system/moon/var/lib
zfs create                                  system/moon/var/lib/AccountsService
zfs create                                  system/moon/var/lib/NetworkManager
zfs create                                  system/moon/var/lib/docker
zfs create -o com.sun:auto-snapshot=false   system/moon/var/lib/libvirt
zfs create                                  system/moon/var/log
zfs create                                  system/moon/var/spool
zfs create                                  system/moon/var/tmp
chmod 1777 /mnt/var/tmp

zfs create                                  system/moon/home
zfs create -o mountpoint=/root              system/moon/home/root
chmod 700 /mnt/root
zfs create                                  system/moon/home/kevin
chmod 700 /mnt/home/kevin
# do not forget to change ownership to kevin once the user is created
```


## Install Gentoo according to the handbook (right after setting up disks)

### make conf

```
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.

# match binhost
COMMON_FLAGS="-O2 -pipe -march=x86-64-v3"

CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C.utf8

MAKEOPTS="-j4 -l4"

L10N="de"
LINGUAS="${L10N}"

PORTAGE_NICENESS="19"

VIDEO_CARDS="intel"

USE="zfs dist-kernel zeroconf kdesu uki cryptsetup x265 lvm"

EMERGE_DEFAULT_OPTS="--getbinpkg --binpkg-respect-use=y --rebuilt-binaries --quiet-build=y"
#EMERGE_DEFAULT_OPTS="--getbinpkg --rebuilt-binaries --quiet-build=y"

FEATURES="${FEATURES} binpkg-request-signature"

```

### fstab
### zfs tools
### dracut + kernel
