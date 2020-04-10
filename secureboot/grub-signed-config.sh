#!/bin/sh

set -eu

GPG_KEY='TODO: add your GPG key id here'
BOOT_DIRECTORY='/boot'      # source, no trailing /
EFI_DIRECTORY='/boot/efi'   # target, no trailing /
KERNEL_PREFIX='vmlinuz-'
INITRD_PREFIX='initrd.img-'

escape_for_sed() {
    printf '%s' "$1" | sed 's!/!\\/!g'
}

rm -rf tmp
mkdir tmp

TMP_GRUB_CFG=tmp/grub.cfg
TMP_KERNELS=tmp/kernels

: >"$TMP_KERNELS"
for x in "$BOOT_DIRECTORY/$KERNEL_PREFIX"*; do
    printf '%s\n' "$x" >>"$TMP_KERNELS"
done

# Newest kernel first.
cat grub.cfg.head >"$TMP_GRUB_CFG"
sort --reverse --version-sort "$TMP_KERNELS" | while read vmlinuz; do
    vmlinuz="${vmlinuz##$BOOT_DIRECTORY/}"
    version="${vmlinuz##$KERNEL_PREFIX}"
    initrd="${INITRD_PREFIX}${version}"

    vmlinuz="$(escape_for_sed "$vmlinuz")"
    version="$(escape_for_sed "$version")"
    initrd="$(escape_for_sed "$initrd")"

    sed -e "s/VERSION/$version/g" \
        -e "s/VMLINUZ/$vmlinuz/g" \
        -e "s/INITRD/$initrd/g" \
        <grub.cfg.menu \
        >>"$TMP_GRUB_CFG"
done
cat grub.cfg.tail >>"$TMP_GRUB_CFG"

for x in "$TMP_GRUB_CFG" "$BOOT_DIRECTORY/$KERNEL_PREFIX"* "$BOOT_DIRECTORY/$INITRD_PREFIX"*; do
    name="$(basename "$x")"

    echo "signing and copying '$x' to '$EFI_DIRECTORY'"
    cp "$x" "$EFI_DIRECTORY"
    rm -f "$EFI_DIRECTORY/$name.sig"
    gpg --default-key "$GPG_KEY" --detach-sign "$EFI_DIRECTORY/$name"
done

rm -r tmp
