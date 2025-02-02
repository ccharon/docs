# hmmm


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
