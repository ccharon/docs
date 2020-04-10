# Secureboot Linux
WARNING! Work in Progress ... do not use yet

This Guide will help to setup a secured Linux Environment using Secureboot, TPM and Luks.

## What is needed?
as far as I can tell you'll just need a pc / laptop that has secure boot enabled an a TPM2 Device.
... Software ... 
openssl
grub
luks ..

## Where to start...

Enable Setup Mode in your UEFI firmware (delete all existing keys) to add your custom keys.
Install efitools and sbsigntool on your system.

```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=PK/" -keyout PK.key -out PK.crt -days 7300 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=KEK/" -keyout KEK.key -out KEK.crt -days 7300 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=db/" -keyout db.key -out db.crt -days 7300 -nodes -sha256
``` 

