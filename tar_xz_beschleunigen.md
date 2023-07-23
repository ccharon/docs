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
tar -cJvf verzeichnis.tar.xz verzeichnis/*

``` 

## entpacken mit erhalten von allen Rechten usw. (auch falls ein User nicht existiert, beim Wiederherstellen oft nützlich)
```bash
tar -xJvf verzeichis.tar.xz --xattrs-include='*.*' --numeric-owner
``` 

## laufendes gentoo root einpacken
```bash
cd / && tar -cJv \
--exclude=lost+found \
--exclude=dev/* \
--exclude=proc/* \
--exclude=sys/* \
--exclude=tmp/* \
--exclude=home/* \
--exclude=backup/* \
--exclude=var/tmp/* \
--exclude=var/lock/* \
--exclude=var/run/* \
--exclude=var/lib/libvirt/* \
--exclude=var/cache/distfiles/* \
--exclude=var/log/*.gz \
--exclude=root/.bash_history \
-f /backup/root-$(date +"%Y%m%d%H%m%S").tar.xz *
``` 
