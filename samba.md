# Samba Config erstellen
Ersatz für Synology

## Shares
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

### timemachine
