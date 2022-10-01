# Samba Config erstellen
Ersatz für Synology

## Shares
smb.conf
```ini
[global]
   workgroup = ACME
   server string = %h (Samba Server)
   map to guest = Bad User
   log file = /var/log/samba/%m
   log level = 1
   server role = standalone server
```


### transfer 
alle dürfen lesen und schreiben, keine Anmeldung nötig

das freigegebene Verzeichnis muss noch mit ```chmod 777 /daten/transfer``` für alle les-/schreibbar gemacht werden 

smb.conf
```ini
[transfer]
   # lesen und schreiben fuer alle nutzer moeglich
   path = /daten/transfer
   read only = no
   guest ok = yes
   guest only = yes
```

### jeder user ein share, nur für den user les/schreibbar
User muss lokal angelegt werden, am besten so das er sich nicht am Rechner einloggen kann. bei passwd und smbpasswd kann man das gleiche passwort eingeben
```bash
 useradd -M -s /sbin/nologin demoUser
 passwd demoUser
 smbpasswd -a demoUser  
 
```

das freigegebene Verzeichnis muss noch mit Rechten versehen werden

```bash

chown demoUser:demoUser /daten/demoUser 
chmod 700 /daten/demoUser

``` 

smb.conf
```ini
[demoUser]
   # lesen und schreiben nur für demoUser
   path = /daten/demoUser
   valid users = demoUser
   browsable = yes
   writable = yes
   read only = no
   create mask = 0600
   directory mask = 0700
   force create mode = 0600
   force directory mode = 0700
```

### timemachine
Backupplatz für Macs

```bash
useradd -M -s /sbin/nologin mcfly
passwd mcfly
smbpasswd -a mcfly
 
chown mcfly:mcfly /daten/timemachine 
chmod 700 /daten/timemachine
```


```ini
[global]
   ...
   vfs objects = fruit streams_xattr
   fruit:metadata = stream
   fruit:model = MacSamba
   fruit:posix_rename = yes
   fruit:veto_appledouble = no
   fruit:nfs_aces = no
   fruit:wipe_intentionally_left_blank_rfork = yes
   fruit:delete_empty_adfiles = yes

[timemachine]
   comment = Time Machine Backups
   path = /daten/timemachine
   valid users = mcfly
   browsable = yes
   writable = yes
   read only = no
   create mask = 0600
   directory mask = 0700
   force create mode = 0600
   force directory mode = 0700
   fruit:aapl = yes
   fruit:time machine = yes
   fruit:time machine max size = 2T
```

ausserdem muss man noch avahi installieren und dann unter /etc/avahi/services/timemachine.service hinterlegen

timemachine.service
```xml
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_smb._tcp</type>
    <port>445</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>9</port>
    <txt-record>model=TimeCapsule8,119</txt-record>
  </service>
  <service>
    <type>_adisk._tcp</type>
    <port>9</port>
    <txt-record>dk0=adVN=timemachine,adVF=0x82</txt-record>
    <txt-record>sys=adVF=0x100</txt-record>
  </service>
</service-group>

```

### gemeinsame freigabe

eine gruppe greift auf ein share zu ... demoGroup

Gruppe muss lokal angelegt werden und Benutzer müssen in die Gruppe

```bash
 groupadd demoGroup
 usermod -aG demoGroup demoUser1
 usermod -aG demoGroup demoUser2
 usermod -aG demoGroup demoUser3
 
```

das freigegebene Verzeichnis muss noch mit Rechten versehen werden

```bash
chown nobody:demoGroup /daten/demoGroup
# das sgid bid 2 ist wichtig damit die Gruppe vom Elternverzeichnis für neue Objekte genutzt wird und nicht die Defaultgruppe der User
chmod 2770 /daten/demoGroup
``` 

smb.conf
```ini
[demoGroup]
   # lesen und schreiben nur für demoUser
   path = /daten/demoGroup
   valid users = @demoGroup
   invalid users = demoUser3
   browsable = yes
   writable = yes
   read only = no
   create mask = 0660
   directory mask = 0770
   force create mode = 0660
   force directory mode = 0770
```
