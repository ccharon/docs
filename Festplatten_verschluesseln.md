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
mkfs.ext4 -L phobos -m 0 /dev/mapper/phobos
mkfs.ext4 -L deimos -m 0 /dev/mapper/deimos
```

## fstab 
```bash
mkdir -p /vault/phobos /vault/deimos 
echo "/dev/mapper/phobos  /vault/phobos   ext4    defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
echo "/dev/mapper/deimos  /vault/deimos   ext4    defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
```
