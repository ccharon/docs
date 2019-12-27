# Virtualbox

## erzeugen einer virtuellen Disk auf Basis eines LVM Volumes
wichtig ist dabei, das als Format vmdk gewählt wird. 
```bash
VBoxManage internalcommands createrawvmdk -filename /path/to/file.vmdk -rawdisk /dev/volumegroup/logicalvolume
``` 
Der User der die VM startet muss zumindest unter debian in der Gruppe disk sein 
```bash
# ist es der eingeloggte User muss er sich erst aus und wieder einloggen damit die Gruppenzuordnung aktiv ist
usermod -a -G disk virtualboxuser
```

