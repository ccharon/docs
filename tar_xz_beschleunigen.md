# Tar packt mit xz im Normalfall single threaded das ist doof

## setzen von XZ default Options die dann beim Tar Befehl berücksichtigt werden

--threads=0 sorgt dafür das alle verfügbaren Kerne genutzt werden, sofern der reservierte RAM reicht.

```bash
export XZ_DEFAULTS="--threads 0"
``` 

wenn man evtl. noch das kompressionslevel erhöht ( -9) dann muss man mehr ram erlauben. bei 20 threads und level 9 wollte xz 24GB RAM zum packen (entpacken 64MB)
evtl. wäre dann sowas nett: 

```bash
export XZ_DEFAULTS="-9 --threads=20 --memlimit=32000M"
``` 


## packen mit tar sieht dann so aus

beim packen werden alle Gruppen und Rechte gesichert
```bash
tar --acls --xattrs -cpvJf verzeichnis.tar.xz verzeichnis/*

``` 

## entpacken mit erhalten von allen Rechten usw. (auch falls ein User nicht existiert, beim Wiederherstellen oft nützlich)
```bash
tar -xpvJf verzeichis.tar.xz --acls --xattrs -xpzf --xattrs-include='*.*' --numeric-owner
```

## laufendes gentoo root einpacken

excludes.txt mit diesem inhalt anlegen
```
# Dateisystem spezifisch. nicht sichern
lost+found

# Systemverzeichnisse die zur Laufzeit mit Inhalten gefuellt werden
/dev/*
/proc/*
/run/*
/sys/*
/var/lock/*
/var/run/*

# Temp Verzeichnisse
/var/tmp/*
/tmp/*

# Home, extra Backup
/home/*

# Virtuelle Maschinen Images, extra Backup
/var/lib/libvirt/images/*

# heruntergeladene Source Archive
/var/cache/distfiles/*

# alte gepackte logs
/var/log/*.gz

# Zielverzeichnis, weder Verzeichnis noch Inhalte sichern
/backup/

# Sonst gibt es einen Fehler, "Datei hat sich während des Lesens geändert"
/root/.bash_history
```

jetzt kann komprimiert werden
```bash
tar --exclude-from=/backup/excludes.txt --acls --xattrs -cpvJf /backup/root-$(date +"%Y%m%d%H%M%S").tar.xz /
``` 


