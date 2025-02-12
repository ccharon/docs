# Using Quectel EM160GL LTE Modem (1eac:1002) on Gentoo Linux

## Firmware Update for stable operation
the initial firmware was unstable leading to modem crashes every minute. using fwupd, I upgraded the firmware to the latest available

```
EM160R GL von EM160RGLAPR02A07M4G_10.010.10.010 auf
EM160RGLAPR02A07M4G_25.025.25.025 aktualisieren?
Firmware release EM160RGLAPR02A07M4G_25.025.25.025 packaged for LVFS.
• Performance improvements
• Stability improvements
EM160R GL und alle angeschlossenen Geräte sind während der Aktualisterung möglicherweise nicht nutzbar.
Operation durchführen? [Y|n]: y
...
```
The firmware now only crashes when the system enters powersave mode. afer wakeup the modem gets reinitialized and reconnects. so this is "okish" 

## Manually getting the modem up

check if the modem is switched on
```bash
rfkill
nmcli radio
```

query the radio state, should be fcc locked
```bash
mbimcli -p -d /dev/wwan0mbim0 --quectel-query-radio-state

# unlock 
mbimcli -p -d /dev/wwan0mbim0 --quectel-set-radio-state=on

# set the right sim slot (esim, slot 0 was preselected)
mmcli --modem 0 --set-primary-sim-slot=1

# finally enable the modem
mmcli --modem 0 enable
```

now NetworkManager can be used to configure a wwan connection using fenereoc gsm device

## Automatic fcc unlock
ModemManager provides an fcc unlock script for quectel devices which needs to be linked.

```bash
mkdir -p  /etc/ModemManager/fcc-unlock.d
ln -sft /etc/ModemManager/fcc-unlock.d/1eac:1002 /usr/share/ModemManager/fcc-unlock.available.d/1eac
```
activate ModemManager

```bash
systemctl enable --now ModemManager.service
```


## Sources
https://wiki.archlinux.org/title/ThinkPad_mobile_Internet
