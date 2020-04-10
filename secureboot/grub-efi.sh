#!/bin/sh

set -eu

GPG_KEY='TODO: add your GPG key id here'
TARGET_EFI='/boot/efi/EFI/boot/bootx64.efi'
SECUREBOOT_DB_KEY='../keys/db.key'
SECUREBOOT_DB_CRT='../keys/db.crt'

# GRUB doesn't allow loading new modules from disk when secure boot is in
# effect, therefore pre-load the required modules.
MODULES=
MODULES="$MODULES part_gpt fat ext2"           # partition and file systems for EFI
MODULES="$MODULES configfile"                  # source command
MODULES="$MODULES verify gcry_sha512 gcry_rsa" # signature verification
MODULES="$MODULES password_pbkdf2"             # hashed password
MODULES="$MODULES echo normal linux linuxefi"  # boot linux
MODULES="$MODULES all_video"                   # video output
MODULES="$MODULES search search_fs_uuid"       # search --fs-uuid
MODULES="$MODULES reboot sleep"                # sleep, reboot

rm -rf tmp
mkdir -p tmp

TMP_GPG_KEY='tmp/gpg.key'
TMP_GRUB_CFG='tmp/grub-initial.cfg'
TMP_GRUB_SIG="$TMP_GRUB_CFG.sig"
TMP_GRUB_EFI='tmp/grubx64.efi'

gpg --export "$GPG_KEY" >"$TMP_GPG_KEY"

cp grub-initial.cfg "$TMP_GRUB_CFG"
rm -f "$TMP_GRUB_SIG"
gpg --default-key "$GPG_KEY" --detach-sign "$TMP_GRUB_CFG"

grub-mkstandalone \
    --directory /usr/lib/grub/x86_64-efi \
    --format x86_64-efi \
    --modules "$MODULES" \
    --pubkey "$TMP_GPG_KEY" \
    --output "$TMP_GRUB_EFI" \
    "boot/grub/grub.cfg=$TMP_GRUB_CFG" \
    "boot/grub/grub.cfg.sig=$TMP_GRUB_SIG"

sbsign --key "$SECUREBOOT_DB_KEY" --cert "$SECUREBOOT_DB_CRT" \
    --output "$TMP_GRUB_EFI" "$TMP_GRUB_EFI"

echo "writing signed grub.efi to '$TARGET_EFI'"
cp "$TMP_GRUB_EFI" "$TARGET_EFI"

rm -r tmp
