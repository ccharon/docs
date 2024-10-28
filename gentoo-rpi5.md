# Random bits for a gentoo raspberry pi5 installation

## make.conf
```
# mtune defaults to mcpu, which might break stuff
COMMON_FLAGS="-mcpu=cortex-a76+crc+crypto -mtune=cortex-a76 -O2 -pipe"
```