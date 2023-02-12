# steps for a working headless rpi setup

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

### set user and password password
for some time now there is no default user + password. this can be configured by creating a file containing user + password to set up

create a file called ```userconf``` with just one line of content
```<username>:<encryptedpassword>```

username can be what ever you like, maybe "dave"

lets assume the password will be "banana", this has to be encoded with openssl
```bash
echo 'banana' | openssl passwd -6 -stdin
```
the output will be something like this:
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

