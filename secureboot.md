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

* Enable Setup Mode in your UEFI firmware (delete all existing keys) to add your custom keys.
* Install efitools and sbsigntool on your system.
```bash
sudo apt install efitools sbsigntool -s
``` 
* Create required keys
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=PK/" -keyout PK.key -out PK.crt -days 7300 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=KEK/" -keyout KEK.key -out KEK.crt -days 7300 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=db/" -keyout db.key -out db.crt -days 7300 -nodes -sha256
``` 
* Prepare installation in EFI
```bash
cert-to-efi-sig-list PK.crt PK.esl
sign-efi-sig-list -k PK.key -c PK.crt PK PK.esl PK.auth
cert-to-efi-sig-list KEK.crt KEK.esl
sign-efi-sig-list -k PK.key -c PK.crt KEK KEK.esl KEK.auth
cert-to-efi-sig-list db.crt db.esl
sign-efi-sig-list -k KEK.key -c KEK.crt db db.esl db.auth
``` 
