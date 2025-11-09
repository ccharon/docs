# Gentoo secureboot, again 20250205
(this time it worked) 
this is no comprehensive guide, just my notes based on my setup. Beware!

My setup is still a UKI on an EFI partition, loaded by systemd boot

## Sources
https://wiki.gentoo.org/wiki/Secure_Boot

## Setup

### install needed packages if not already done
```bash
emerge --ask app-crypt/efitools app-crypt/sbsigntools dev-libs/openssl
```

### create encrypted container to keep keys
i choose this because having private keys with password is not easy to work with when using emerge. I simply mount this container which is encrypted and password protected.

```bash
mkdir /etc/secureboot

cd /root
dd if=/dev/zero of=secureboot.luks bs=1M count=32 status=progress
cryptsetup luksFormat secureboot.luks
cryptsetup open secureboot.luks secureboot # now available as /dev/mapper/secureboot
mkfs.ext4 -L secureboot -t small -m 0 /dev/mapper/secureboot
mount /dev/mapper/secureboot /etc/secureboot
```
### backing up existing secureboot keys
```bash
cd /etc/secureboot
mkdir factory_config
cd factory_config
for key_type in PK KEK db dbx; do efi-readvar -v $key_type -o ${key_type}.esl; done
```

### creating new keys
```bash
cd /etc/secureboot
mkdir custom_config
cd custom_config
uuidgen > uuid.txt

# Generate Keys
for key_type in PK KEK db dbx; do openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Gentoo ${key_type}" -keyout ${key_type}.key -out ${key_type}.crt -days 9999 -noenc -sha256; done

# Merge private + public db key for kernel module signing
cat db.key db.crt > modules.key

# Create Signature Lists
for key_type in PK KEK db dbx; do cert-to-efi-sig-list -g $(< uuid.txt) ${key_type}.crt ${key_type}.esl; done

#
# this is the place where you could add more esl files to your db.esl for example if you created an esl for your graphics card, like described below, you would simply
# cat db.esl nvidia.esl > db-merged.esl
# mv db-merged.esl db.esl 
#

# Copying lists
cd ..
cp custom_config/*.esl .

# Signing the lists
# Sign Platform Key list with Platform Key (PK)
sign-efi-sig-list -k custom_config/PK.key -c custom_config/PK.crt PK PK.esl PK.auth

# Sign Key Exchange Key List with Platform Key (PK)
sign-efi-sig-list -k custom_config/PK.key -c custom_config/PK.crt KEK KEK.esl KEK.auth

# Sign Signature Database Lists with Key Exchange Key (KEK)
for db_type in db dbx; do sign-efi-sig-list -k custom_config/KEK.key -c custom_config/KEK.crt $db_type ${db_type}.esl ${db_type}.auth ; done

```
### prepare the system to use the keys

#### add key locations to /etc/portage/make.conf
```
# Add to USE
USE="secureboot modules-sign ..."

# Secureboot keys
SECUREBOOT_SIGN_KEY="/etc/secureboot/custom_config/db.key"
SECUREBOOT_SIGN_CERT="/etc/secureboot/custom_config/db.crt"

# modules key: cat db.key db.crt > modules.key
MODULES_SIGN_KEY="/etc/secureboot/custom_config/modules.key"
```

#### add key locations to /etc/dracut.conf
```
uefi_secureboot_cert="/etc/secureboot/custom_config/db.crt"
uefi_secureboot_key="/etc/secureboot/custom_config/db.key"
```

### now rebuild kernel
```bash
emerge -1 gentoo-kernel
emerge -1 all the external modules like zfs or nvidia
emerge --config sys-kernel/gentoo-kernel:6.12.47 # use your actual kernel version here 
emerge -1 systemd
bootctl install --no-variables

```

### now rebuild other stuff 
(non kernel tree modules will get a signature this way because of modules-sign in use)
```bash
emerge -uDNpv @world
```

### is the bootloader signed?
after systemd rebuild it should be ...
```
sbverify --cert /etc/secureboot/custom_config/db.crt /efi/EFI/BOOT/BOOTX64.EFI
sbverify --cert /etc/secureboot/custom_config/db.crt /efi/EFI/systemd/systemd-bootx64.efi
```

If not:
```
sbsign --key custom_config/db.key --cert custom_config/db.crt --output /efi/EFI/BOOT/BOOTX64.EFI /efi/EFI/BOOT/BOOTX64.EFI

sbsign --key custom_config/db.key --cert custom_config/db.crt --output /efi/EFI/systemd/systemd-bootx64.efi /efi/EFI/systemd/systemd-bootx64.efi
```

### Install the secureboot keys
Enter UEFI Setup, remove all keys and set secureboot to setup mode, save and leave Uefi setup

### back in Linux install the keys
```bash
# mount the encrypted volume again
cd /etc/secureboot
efi-updatevar -e -f KEK.esl KEK
for db_type in db dbx; do sudo efi-updatevar -e -f ${db_type}.esl $db_type; done
efi-updatevar -f PK.auth PK
```
Successful execution of the last command exits Setup Mode and enters User Mode

### Time to reboot and check if it worked
in UEFI Setup there is sometimes a key management Tab, this should contain only the custom keys now, also Secureboot mode should be "User" now

it might be a good time to setup an uefi password so that secureboot can not be disabled here

#### after booting linux verify
```bash
dmesg | grep Secure
[    0.015381] Secure boot enabled

```

## Scripts to conveniently mount / unmount encrypted container

### mount_secboot.sh
```bash
#!/bin/env bash

cryptsetup luksOpen /root/secureboot.luks secureboot
mount /dev/mapper/secureboot /etc/secureboot
```

### umount_secboot.sh
```bash
#!/bin/env bash

umount /etc/secureboot
cryptsetup luksClose secureboot
```


## Getting Nvidia Graphics to work with self enrolled keys
when trying to use secureboot on a new pc I got the message in UEFI that there is a Secure Boot Violation caused by firmware of one of my devices, which turned out to be the graphics card. So the nvidia card has an Option Rom that could not be loaded anymore after I removed the Microsoft keys.. WHAT THE HELL. 

After some searching and then verifying the bios (extract it and use sbverify --list ) It turned out to be signed with "Microsoft Corporation UEFI CA 2011". Great so I can only have secureboot if this MS Cert is in my DB. ... and on top of all this .. the certificate will expire mid 2026. GREAT!

So 2 Options, Install MS Certificate or disable Secureboot. ... or disable secureboot mid 2026 when the certificate expires. 

BUT there is also the possibility to add the hash of the rom to the allow list, the hash does not expire and also this way no ms cert is needed.

Lets do so.
Sources:
https://www.reddit.com/r/linuxquestions/comments/pi1daj/secure_boot_how_to_extract_nvidia_uefi_boot/

### Tools and preparation
- create a work directory, maybe "nvidia"
- download https://github.com/n0bra1n3r/gpu-passthrough-for-clevo-p650hp6/blob/master/roms/GOPUpd/GOPupd.py (my local copy)
- UEFIRomExtract, I compiled a Linux Version of it, get it here: https://github.com/ccharon/UEFIRomExtract/releases
- install pesign (emerge app-crypt/pesign)
- install virt-firmware (emerge app-emulation/virt-firmware)
  
### Extracting the BIOS
there are several ways to get the rom, i used the sys filesystem, nvflash is an option too.
```bash
# find the rom to extract
ls /sys/bus/pci/devices/*/rom
# result: 
# /sys/bus/pci/devices/0000:01:00.0/rom

# so i have only one pci(e) device with a rom, lets verify the vendor
cat /sys/bus/pci/devices/0000:01:00.0/vendor
# result:
# 0x10de (which identifies nvidia

# ok now extract the rom (as root)
echo 1  > /sys/bus/pci/devices/0000:01:00.0/rom
cat /sys/bus/pci/devices/0000:01:00.0/rom > nvidia_rom.raw
echo 0  > /sys/bus/pci/devices/0000:01:00.0/rom
# now there is a nvidia_rom.raw

# as normal user continue 
./GOPupd.py nvidia_rom.raw ext_efirom
# result (will differ for different cards)
# ID of ROM file    = 10DE-2684 (and a directory nvidia_rom.raw_temp)

# Next unpack the actual bin file
./UEFIRomExtract nvidia_rom.raw_temp/nvidia_rom_compr.efirom nvidia_rom.bin
# result
# nvidia_rom.bin

# if everything worked there is now a signature list on the extracted file
sbverify --list nvidia_rom.bin
# result
#signature 1
#image signature issuers:
# - /C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=Microsoft Corporation UEFI CA 2011
#image signature certificates:
# - subject: /C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=Microsoft Windows UEFI Driver Publisher
#   issuer:  /C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=Microsoft Corporation UEFI CA 2011

```
great thats extracting the rom

### add rom hash value to db

#### first we need to get the actual hash value, this is done with pesign
```bash
$ pesign -h -i nvidia_rom.bin
# result:
# 0a59ecea83664aafdba00e26b87e9a6b5e4e50a5d68e63582f10f982958d6767 nvidia_rom.bin
``` 

#### create a esl containing the hash value
```bash
$ ./virt-fw-sigdb --add-hash "$(< uuid.txt)" "0a59ecea83664aafdba00e26b87e9a6b5e4e50a5d68e63582f10f982958d6767" -o nvidia.esl
```

#### use the esl
i decided to concat the nvidia.esl with the db.esl and install it in setup mode, see above
