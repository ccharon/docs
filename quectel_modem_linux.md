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
The firmware now only crashes when the sysyem enters powersave mode. afer wakeup the modem gets reinitialized and reconnects. so this is "okish" 

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
activatw ModemManager

```bash
systemctl enable --now ModemManager.service
```


## Sources
https://wiki.archlinux.org/title/ThinkPad_mobile_Internet



## TODO Cleanup

https://wiki.archlinux.org/title/ThinkPad_mobile_Internet

nmcli radio



  158  systemctl enable --now ModemManager.service 

  160  mbimcli -p -d /dev/wwan0mbim0 --quectel-query-radio-state
  161   mbimcli -p -d /dev/wwan0mbim0 --quectel-set-radio-state=on
  162  mbimcli -p -d /dev/wwan0mbim0 -v --quectel-query-radio-state
  163  mbimcli -p -d /dev/wwan0mbim0 --quectel-query-radio-state
  164  mmcli --modem 0 enable
  165  mmcli --modem 1 enable
  166  lspci -nn

  169  mkdir -p  /etc/ModemManager/fcc-unlock.d 
  170   ln -sft /etc/ModemManager/fcc-unlock.d /usr/share/ModemManager/fcc-unlock.available.d/1eac:1002
  171  rfkill
  173  nmcli radio
  174  mmcli -m 0 -b 1
  175  mmcli --modem 1 enable
  176  mmcli -m 1 --set-primary-sim-slot=0
  177  mmcli -m 1 --set-primary-sim-slot=1
  178  mmcli --modem 1 enable
  179  mmcli --modem 0 enable
  180  mmcli --modem 2 enable
  181  mmcli -m 1 --set-primary-sim-slot=2
  182  rfkill
  183  nmcli radio
  184  nmcli radio
