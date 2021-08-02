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
Ziel ist es eine verschlüsselte Platte (ausser EFI und BOOT) zu bekommen. EFI geht nicht verschlüsselt, muss ja booten.
BOOT zu verschlüsseln .. da glaub ich nicht dran. der Rest wird mit LUKs verschlüsselt und dann wird auf dem Luks Volume ein LVM erstellt damit wir "Partitionen" (logical volumes) unterbekommen und die bekommen dann ein Dateisystem. Ich hab mich für BTRFS entschieden weil man dann super Subvolumes trennen kann ohne vorher eine starre Aufteilung des Plattenplatzes zu machen.

Ziel ist es dieses Layout anzulegen:

```
GPT
   |
   ├── EFI (fat32)
   |
   ├── boot (ext4)
   |
   └── Luks encrypted
       |   
       └── LVM
           |
           ├── system (btrfs)
           |   
           └── swap (swap)
```

Booten .. z.B.: Ubuntu LTS 20.04 ... F12 drücken und Boot Device auswählen

checken welche platte die interne ist ... bei mir war es sda (beim Boot von externer Platte kann es auch anders sein) 
meine interne SSD ist eine Sandisk X400 
ACHTUNG: hier gehen alle Daten flöten, also im Zweifelsfall nochmal die eben erstellten tar Dateien checken

Alle Befehle als Root ausführen, also vorher einmal ```sudo -i```

(500gb ssd die ein bisschen freien platz behält)
```bash
parted --script /dev/sda "mklabel gpt"

# 512MB EFI Partition
parted --script /dev/sda "mkpart primary fat32 1MiB 513MiB"
parted --script /dev/sda "set 1 esp on"

# 1024MB boot Partition
parted --script /dev/sda "mkpart primary ext4 513MiB 1537MiB"

# der Rest wird Luks (448GB) .. bleiben noch so 27gb platz
parted --script /dev/sda "mkpart primary ext4 1537MiB 460289MiB"

```

### Verschlüsselung und formatieren
```bash
# erst mal die efi partition formatieren
mkfs.fat -F32 -n EFI /dev/sda1

# boot partition formatieren
mkfs.ext4 -L boot -T small /dev/sda2

# mit luks die lvm partition verschluesseln ..itertime gern höher wenn cpu schneller :)
cryptsetup -y -v luksFormat /dev/sda3 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000

# verschluesselte partition zum formatieren öffnen (die findet man dann unter /dev/mapper/luks-<uuid der partition>)
cryptsetup luksOpen /dev/sda3 luks-`blkid -s UUID -o value /dev/sda3`

# LVM Setup
# die Volumegroup "notebook" kann man an den passenden Stellen auch durch etwas Kreativeres ersetzen
pvcreate /dev/mapper/luks-`blkid -s UUID -o value /dev/sda3`
vgcreate notebook /dev/mapper/luks-`blkid -s UUID -o value /dev/sda3`

# geschmackssache, ich mag ein bisschen freien platz im volume und swap ein bisschen größer wegen evtl. suspend to disk.
lvcreate --name system --size 320G notebook
lvcreate --name swap --size 64G notebook

# formatieren des root Dateisystems
mkfs.btrfs -f -L system /dev/notebook/system

# swap formatieren
mkswap /dev/notebook/swap




