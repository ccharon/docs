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
