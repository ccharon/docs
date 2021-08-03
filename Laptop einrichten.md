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
BOOT zu verschlüsseln .. da glaub ich nicht dran. der Rest wird mit LUKs verschlüsselt und dann wird auf dem Luks Volume ein LVM erstellt damit wir "Partitionen" (logical volumes) unterbekommen und die bekommen dann ein Dateisystem. Ich hab mich für BTRFS entschieden weil man dann super Subvolumes trennen kann ohne vorher eine starre Aufteilung des Plattenplatzes zu machen. Wie man mit BTRFS umgeht wird hier nicht erklärt

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
           |   |
           |   ├── @ (brfs subvolume /)
           |   |  
           |   ├── @home (brfs subvolume /home)
           |   |
           |   ├── @snapshots-root (brfs subvolume /.snapshots) 
           |   |
           |   └── @snapshots-home (brfs subvolume /home/.snapshots)          
           |   
           └── swap (swap)
```

Booten .. z.B.: Ubuntu LTS 20.04 ... F12 drücken und Boot Device auswählen

checken welche platte die interne ist ... bei mir war es sda (beim Boot von externer Platte kann es auch anders sein) 
meine interne SSD ist eine Sandisk X400 
ACHTUNG: es gehen alle evtl. vorhandenen Daten auf der Festplatte verloren

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

# mit luks die lvm partition verschlüsseln ..itertime gern höher wenn cpu schneller :)
cryptsetup -y -v luksFormat /dev/sda3 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --iter-time 10000

# verschlüsselte partition zum formatieren öffnen (die findet man dann unter /dev/mapper/luks-<uuid der partition>)
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

``` 

## Betriebssystem Setup starten (nicht neustarten, ist doch gerade alles so schön gemounted)
Ubuntu hat eine Verknüpfung zum Installer auf dem Desktop

Anwerfen und durchklicken bis "aktualisieren und andere Software"

### Aktualisieren und andere Software
- Minimale Installation (Weniger Schrott zum löschen nachher)
- Aktualisierungen runterladen
- "Installieren Sie Software von Drittanbiet...", anschalten. Dann wird man gefragt ob man Secureboot konfigurieren will. Das will man.
  Das Passwort das hier gefragt wird muss nicht ganz schrecklick kompliziert sein. Es wird lediglich benutzt um den MOK (Machine Owner Key) zu installieren.
  Dieser Key wird generiert und dann beim ersten Neustart (hier braucht man das Passwort) durch .. ich glaube SHIM mit auf die Liste der erlaubten Keys gesetzt. Beim Installieren von Kernel Modulen aus Paketen (zb. vom Nvidia Treiber oder Virtualbox wird dieser Key dann genutzt um die Kernel Module zu signieren. 

Wenn alles angegeben dann auf weiter (Geduld, kann ein wenig dauern)

### Festplatte einrichten
Hier "Etwas Anderes" auswählen und weiter
auf diesem Bildschirm sucht man jetzt die sorgfältig angelegten Partitionen etc.
- ```/dev/sda1``` -> auswählen, und unten ändern anklicken. Der Formatieren Haken sollte aus sein und Benutzen als ```EFI Partition``` ausgewählt -> OK
- ```/dev/sda2``` -> auswählen, und unten ändern anklicken. Der Formatieren Haken sollte aus sein und Benutzen als ```EXT4-Journaling-Dateisystem``` auswählen, Einbindungspunkt auf ```/boot``` setzen -> OK
- ```/dev/mapper/notebook-swap``` -> auswählen, und unten ändern anklicken. Der Formatieren Haken sollte aus sein und Benutzen als ```Auslagerungsspeicher (SWAP)``` ausgewählt -> OK
- ```/dev/mapper/notebook-system``` -> auswählen, und unten ändern anklicken. Der Formatieren Haken sollte aus sein und Benutzen als ```BTRFS-Journaling-Dateisystem``` auswählen, Einbindungspunkt auf ```/``` setzen -> OK

Das war es auch schon, das interessante ist, Ubuntu regelt das ganze Geraffel mit Luks (Frage nach Passwort) + LVM + BTRFS dann jetzt von selbst.
auf "jetzt installieren" klicken .. und die Warnungen wegen nicht formatieren und wegen formatieren weiterklicken.

### Wer sind sie
- hier ist wichtig ein ordentliches Passwort zu vergeben und "Passwort zum Anmelden abfragen" muss an sein

jetzt sollte die Installation endlich losgehn
Wenn alles durch ist .."Jetzt neu starten" (Daumen drücken :))

jetzt kommt ein feiner blauer bildschirm ... dort die Option "Enroll MOK" auswählen
Continue -> yes -> passwort das während der Installation für Secureboot konfigurieren vergeben wurde -> reboot


### Fehler die man so macht.
vergessen die crypttab zu aktualisieren, dann landet man in busybox

aber noch ist nicht aller Tage Abend.
erst mit ```blkid /dev/sda3``` die UUID der Platte rausfinden, die erste UUID ist die Richtige

dann ```cryptsetup luksOpen /dev/sda3 luks-<UUID von oben ohne Anführungszeichen>``` 

dann ```exit``` und der Rechner bootet :)


nach dem Boot, den ganzen Ubuntu Schrott verneinen und bloss keine Snaps installieren

dann einen Terminal auf und folgende Befehle als root ausführen, dann weiss Ubuntu beim Booten wie es an das Luks Device kommt
```bash
echo "luks-`blkid -s UUID -o value /dev/sda3` UUID=\"`blkid -s UUID -o value /dev/sda3`\" none luks,discard" >> /etc/crypttab

# danach noch das initramfs neu erzeugen.
update-initramfs -c -k all
```
jetzt sollte beim Boot alles wunderbar klappen, restart!

## im Betriebssystem
### erstmal alles aktualisieren
als root
```bash
apt update
apt dist-upgrade

```
### snaps killen (wieder als root)
```bash
# existierende snaps angucken und dann weghauen
snap list

# installierte snaps deinstallieren (können auch mehr sein)
snap remove snap-store
snap remove gtk-common-themes
snap remove gnome-3-34-1804
snap remove core18
snap remove snapd

# alles weg? wenn ja dann weiter, wenn nicht dann noch snap remove
snap list

# ggf. noch was gemounted? wenn nicht dann nicht
sudo umount /snap/core/xxxx

# jetzt snap endlich weg
sudo apt purge snapd

# allen Müll noch entfernen
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
```

#### neuinstallation von snapd unterbinden
Ubuntu versucht bei ganz normalen Paket Installationen (zb. chromium) das Snap Zeug wieder zu installieren. Damit man das merkt (Install schlägt fehl) folgende Konfiguration.
```
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
# To prevent repository packages from triggering the installation of Snap,
# this file forbids snapd from being installed by APT.
# For more information: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html

Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
```

### Firewall aktivieren
```bash 
# damit sind die lokalen Ports dicht. Vorsicht Docker wurschtelt sich an der Firewall vorbei. Besser nur ports auf lokalhost legen.
ufw enable
```
### Proprietärer NVIDIA Treiber (optional)
in der Anwendung für zusätzliche Treiber den NVIDIA Treiber (proprietär, tested) auswählen und installieren lassen.
jetzt noch das laden den Open Source Treibers verhindern.
```bash
cat <<EOF | sudo tee /etc/modprobe.d/nvidia.conf
# nouveau treiber deaktivieren
blacklist nouveau
blacklist lbm-nouveau
alias nouveau off
alias lbm-nouveau off
options nouveau modeset=0

# modeset 1 um screen tearing zu verhindern
options nvidia-drm modeset=1
EOF


update-initramfs -u
```

### Anwendungen installieren
#### VSCode
https://code.visualstudio.com/download
.deb runterladen und dann mit apt-get install das runtergeladene .deb installieren ``` apt-get install /home/user/Download/code.deb``` Pfad und Namen anpassen wichtig, es ist ein absoluter Pfad notwendig. Die Installation installiert auch ein APT Repo, d.h. VSCode bleibt automatisch aktuell.

#### Jetbrains Toolbox
https://www.jetbrains.com/de-de/toolbox-app/
runterladen und entpacken. dann einmal ausführen ... das ist ein Appimage das sich direkt "einnistet" .. es legt folgendes an:
 - Verknüpfung im Menü: ./.local/share/applications/jetbrains-toolbox.desktop 
 - Kopieren der Toolbox Anwendung nach: ./.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox
 - Autostart Eintrag: ./.config/autostart/jetbrains-toolbox.desktop

naja wers mag .. auf jedenfall ists dann immer an und man kann konfigurieren was man halt so konfiguriert.

#### Citrix Workspace
https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html
 - herunterladen Debian Packages -> Full Packages (Self Service Support) (x86_64)
 - herunterladen USB Support Packages -> USB Support Package (x86_64)

```bash
# installieren, pfad und paketnamen anpassen :)
apt-get install /home/user/Downloads/icaclient_xxx.deb
apt-get install /home/user/Downloads/ctxusb_xxx.deb
``` 
#### Docker
https://docs.docker.com/engine/install/ubuntu/

### BTRFS ... inkrementelle Snapshots (zeitgesteuert und bei System Updates)
mit snapper und ich mag meine Config speziell ... wie immer alles als root
```
# Dateisystem ohne subvolume mounten
mount /dev/mapper/notebook-system /mnt

# Neue Subvolumes
btrfs subvolume create /mnt/@snapshots-root
btrfs subvolume create /mnt/@snapshots-home

# und wieder weg
umount /mnt

# fstab mountpunkte fuer die snapshots hinzufuegen
echo "/dev/mapper/notebook-system   /.snapshots  btrfs   defaults,subvol=@snapshots-root 0        2" >> /etc/fstab
echo "/dev/mapper/notebook-system   /home/.snapshots  btrfs   defaults,subvol=@snapshots-home 0        2" >> /etc/fstab

#snapper installieren und konfigurieren
apt-get install snapper

# root config anlegen
snapper -c root create-config /

# snapper legt ein eigenes .snapshot subvolume an, ich will aber meins nutzen
rm -rf /.snapshots
mkdir /.snapshots
mount /.snapshots

# und das gleiche für home nochmal
snapper -c home create-config /home

# snapper legt ein eigenes .snapshot subvolume an, ich will aber meins nutzen
rm -rf /home/.snapshots
mkdir /home/.snapshots
mount /home/.snapshots

# gucken ob alles geklappt hat. sollte 4 btrfs Subvolumes zeigen immer das eigentliche + das snapshot volume
mount | grep btrfs

# snapshots anschauen. werden stündlich erzeugt, bei root config auch beim boot und beim apt update
snapper -c root list
snapper -c home list

``` 

Weiterführend kann man noch steuern wieviele Snapshots wie lange erhalten bleiben. Dafür unter /etc/snapper/configs/ die Configs gewünscht anpassen
ich mag folgende Config. Die letzten 24h dann einmal pro tag und 4 Wochen für 12 Monate :)
```
TIMELINE_LIMIT_HOURLY="24"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="4"
TIMELINE_LIMIT_MONTHLY="12"
TIMELINE_LIMIT_YEARLY="10"
``` 

Wenn man mal neustartet und mit ```snapper -c root list``` guckt sieht man das snapshots entstehen.


### Optimierungen

#### Laptop geht nach Neustart mit geschlossenem Deckel direkt in den Ruhezustand
... Laptop steckt am Strom, externer Monitor, Tastatur, usw. 

Das verrückte Gerät bekommt in dem Fall ein "lidClosed" Event und denkt es soll direkt Strom sparen.
Das Verhalten bekommt man in den Griff indem man in der Datei ```/etc/systemd/logind.conf``` die Zeile sucht in der ```HandleLidSwitchExternalPower``` steht.
einfach das # wegnehmen und den Eintrag so anpassen das da ```HandleLidSwitchExternalPower=ignore``` steht. Nach einem Neustart schläft das Laptop nichtmehr wenn die Klappe zu ist, solange es am Strom hängt. Unterwegs ists dann immernoch schläfrig.

#### kurzes "hängen" wenn man Anzeigeeinstellungen aufruft
Wenn man den proprietären NVIDIA Treiber installiert hat, dann kann man in den "NVIDIA X Server Settings" unter "PRIME Profiles" auf On-Demand stellen dann gehts weg.

#### strom sparen wenn auf batterie
ganz einfach ... tlp installieren das guckt was man machen kann https://linrunner.de/tlp/

```
apt install tlp 
```
