# Prepare Gentoo Install on Laptop
with the new binhost feature this shoud be fun.

Installation will be on ZFS, which is in a luks container. from the outside only the efi partition and the luks encrypted partition will be visible
Boot via Systemd + UKI, so no grub and no zfs boot pool is needed

Use something like ubuntu to get a live system running ...

## Setup Disk (mostly taken from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Bookworm%20Root%20on%20ZFS.html)
instead of debian, gentoo gets installed

```bash
set 
export DISK=/dev/disk/by-id/scsi-SATA_disk1

# If the disk was previously used with zfs:
wipefs -a $DISK

# For flash-based storage, if the disk was previously used, you may wish to do a full-disk discard (TRIM/UNMAP), which can improve performance:
blkdiscard -f $DISK

# Clear the partition table
sgdisk --zap-all $DISK


# Create EFI Partition
sgdisk     -n1:1M:+1024M   -t1:EF00 $DISK

# Create Partition for LUKS
sgdisk     -n2:0:0        -t2:8309 $DISK

# Create LUKS Containter

cryptsetup luksFormat -c aes-xts-plain64 -s 512 -h sha256 ${DISK}-part2
cryptsetup luksOpen ${DISK}-part2 luks1

# ZPOOL in LUKS Container erstellen

zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl -O xattr=sa -O dnodesize=auto \
    -O compression=lz4 \
    -O normalization=formD \
    -O relatime=on \
    -O canmount=off -O mountpoint=/ -R /mnt \
    root /dev/mapper/luks1





```
