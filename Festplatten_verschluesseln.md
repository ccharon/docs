# Systemplatte
es wird davon ausgegangen das es schon irgendwas installiertes gibt das nicht verschlüsselt ist.
Ziel ist es dieses Layout anzulegen:

```
GPT
   |
   ├── EFI (fat32)
   |
   ├── boot (ext4)
   |
   └── Luks encrypted
       |   
       └── LVM
           |
           ├── root (btrfs)
           |   
           └── swap (swap)
```

## Booten des Systems per Rettungsystem 
irgendwas mit dem man die Sicherung des bisherigen Systems vornehmen kann. ubuntu live dvd oder so gemouted nach /backup

## Daten sichern
Sichern von boot und root, auf eine externe Platte
zu sichernde Dateisysteme mounten dann:

```bash

mkdir -p /old/efi /old/boot /old/root

# auf mannigfaltige art und weise die dateisysteme unter die verzeichnisse mounten,
# wenn es keine boot partition gibt, einfach auslassen.

# evtl ist es hilfreich zu wissen wie man lvm volumes manuell einbindet:
#falls nötig
apt-get install lvm2
vgscan

# dann die volume group(s) aktivieren
vgchange -a y <nameDerVolumeGroup>

# jetzt sind die volumes unter /dev/mapper/ verfügbar

# alles sichern
cd /old/efi
tar cvjf /backup/efi.tar.bz2 *

# nur falls man eine boot partition hatte
cd /old/boot
tar cvjf /backup/boot.tar.bz2 *

cd /old/root
tar --exclude=dev/* \
--exclude=proc/* \
--exclude=sys/* \
--exclude=tmp/* \
--exclude=var/tmp/* \
--exclude=var/lock/* \
--exclude=var/log/* \
--exclude=var/run/* \
--exclude=.bash_history \
--exclude=lost+found \
--exclude=var/cache/apt/packages/* \
-cvjf /backup/root.tar.bz2 *

# Swap wird nicht gesichert ... warum auch

cd /
umount /old/boot
umount /old/efi
umount /old/root

# ggf. Volumegroup deaktivieren
vgchange -a n <nameDerVolumeGroup>

```

## Festplatte neu partitionieren
ACHTUNG: hier gehen alle Daten flöten, also im Zweifelsfall nochmal die eben erstellten tar Dateien checken

(500gb ssd die ein bisschen freien platz behält)
```bash
parted --script /dev/nvme0n1 "mklabel gpt"

# 512MB EFI Partition
parted --script /dev/nvme0n1 "mkpart primary fat32 1MiB 513MiB"
parted --script /dev/nvme0n1 "set 1 esp on"

# 1024MB boot Partition
parted --script /dev/nvme0n1 "mkpart primary ext4 513MiB 1537MiB"

# der Rest wird Luks
parted --script /dev/nvme0n1 "mkpart primary ext4 1537MiB 100%"


```

## Verschlüsselung und formatieren
```bash
# erst mal die efi partition formatieren
mkfs.fat -F32 -n EFI /dev/nvme0n1p1

# boot partition formatieren
mkfs.ext4 -L boot /dev/nvme0n1p2

# mit luks die lvm partition verschluesseln
cryptsetup -y -v luksFormat /dev/nvme0n1p3 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000

# verschluesselte partition zum formatieren öffnen
cryptsetup luksOpen /dev/nvme0n1p3 ares

# LVM Setup
pvcreate /dev/mapper/ares
vgcreate ares /dev/mapper/ares
lvcreate --name root --size 384G ares
lvcreate --name swap --size 38G ares

# formatieren des root Dateisystems
mkfs.btrfs -f -L root /dev/ares/root

# subvolume layout aufbauen
mount /dev/ares/root /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@snapshots
umount /mnt

# swap formatieren
mkswap /dev/ares/swap

# neue dateisysteme an temporäre stelle mounten
mkdir -p /new/root

mount /dev/ares/root /new/root -t btrfs -o subvol=@,compress=zstd


```

## Dateisysteme wieder füllen

```bash
cd /new/root
tar xpvf /backup/root.tar.bz2 --xattrs-include='*.*' --numeric-owner

mount /dev/nvme0n1p2 /new/root/boot
cd boot
tar xpvf /backup/boot.tar.bz2 --xattrs-include='*.*' --numeric-owner

mount /dev/nvme0n1p1 /new/root/boot/efi
cd efi
tar xpvf /backup/efi.tar.bz2 --xattrs-include='*.*' --numeric-owner

```

## jetzt geht es in dem neuen Dateisystem weiter
```bash
# vorbeiten verschiedener sachen damit die chroot umgebung funktioniert
mount --rbind /dev /new/root/dev
mount --make-rslave /new/root/dev
mount -t proc /proc /new/root/proc
mount --rbind /sys /new/root/sys
mount --make-rslave /new/root/sys
mount --rbind /tmp /new/root/tmp

cp /etc/resolv.conf /new/root/etc/resolv.conf

chroot /new/root /bin/bash
source /etc/profile
```

## wieder bootfähig machen
### Crypttab anpassen
```bash
echo "luks-`blkid -s UUID -o value /dev/nvme0n1p3` UUID=\"`blkid -s UUID -o value /dev/nvme0n1p3`\" none luks,discard" >> /etc/crypttab

```

### fstab anpassen

neue Einträge für root, efi und swap hinzufügen
```bash
# root
echo "UUID=`blkid -s UUID -o value /dev/ares/root`   /  btrfs   defaults,subvol=@,compress=zstd,noatime,autodefrag 0  0" >> /etc/fstab

# boot
echo "UUID=`blkid -s UUID -o value /dev/nvme0n1p2`   /boot  ext4  defaults 0  1" >> /etc/fstab

# efi
echo "UUID=`blkid -s UUID -o value /dev/nvme0n1p1`   /boot/efi  vfat  umask=0077 0  1" >> /etc/fstab

# swap
echo "UUID=`blkid -s UUID -o value /dev/ares/swap`   none  swap  sw 0  0" >> /etc/fstab

```
jetzt die fstab mit einem editor öffnen und die alten Werte für root, efi, swap und evtl boot rauswerfen.

### initramfs an die neue config anpassen
```bash
apt-get install --reinstall cryptsetup-initramfs

echo "RESUME=/dev/ares/swap" > /etc/initramfs-tools/conf.d/resume
echo "UMASK=0077" >> /etc/initramfs-tools/initramfs.conf
```




### grub.cfg auf der EFI Partition ersetzen
```bash

### grub.cfg anpassen damit verschluesselte partitionen beachtet werden
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub

# grub installieren
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian
```

jetzt kann man neustarten!

## nach dem neustart noch snapper konfigurieren
### /etc/fstab Eintrag für Subvolume @snapshots
```bash
echo "UUID=`blkid -s UUID -o value /dev/ares/root`   /.snapshots  btrfs   subvol=@snapshots,defaults,compress=zstd,noatime,autodefrag  0  0" >> /etc/fstab
```
### snapper installieren und config anlegen
```bash
apt-get install snapper
snapper -c root create-config /
```
### das Verzeichnis das Snapper angelegt hat löschen und neu anlegen
```bash
rm -rf /.snapshots
mkdir /.snapshots
rm -rf /.snapshots
mount /.snapshots
```

# Datenfestplatten
## Festplatten partitionieren
```bash
 parted --script /dev/sda "mklabel gpt"
 parted --script /dev/sda "mkpart primary 1 max"

 parted --script /dev/sdb "mklabel gpt"
 parted --script /dev/sdb "mkpart primary 1 max"
```

## Cryptsetup
### Partition verschlüsseln
```bash
cryptsetup -y -v luksFormat /dev/sda1 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000
cryptsetup -y -v luksFormat /dev/sdb1 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000
```

### Keyfile generieren
```bash
mkdir /etc/luks-keys/; dd if=/dev/urandom of=/etc/luks-keys/phobos bs=64 count=1
mkdir /etc/luks-keys/; dd if=/dev/urandom of=/etc/luks-keys/deimos bs=64 count=1
chmod 0400 /etc/luks-keys/*
```

### Key zu verschluesseltem Volume hinzufuegen
```bash
cryptsetup luksAddKey /dev/sda1 --key-size 512 --iter-time 2000 --hash sha512 /etc/luks-keys/phobos
cryptsetup luksAddKey /dev/sdb1 --key-size 512 --iter-time 2000 --hash sha512 /etc/luks-keys/deimos
```

### Crypttab anpassen
```bash
echo "phobos UUID=\"`blkid -s UUID -o value /dev/sda1`\" /etc/luks-keys/phobos luks,key-slot=1" >> /etc/crypttab
echo "deimos UUID=\"`blkid -s UUID -o value /dev/sdb1`\" /etc/luks-keys/deimos luks,key-slot=1" >> /etc/crypttab
```

### Cryptdisks starten
```bash
cryptdisk_start phobos deimos
```

## dateisysteme erzeugen
```bash
mkfs.btrfs -f -L vault -m raid1 -d raid1 /dev/mapper/phobos /dev/mapper/phobos
```


### subvolume layout aufbauen
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

## zwischendurch kann man einfach mal schauen ob das anlegen des Dateisystems soweit gut war. es müsste Data, Metadata und System RAID1 dabei sein
btrfs fi usage /vault

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@snapshots
umount /mnt
```

### Mountpunkte in der richtigen Reihenfolge anlegen und snapper konfigurieren 
```bash
## Mountpunkt anlegen
mkdir /vault

## /etc/fstab Eintrag für Subvolume @ (die eigentlichen Daten)
echo "UUID=`blkid -s UUID -o value /dev/mapper/phobos`   /vault  btrfs   subvol=@,device=/dev/mapper/deimos,device=/dev/mapper/phobos,defaults,rw,user,nofail,nodev,nosuid,noexec,noatime,autodefrag  0  0" >> /etc/fstab

## /etc/fstab Eintrag für Subvolume @snapshots
echo "UUID=`blkid -s UUID -o value /dev/mapper/phobos`   /vault/.snapshots  btrfs   subvol=@snapshots,device=/dev/mapper/deimos,device=/dev/mapper/phobos,defaults,rw,user,nofail,nodev,nosuid,noexec,noatime,autodefrag  0  0" >> /etc/fstab

## jetzt Datenvolume mounten und Berechtigungen anpassen
mount /vault
chown root:users /vault/.
chmod 0770 /vault/.

## snapper installieren und config anlegen
apt-get install snapper
snapper -c vault create-config /vault

## das Verzeichnis das Snapper angelegt hat löschen
rm -rf /vault/.snapshots

## und neu anlegen und jetzt das subvolume reinmounten
mkdir /vault/.snapshots
mount /vault/.snapshots
chmod 0750 /vault/.snapshots
chown root:users /vault/.snapshots

## falls der normale Benutzer noch nicht in der users gruppe ist ...
usermod -a -G users username

```

## regelmäßiges Dateisystem aufräumen (scrub)
apt-get install btrfsmaintenance

dann die /etc/default/btrfsmaintenance anpassen
https://github.com/kdave/btrfsmaintenance/blob/master/README.md

## was kann man noch machen
snapper-gui installieren
```bash
apt-get install snapper-gui
```

und was man noch angucken kann ist wie man btrfs snapshots transferieren kann auf eine backup platte zum Beispiel

## quellen aus denen ich das hab
https://computingforgeeks.com/working-with-btrfs-filesystem-in-linux/

https://blog.bmarwell.de/zwei-festplatten-in-einem-btrfs-raid1-zusammenfuehren/

https://wiki.archlinux.org/index.php/Snapper
