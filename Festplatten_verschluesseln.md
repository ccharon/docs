# Festplatte partitionieren
1. neue GPT Partitionstabelle
    
    `fdisk /dev/sda`
    
    in fdisk dann `g` create empty gpt partition table


2. eine Partition anlegen

    in fdisk `n` 

3. typ der Partition auf Linux 
    
    in fdisk `t`

4. speichern

    in fdisk `w`

5. für sdb wiederholen

# Cryptsetup
## Partition verschlüsseln
`cryptsetup -y -v luksFormat /dev/sda1 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000`

`cryptsetup -y -v luksFormat /dev/sdb1 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000`


## Keyfile generieren
`mkdir /etc/luks-keys/; dd if=/dev/urandom of=/etc/luks-keys/phobos bs=64 count=1`

`mkdir /etc/luks-keys/; dd if=/dev/urandom of=/etc/luks-keys/deimos bs=64 count=1`

`chmod 0400 /etc/luks-keys/*`

## Key zu verschluesseltem Volume hinzufuegen
`cryptsetup luksAddKey /dev/sda1 --key-size 512 --iter-time 2000 --hash sha512 /etc/luks-keys/phobos`

`cryptsetup luksAddKey /dev/sdb1 --key-size 512 --iter-time 2000 --hash sha512 /etc/luks-keys/deimos`


## Volume Informationen
`cryptsetup luksDump /dev/sda1`

## Crypttab anpassen
```bash
echo "phobos UUID="`blkid -s UUID -o value /dev/sda1`" /etc/luks-keys/phobos luks" >> /etc/crypttab
echo "deimos UUID="`blkid -s UUID -o value /dev/sdb1`" /etc/luks-keys/deimos luks" >> /etc/crypttab
```

## cryptdisks starten

`cryptdisk_start phobos deimos`

# dateisysteme erzeugen

`mkfs.ext4 -L phobos -m 0 /dev/mapper/phobos`

`mkfs.ext4 -L deimos -m 0 /dev/mapper/deimos`

## fstab 
mkdir -p /vault/phobos /vault/deimos 

/dev/mapper/phobos  /vault/phobos   ext4    defaults,nodev,nosuid,noexec 0 0

/dev/mapper/deimos  /vault/deimos   ext4    defaults,nodev,nosuid,noexec 0 0
