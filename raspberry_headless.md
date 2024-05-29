# steps for a headless rpi setup

## download an rpi image ..., put in on an sd card
(image name and target device may vary :P)
```bash
dd if=2022-09-22-raspios-bullseye-armhf-lite.img of=/dev/sdd bs=2M status=progress conv=fdatasync
```
## mount the boot partition
if it is not mounted automatically it's something like
```bash
mount /dev/sdd1 /mnt
```

## add necessary files to the mounted fs
(assuming the fs is mounted to /mnt, if not change accordingly)

```bash
cd /mnt
```

### enable ssh
needs an empty file called ssh
```
touch ssh
```

### configure wlan
to configure wlan a file called wpa_supplicant.conf has to be created
content like so:
```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="your_wifi_ssid"
  psk="your_wifi_password"
}
```
change wlan properties + country to your values

### set user and password
for some time now there is no default user + password. this can be configured by creating a file containing user + password to set up

create a file called ```userconf``` with just one line of content
```<username>:<encryptedpassword>```

username can be what ever you like, maybe "dave"

lets assume the password will be "banana", this has to be encoded with openssl
```bash
$ echo 'banana' | openssl passwd -6 -stdin
$6$hJWc4EBwpwBpCNKv$i6ixK2dwjTFnq7QOlXqzaW9RklZfja09/oyPXf3GjU1cut.DKKUkVL0VWMxQ26yVHhkEs/s.JeoY2F/kcHlWs/
```
now add this line to userconf
```
dave:$6$hJWc4EBwpwBpCNKv$i6ixK2dwjTFnq7QOlXqzaW9RklZfja09/oyPXf3GjU1cut.DKKUkVL0VWMxQ26yVHhkEs/s.JeoY2F/kcHlWs/
```

## done
now unmount and put the card into the rpi ... 


# PI Zero Gadget Mode
PI Zero can be get Power, provide Serial Console and Network (and more) via a single USB Cable attached to a PC.

## Adding Overlay 
modify config.txt add this at the end:
```
dtoverlay=dwc2
```

## Modify Kernel Parameters to provide network / serial access
modify cmdline.txt after rootwait add ``` modules-load=dwc2,g_serial ```

(other modules could be g_ether oder g_mass_storage, ...)

The line will look something like this when finished
```
console=serial0,115200 console=tty1 root=PARTUUID=4c4e106f-02 rootfstype=ext4 fsck.repair=yes rootwait modules-load=dwc2,g_serial,g_ether quiet init=/usr/lib/raspberrypi-sys-mods/firstboot
```

## Activating serial Console
```bash
systemctl enable getty@ttyGS0.service
```
