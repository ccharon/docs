# Smart einrichten mit Tests und Mail falls was schiefgeht
der smartd daemon läuft als root

## smartd installieren
```bash
emerge --ask sys-apps/smartmontools
```

## smart config einrichten

/etc/smartd.conf
```
# Configuration file for smartd.  See man smartd.conf.

# -a                        monitor all attributes
# -o on                     enable automatic online data collection
# -S on                     enable automatic attribute autosave
# -d sat                    driver sat(a)
# -m me@mail.com            in case of error send mail to
# (not used) -n standby,q   do not check if
# -W 5,45,50                warn if temp jumps by 5, report if >=50
# -s                        schedule selftests
# S/../(01|15)/./02         short test every 1. and 15. of any month starting at 02 am
# L/(01|04|07|10)/03/./02   long test every 3 month starting at the 3. day of the month at 02 am

# os
/dev/disk/by-id/nvme-WD_Blue_SN570_500GB_XXXXXXXXXXX0 -a -o on -S on -d nvme -m receipient@mailbox.org -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)

# data storage
/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-XXXXXXXXXXX1 -a -o on -S on -d sat -m receipient@mailbox.org -W 5,45,50 -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)
/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-XXXXXXXXXXX2 -a -o on -S on -d sat -m receipient@mailbox.org -W 5,45,50 -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)
/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-XXXXXXXXXXX3 -a -o on -S on -d sat -m receipient@mailbox.org -W 5,45,50 -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)
/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-XXXXXXXXXXX4 -a -o on -S on -d sat -m receipient@mailbox.org -W 5,45,50 -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)
/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-XXXXXXXXXXX5 -a -o on -S on -d sat -m receipient@mailbox.org -W 5,45,50 -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)
/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-XXXXXXXXXXX6 -a -o on -S on -d sat -m receipient@mailbox.org -W 5,45,50 -s (S/../(01|15)/./02|L/(01|04|07|10)/03/./02)

```

jetzt kann man den smartd daemon durchstarten und es sollte tun.

## für mailversand muss man noch weiteres machen
```bash
emerge --ask mail-mta/msmtp 
```
weil die mail als root versendet werden im /root Verzeichnis 2 Dateien angelegt

/root/.msmtprc
```
defaults
auth on
tls  on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile /var/log/msmtp.log

# nas (mailbox.org) configuration
account nas
auth    on
tls_starttls off
host    smtp.mailbox.org
port    465
from    meinnas@mailbox.org
user    account@mailbox.org
password password
account default: nas
```

dann noch dafür sorgen das nicht jeder die Datei lesen kann 
```bash
chmod 600 /root/.msmtprc
```

/root/.mailrc
```
set sendmail="/usr/bin/msmtp -t"
```

## testen des geraffels
```bash
# testen ob mailversand geht
echo "Test E-Mail Body" | mail -s "Mein Betreff" receipient@mailbox.org
```

## testen ob es mit smartd geht
dafür an eine der Zeilen mit den Platten ```-M test ``` dahinterschreiben und smartd neustarten dann bekommt man eine Testmail
