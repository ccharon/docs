# Gentoo secureboot --- again 20250205
(this time it worked) :P

this is no comprehensive guide, just my notes based on my setup. Beware! :P

my setup is still a UKI on an EFI partition, loaded by systemd boot

## Sources
https://wiki.gentoo.org/wiki/Secure_Boot

## Setup

### create encrypted container to keep keys
i choose this because having private keys with password is not easy to work with when using emerge. I simply mount this container which is encrypted and password protected.

```bash
cd /root
mkdir secureboot

dd if=/dev/zero of=secureboot.luks bs=1M count=32 status=progress
cryptsetup luksFormat secureboot.luks
cryptsetup open secureboot.luks secureboot # now available as /dev/mapper/secureboot
mkfs.ext4 -L secureboot -t small -m 0 /dev/mapper/secureboot
mount /dev/mapper/secureboot /root/secureboot
```
### backing up existing secureboot keys
```bash
cd /root/secureboot
mkdir factory_config
cd factory_config
for key_type in PK KEK db dbx; do efi-readvar -v $key_type -o ${key_type}.esl; done
```

### creating new keys
```bash
cd /root/secureboot
mkdir custom_config
cd custom_config
uuidgen > uuid.txt

# Generate Keys
for key_type in PK KEK db dbx; do openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Gentoo ${key_type}" -keyout ${key_type}.key -out ${key_type}.crt -days 9999 -noenc -sha256; done

# Merge private + public db key for kernel module signing
cat db.key db.cert > modules.key

# Create Signature Lists
for key_type in PK KEK db dbx; do cert-to-efi-sig-list -g $(< uuid.txt) ${key_type}.crt ${key_type}.esl; done

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
SECUREBOOT_SIGN_KEY="/root/secureboot/custom_config/db.key"
SECUREBOOT_SIGN_CERT="/root/secureboot/custom_config/db.crt"

# modules key: cat db.key db.crt > modules.key
MODULES_SIGN_KEY="/root/secureboot/custom_config/modules.key"
```

#### add key locations to /etc/dracut.conf
```
uefi_secureboot_cert="/root/secureboot/custom_config/db.crt"
uefi_secureboot_key="/root/secureboot/custom_config/db.key"
```

### now rebuild kernel
```bash
emerge -1 gentoo-kernel
```

### now rebuild other stuff 
(non kernel tree modules will get a signature this way because of modules-sign in use)
```bash
emerge -uDNpv @world
```

### is the bootloader signed?
most likely not, check ...
```
sbverify --cert /root/secureboot/custom_config/db.crt /efi/EFI/BOOT/BOOTX64.EFI
sbverify --cert /root/secureboot/custom_config/db.crt /efi/EFI/systemd/systemd-bootx64.efi
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
cd /root/secureboot
efi-updatevar -e -f KEK.esl KEK
for db_type in db dbx; do sudo efi-updatevar -e -f ${db_type}.esl $db_type; done
efi-updatevar -f PK.auth PK
```
Successful execution of the last command exits Setup Mode and enters User Mode
