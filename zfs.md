# ZFS Backup Pool Creation

## creating a "container" zpool 
```bash
zpool create -f -o ashift=12 -O acltype=posixacl -O aclinherit=passthrough -O atime=off -O canmount=off -O devices=off -O dnodesize=auto -O mountpoint=/backup -O normalization=formD -O xattr=sa rpool raidz2 /dev/disk/by-id/ata-harddrive1_serialnr \ 
  /dev/disk/by-id/ata-harddrive2_serialnr \ 
  /dev/disk/by-id/ata-harddrive3_serialnr \ 
  /dev/disk/by-id/ata-harddrive4_serialnr \ 
  /dev/disk/by-id/ata-harddrive5_serialnr 
  
    
```

|Option|Meaning|
|------|---------|
|autotrim=on|enables trim if running on ssd|
|ashift=12|enforces a sectorsize of 4,096 byte for pool|
|acltype=posixacl|enables the use of posix acl (getfacl, setfacl). This feature allows you to store additional access rights (per user and/or per group) on files and directories, adding to the regular access rights you set through chmod/chown. This additional information is stored as "extended atrributes" or xattr (along with other information like SELinux information and SAMBA vfs info).|
|xattr=sa|By default, zfs sets the xattr flag to "on", which causes it to store the xattr information in hidden subdirectories it creates for every file or folder written to the dataset. Each subsequent read or write action will trigger an additional seek and read on the disk, which will take extra time and slow down IO significantly. Settings xattr=sa will store the extended attributes in the inode, so no additional read is needed to get the posixacls on the file. The reason xattr is set to on by default is because some older/exotic operating systems don’t play nice with storing xattr’s in the inode.|
|atime=off|Controls whether the access time for files is updated when they are read. Turning this property off avoids producing write traffic when reading files and can result in significant performance gains, though it might confuse mailers and other similar utilities. The values on and off are equivalent to the atime and noatime mount options. The default value is on|
|aclinherit=passthrough|applied acls get passed to dependend objects, for example when creating a file in a directory|
|canmount=off|If this property is set to off, the file system cannot be mounted by using the zfs mount or zfs mount -a commands. Setting this property is similar to setting the mountpoint property to none, except that the dataset still has a normal mountpoint property that can be inherited. For example, you can set this property to off, establish inheritable properties for descendent file systems, but the file system itself is never mounted nor is it accessible to users. In this case, the parent file system with this property set to off is serving as a container so that you can set attributes on the container, but the container itself is never accessible.|
|devices=off|Controls whether device nodes can be opened on this file system. The default value is on The values on and off are equivalent to the dev and nodev mount options.|
|dnodesize=auto|Consider setting dnodesize to auto if the dataset uses the xattr=sa property setting and the workload makes heavy use of extended attributes. This may be applicable to SELinux-enabled systems, Lustre servers, and Samba servers, for example. Literal values are supported for cases where the optimal size is known in advance and for performance testing.|
|normalization=formD|Indicates whether the file system should perform a unicode normalization of file names whenever two file names are compared, and which normalization algorithm should be used. File names are always stored unmodified, names are normalized as part of any comparison process. If this property is set to a legal value other than none and the utf8only property was left unspecified, the utf8only property is automatically set to on The default value of the normalization property is none This property cannot be changed after the file system is created.|
|-R /mnt/alternate|alternative to mountpoint specified by "mountpount=/mount/point" it is used when the first mountpoint is in use"|

## creating a dataset BACKUP, another container for all the datasets concerning backups 
this dataset also specifies zstd as compression
```bash
zfs create -o canmount=off -o compression=zstd -o mountpoint=none rpool/BACKUP
```
## creating a dataset VAULT, another container
this dataset also specifies zstd as compression and aes encryption with password
```bash
zfs create -o canmount=off -o compression=zstd -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt -o mountpoint=none rpool/VAULT
```

## creating as many datasets in BACKUP as needed
no need to set compression as all paramters will be inherited from rpool/BACKUP
```bash
zfs create -o canmount=on -o mountpoint=/backup/documents rpool/BACKUP/documents
zfs create -o canmount=on -o mountpoint=/backup/pictures rpool/BACKUP/pictures
```

## creating as many datasets in VAULT as needed
no need to set compression or encryption as all paramters will be inherited from rpool/VAULT
```bash
zfs create -o canmount=on -o mountpoint=/vault/stuff rpool/VAULT/stuff
```

## fun things to do with encryption
```bash
# checking encryption status
zfs get -p encryption,keystatus

# unloading keys
zfs unload-key rpool/VAULT

# loading keys
zfs load-key rpool/VAULT

# before unloading unmounting child datasets might be nessesary
zfs umount rpool/VAULT/stuff
```
## replacing a damaged disk
find out which disk is damaged.
```bash
zpool list
```
look for degraded or missing drive
now shutdown and replace the hardware with a new drive.

after the system is running again swap the device in the pool. to do so do again ```zpool list``` now the missing device should show as number. use this number for the replace command

next thing is to find out the name of the newly added disk with ```ls /dev/disk/by-id/``` identify the new disk an use the name found.

poolname should be the actual name of the pool :)

the command should look something like this:

```bash
sudo zpool replace -f poolname 11596883435372076569 /dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WX11DC61YU1R

```

now the disk will be replaced ... resilver will take a while depending on the pool size. after it finished the replacement is done

## docker with zfs storage driver
for me docker stores images as datasets directly "next" to the root data set. this does not please me :P
so create datasets for docker images
```bash
zfs create -o canmount=off -o compression=zstd -o mountpoint=none rpool/DOCKER
zfs create -o canmount=off -o mountpoint=none rpool/DOCKER/hostname # replace with your hostname
```

then tell docker to use the dataset 
```bash
$ sudo systemctl stop docker
$ sudo nano /etc/docker/daemon.json

{
  "storage-driver": "zfs",
  "storage-opts": [ "zfs.fsname=rpool/DOCKER/hostname"]
}

$ sudo systemctl start docker
```
time to clean up the old datasets (and redownload all images :P)

## 2 Two half filled ssds to zfs mirror ...
- drive 1 /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_XXXXX
- drive 1 /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_YYYYY

empty drive 1, move everything from drive 1 to drive 2

after drive 1 is emptied, destroy the filesystem
```bash 
sgdisk --zap-all /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_XXXXX
```
then create a zpool to your liking
```bash 
zpool create -f -o ashift=12 -O compression=lz4 -O acltype=posixacl -O aclinherit=passthrough -O atime=off -O canmount=off -O devices=off -O dnodesize=auto -O mountpoint=/data -O normalization=formD -O xattr=sa -o autotrim=on data /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_XXXXX

# and create the volumes you need
zfs create -o canmount=off -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt -o mountpoint=none data/VAULT
zfs create -o canmount=on -o mountpoint=/data/foo data/VAULT/foo
zfs create -o canmount=on -o mountpoint=/data/bar data/VAULT/bar


# now move the data from drive 2 to foo and bar :P
# after this has finished, destroy filesystem on drive 2 and attach to zpool
sgdisk --zap-all /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_YYYYY

# it is important to use attach! using add will create a stripeset (raid0) but what i want is a mirror so attach it is!
zpool attach -f data /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_XXXXX /dev/disk/by-id/ata-Samsung_SSD_860_QVO_2TB_YYYYY
```
the attach command will start a resilver so that the data is actually mirrored. resilver will take some time


## checking disks for bad sectors (destroys data)
(taken from https://wiki.archlinux.org/title/badblocks)
1. Span a crypto layer above the device: ```cryptsetup open /dev/device name --type plain --cipher aes-xts-plain64```
2. Fill the now opened decrypted layer with zeroes, which get written as encrypted data: ```shred -v -n 0 -z /dev/mapper/name```
3. Compare fresh zeroes with the decrypted layer: ```cmp -b /dev/zero /dev/mapper/name``` If it just stops with a message about end of file, the drive is fine. This method is also way faster than badblocks even with a single pass. As the command does a full write, any bad sectors (as known to the disk controller) should also be eliminated.

