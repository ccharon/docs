# Gentoo on Sifive VisionFive2 
Work in progress

## getting anything usefull to boot at all
my device needed a firmware update to be able to boot an debian image which acutally had a proc file system available
to do so i did the following.

1. download necessary files from
(when I did this Version 2.8 was the most recent.)
https://github.com/starfive-tech/VisionFive2/releases/tag/VF2_v2.8.0

the files needed are:

sdcard.img
u-boot-spl.bin.normal.out 
visionfive2_fw_payload.img 

2. copy the sdcard image to an sd card (all previous data gets destroyed)
´´´bash 
dd if=sdcard.img of=/dev/yoursdcarddevice bs=2M status=progress conv=fdatasync
´´´
3. mount the rootfs of the sd card (for me it was the 4. partition)
´´´bash 
mount /dev/yoursdcarddevice4 /mnt
´´´
4. copy the 2 files to the mounted fs 
´´´bash 
mkdir -p /mnt/root/update
cp u-boot-spl.bin.normal.out /mnt/root/update
cp visionfive2_fw_payload.img /mnt/root/update
´´´

5. unmount /mnt

6. put sdcard into visionfive2 and boot

7. after boot login (via serial console, or terminal) user: root, pw: starfive
´´´bash 
cd /root/update
...
´´´





for me the approach of using the build image, putting it on a sd card and then mounting it and adding the two files to update bootloader and firm
