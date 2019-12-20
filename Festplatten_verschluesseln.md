# Festplatten partitionieren
```bash
 parted --script /dev/sda "mklabel gpt"
 parted --script /dev/sda "mkpart primary 1 max"

 parted --script /dev/sdb "mklabel gpt"
 parted --script /dev/sdb "mkpart primary 1 max"
```

# Cryptsetup
## Partition verschlüsseln
```bash
cryptsetup -y -v luksFormat /dev/sda1 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000
cryptsetup -y -v luksFormat /dev/sdb1 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000
```

## Keyfile generieren
```bash
mkdir /etc/luks-keys/; dd if=/dev/urandom of=/etc/luks-keys/phobos bs=64 count=1
mkdir /etc/luks-keys/; dd if=/dev/urandom of=/etc/luks-keys/deimos bs=64 count=1
chmod 0400 /etc/luks-keys/*
```

## Key zu verschluesseltem Volume hinzufuegen
```bash
cryptsetup luksAddKey /dev/sda1 --key-size 512 --iter-time 2000 --hash sha512 /etc/luks-keys/phobos
cryptsetup luksAddKey /dev/sdb1 --key-size 512 --iter-time 2000 --hash sha512 /etc/luks-keys/deimos
```

## Crypttab anpassen
```bash
echo "phobos UUID=\"`blkid -s UUID -o value /dev/sda1`\" /etc/luks-keys/phobos luks" >> /etc/crypttab
echo "deimos UUID=\"`blkid -s UUID -o value /dev/sdb1`\" /etc/luks-keys/deimos luks" >> /etc/crypttab
```

## Cryptdisks starten
```bash
cryptdisk_start phobos deimos
```

# dateisysteme erzeugen
```bash
mkfs.btrfs -f -L vault -m raid1 -d raid1 /dev/mapper/phobos /dev/mapper/phobos
```


## subvolume layout aufbauen
Um sicherzustellen das man an die Snapshots rankommt wenn das eigentliche Volume Probleme hat kommt das Snapshot Subvolume @snapshots auf das gleiche Level wie das eigentliche Daten Subvolume (@) später wird dann @snapshots unter ./snapshots ins Datenvolume gemounted

```
subvolid=5
   |
   ├── @
   |       |
   |       ├── /.snapshots
   |       |
   |       ├── /daten
   |       |
   |       ├── blubbb
   |       |
   |       ├── ...
   |
   ├── @snapshots
   |
   └── @...
```

also los:
Ein btrfs raid1 kann man mounten indem man einfach ein device des raids mounted, in der fstab wird später auf nummer sicher gegangen.
```bash
mount /dev/mapper/phobos /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@snapshots
umount /mnt
```

## fstab 
```bash
mkdir /vault
echo "UUID=`blkid -s UUID -o value /dev/mapper/phobos`   /vault  btrfs   subvol=@,device=/dev/mapper/deimos,device=/dev/mapper/phobos,defaults,rw,user,nofail,nodev,nosuid,noexec   0   2" >> /etc/fstab
echo "UUID=`blkid -s UUID -o value /dev/mapper/phobos`   /vault/.snapshots  btrfs   subvol=@snapshots,device=/dev/mapper/deimos,device=/dev/mapper/phobos,defaults,rw,user,nofail,nodev,nosuid,noexec   0   2" >> /etc/fstab
mount /vault
mkdir /vault/.snapshots
mount /vault/.snapshots
chmod 0750 /vault/.snapshots
chown root:users /vault/.snapshots

```



## mounten
```bash
mount /vault
```

## automatische Snapshots konfigurieren
```bash
apt-get install snapper
```




