# Virtualbox

## erzeugen einer virtuellen Disk auf Basis eines LVM Volumes
wichtig ist dabei, das als Format vmdk gewählt wird. 
```bash
VBoxManage internalcommands createrawvmdk -filename /path/to/file.vmdk -rawdisk /dev/volumegroup/logicalvolume
``` 
