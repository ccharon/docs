# Secureboot Linux
WARNING! Work in Progress ... do not use yet

This Guide will help to setup a secured Linux Environment using Secureboot, TPM and Luks.

In the End you will have a System with an encrypted harddrive using secureboot to load a signed grub image that loads a signed kernel and a signed initrd which decrypts your harddrive using a password stored in you TPM Device. 

After this is finished the harddrive layout will be the following:
```
GPT
   |
   ├── EFI (fat32)
   |
   └── Luks encrypted
       |   
       └── LVM
           |
           ├── @ (btrfs)
           |   |
           |   ├── @root (btrfs)
           |   |   
           |   └── @home (btrfs)
           |   
           └── swap (swap)
```

If someone disables Secureboot ... the TPM will not allow access to the key to the harddrive
If someone manipulates the grub.cfg ... grub will not load it, as the signature gets invalid
If someone manipulates the kernel ... grub will not load it, as the signature gets invalid
If someone manipulates the initrd ... grub will not load it, as the signature gets invalid
If someone manipulates grub ... secureboot will not load it, as the signature gets invalid

I hope it is as secure as it sounds :)


## What is needed?
as far as I can tell you'll just need a pc / laptop that has secure boot enabled an a TPM2 Device.
... Software ... 
openssl
grub
luks ..

## Where to start...

### Enable Setup Mode in your UEFI firmware (delete all existing keys) to add your custom keys.
#### Install efitools and sbsigntool on your system.
```bash
sudo apt install efitools sbsigntool -s
``` 
#### Create required keys
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=PK/" -keyout PK.key -out PK.crt -days 7300 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=KEK/" -keyout KEK.key -out KEK.crt -days 7300 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=db/" -keyout db.key -out db.crt -days 7300 -nodes -sha256
``` 
#### Prepare installation in EFI
```bash
cert-to-efi-sig-list PK.crt PK.esl
sign-efi-sig-list -k PK.key -c PK.crt PK PK.esl PK.auth
cert-to-efi-sig-list KEK.crt KEK.esl
sign-efi-sig-list -k PK.key -c PK.crt KEK KEK.esl KEK.auth
cert-to-efi-sig-list db.crt db.esl
sign-efi-sig-list -k KEK.key -c KEK.crt db db.esl db.auth
``` 
#### Install keys into EFI ( PK last as it will enable Custom Mode locking out further unsigned
changes)
```bash
efi-updatevar -f db.auth db
efi-updatevar -f KEK.auth KEK
efi-updatevar -f PK.auth PK
```
The EFI variables may be immutable ( i -flag in lsattr output) in recent kernels (e.g. 4.5.4). Use
```bash
chattr -i to make them mutable again if you can’t update the variables with the commands
```
above

```bash
chattr -i /sys/firmware/efi/efivars/{PK,KEK,db,dbx}-*
# From now on only EFI binaries signed with any db key can be loaded. To sign a binary use:
sbsign --key /path/to/db.key --cert /path/to/db.crt /path/to/efi
# Then use the .signed file to boot.
```

### Grub
GRUB 2 supports loading of GPG signed files only (e.g. config or kernels) through the verifymodule. The grub-mkstandalone command can be used to create a single GRUB binary. It can
also embed an initial grub.cfg (however this file must be signed!). The --pubkey option adds a
GPG public key which will be used for verification

#### Signed grub image
[grub-initial.cfg](./grub-initial.cfg)

Replace the first TODO with the result of grub-mkpasswd-pbkdf2 with your custom passphrase.
The user/password is required to restrict access to the GRUB shell which allows running arbitrary
commands. The GRUB documentation states that check_signatures=enforce will prevent
any future loading of unsigned files so an attacker shouldn’t be able to load any modified files, but
better be safe.

Replace the second TODO with the UUID of your EFI system partition. With the following output
of lsblk -f , replace it with 891F-FF86 .

NAME
sda
├─sda1
...
FSTYPE
vfat
LABEL UUID
891F-FF86
MOUNTPOINT
/boot/efi

The mentioned grub.cfg will contain the current list of kernels and is not stored in the EFI file
directly so the Secure Boot db key doesn’t have to be available when a new kernel is installed.
Only the GPG key used by GRUB is necessary. The grub.cfg is of course also signed with this
GPG key.

The following script will use a Secure Boot db key (generated above) to provide a single GRUB
EFI binary which contains the grub-initial.cfg . Adapt the GPG key id and the paths as
necessary.

[grub-efi.sh](./grub-efi.sh)
