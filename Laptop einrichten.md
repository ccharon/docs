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
 - Alles deaktivieren ausser SATA3 (vorher checken wenn eine m2 pcie ssd drin ist dann die aktiv lassen :))
SATA3 scheint das Device wenn Es eine SATA SSD im M2 Slot ist.
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


## Festplatte manuell einrichten
Booten .. z.B.: Ubuntu LTS 20.04 ... F12 drücken und Boot Device auswählen

checken welche platte die interne ist ... bei mir war es sda (beim Boot von externer Platte kann es auch anders sein) 
meine interne SSD ist eine Sandisk X400 
ACHTUNG: hier gehen alle Daten flöten, also im Zweifelsfall nochmal die eben erstellten tar Dateien checken

(500gb ssd die ein bisschen freien platz behält)
```bash
parted --script /dev/sda "mklabel gpt"

# 512MB EFI Partition
parted --script /dev/sda "mkpart primary fat32 1MiB 513MiB"
parted --script /dev/sda "set 1 esp on"

# 1024MB boot Partition
parted --script /dev/sda "mkpart primary ext4 513MiB 1537MiB"

# der Rest wird Luks
parted --script /dev/sda "mkpart primary ext4 1537MiB 394753MiB"

```


