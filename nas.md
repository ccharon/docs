# Building a NAS

## Hardware

- Mainboard: ASRock A320M-ITX MITX So.AM4
- CPU: AMD Ryzen 4350G
- Cooler: Noctua NH-L9a-AM4 chromax.black
- RAM: 2x 16 GB Samsung ECC SKU M391A2G43BB2-CWE 
- SSD: 500GB WD Blue SSD SN570 NVMe PCIe
- HDDS: 6x 4TB WD40EFRX 
- Power Supply: 560 Watt Fractal Design Ion+ 560P Modular 80+ Platinum
- Case: Fractal Design Node 304

## Software

### OS
Gentoo

### Filesystem
system: ZFS, boot with unified kernel
https://github.com/ccharon/gentoo/blob/main/movetozfs.md

data: ZFS ... raidz2 over all drives

### Monitoring
https://github.com/ccharon/docs/blob/master/smartd.md

### Services
Samba: 
Samba Shares Documents, Video, Audio, Transfer
Samba Timemachine
https://github.com/ccharon/docs/blob/master/samba.md


rsync Backups

docker: 
Minecraft Server (Java + Bedrock)
Factorio Server
https://github.com/ccharon/server/tree/main/docker-compose

### Tweaks


