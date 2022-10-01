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

das freigegebene Verzeichnis muss noch mid ```chmod 777 /daten/transfer``` für alle les/schreibbar gemacht werden 

smb.conf
```ini
[transfer]
   # lesen und schreiben fuer alle nutzer moeglich
   path = /daten/transfer
   read only = no
   guest ok = yes
   guest only = yes
```

### timemachine
