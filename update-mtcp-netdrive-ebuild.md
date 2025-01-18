# mTCP Netdrive Gentoo Ebuild
This Document contains notes for creating a new version of my mtcp netdrive ebuild.

## Downloading sources

https://www.brutman.com/mTCP

https://www.brutman.com/mTCP/download/mTCP_NetDrive_server-src_2025-01-10.zip

## Packaging Dependencies for Ebuild
- Download to mtcp Directory 
- go to mtcp directory
- unzip ```unzip mTCP_NetDrive_server-src_2025-01-10.zip```
- go to netdrive dir ```cd mTCP_NetDrive_server-src_2025-01-10/netdrive```
- download go dependencies ```go mod vendor```
- go back to mtcp directory ```cd ../..```
- compress dependencies ```XZ_OPT=-9e tar --create --auto-compress --file mTCP_NetDrive_server-src_2025-01-10-vendor.tar.xz mTCP_NetDrive_server-src_2025-01-10/netdrive/vendor```
