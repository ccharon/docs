# Use your OEM Windows License embedded into your PC for a QEMU Windows VM
you need a OEM PC, like in this case from Dell. ... and of course Linux :P
create a new machine and add this to your domain.xml (replace first line to add qemu namespace) add xml replacing the </devices> line.

```xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
	<!-- ... -->
	</devices>
	<qemu:commandline>
		<!-- as root: cat /sys/firmware/acpi/tables/SLIC > /usr/share/seabios/SLIC.bin -->
		<qemu:arg value='-acpitable'/>
		<qemu:arg value='file=/usr/share/seabios/SLIC.bin'/>
		
		<!-- as root: cat /sys/firmware/acpi/tables/MSDM > /usr/share/seabios/MSDM.bin -->
		<qemu:arg value='-acpitable'/>
		<qemu:arg value='file=/usr/share/seabios/MSDM.bin'/>
		
		<!-- dmidecode -t 0 -->
		<qemu:arg value="-smbios"/>
		<qemu:arg value="type=0,vendor='Dell Inc.',version='1.31.0',date='09/12/2023',release=1.31"/>
		
		<!-- dmidecode -t 1 -->
		<qemu:arg value="-smbios"/>
		<qemu:arg value="type=1,manufacturer='Dell Inc.',product='XXXXXXXX',serial=XXXXXXXX,uuid=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX,sku=XXXXXX,family=XXXXXXXX"/>
    	</qemu:commandline>
</domain>
```

the SLIC.bin contains the license information and the MSDM.bin contains your OEM product key. SMBIOS Information is required so the OEM Key matches the manufacurer, serial number and uuid of the machine


after that install windows 11, when asked for a key choose "I do not have a key" and continue, then select the Windows Edition corresponding to your PCs License.
