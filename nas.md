# Building a NAS

## Hardware

Mainboard: ASRock A320M-ITX MITX So.AM4
CPU: AMD Ryzen 4300GE
Cooler: Noctua NH-L9a-AM4 chromax.black
RAM: 16 GB Samsung ECC SKU M391A2G43BB2-CWE 
SSD: 500GB WD Blue SSD SN570 NVMe PCIe
HDDS: 4x 8TB WD
Power Supply: 560 Watt Fractal Design Ion+ 560P Modular 80+ Platinum
Case: Fractal Design Node 304

## Software

### OS
Debian 11

### Filesystem
root: Debian 11 on ZFS https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Bullseye%20Root%20on%20ZFS.html
data: ZFS ... 2x Mirror or raidz2 over all drives

### Services
Samba Shares Documents, Video, Audio, Transfer
Samba Timemachine

rsync Backups

docker: 
Minecraft Server (Java + Bedrock)
Factorio Server
https://github.com/ccharon/server/tree/main/docker-compose

### Tweaks
Timemachine Samba : https://wiki.samba.org/index.php/Configure_Samba_to_Work_Better_with_Mac_OS_X
https://github.com/ccharon/docs/blob/master/secure-server.md


