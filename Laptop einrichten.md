# Laptop einrichten (DELL Precision 7520)
alle Einstellungen die ich angepasst habe um meinen Laptop einzurichten

## BIOS Einstellungen
### Einnerung für später 
 - Boot Sequenz anpassen
 - Bios Passwort setzen
 - USB Boot Support!

### System Configuration
#### Integrated NIC
 - "Enable UEFI Network Stack" -> haken raus. firmware soll nicht ins netz
 - Option "Enabled w/PXE" auf "Enabled" umstellen. LAN ja, booten per LAN nein
#### Parallel Port
 - Disabled setzen (nur für alte Docking Station relevant)
#### Serial Port
 - Disabled setzen (nur für alte Docking Station relevant)
#### SATA Operation
 - Check ob AHCI, wenn nicht gesetzt, dann auswählen
#### Drives
 - Alles deaktivieren ausser SATA0 (vorher checken wenn eine m2 ssd drin ist dann die aktiv lassen :))
#### USB Configuration
 - Check ob "Enable USB Boot Support" an ist (für Setup wichtig, später deaktivieren)
 - Check ob "Enable External USB Port" an ist, sonst hat man kein USBC 
#### Dell Type-C Dock Configuration
 - Check ob "Always Allow Dell Docks" deaktiviert ist, wenn nicht, dann deaktivieren
#### Thunderbolt Adapter Configuration
 - Hier alles aus, sicherer und wenn man kein Thunderbolt Gerät hat bringt es eh nix
#### USB Powershare
 - wie man mag. ich machs aus, gibt keinen Strom wenn das Laptop aus ist

### Video
#### Switchable Graphics
 - "Enable Switchable Graphics" aktivieren ... Ubuntu sollte dann umschalten können

### Security
 - Passwörter setzen (später)
#### Strong Passwort
 - "Enable Strong Password" aktivieren
 -
#### Secure Boot Enable
 - auf enabled setzen. Secureboot ist doof, zwingt aber den Linux Kernel in einen Lockdown Mode, so können nurnoch signierte Kernel Module geladen werden. Zur Laufzeit nützlich

### POST Behavior
#### Adapter Warnings
  - auf "Enabled" ... Info wenn das Netzteil zu schwachbrüstig ist
### Wireless
#### Wireless Device Enable
  - Bluetooth aktivieren
  -

Dann Apply und "Save as Custom User Settings" einen Haken rein
