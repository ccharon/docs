# Building a NAS

## Hardware

- Mainboard: ASRock A320M-ITX MITX So.AM4
- CPU: AMD Ryzen 4350G
- Cooler: Noctua NH-L9a-AM4 chromax.black
- RAM: 2x 16 GB Samsung ECC SKU M391A2G43BB2-CWE 
- SSD: 500GB WD Blue SSD SN570 NVMe PCIe
- HDDS: 6x 4TB WD40EFRX 
- Power Supply: 560 Watt Fractal Design Ion+ 560P Modular 80+ Platinum
- Case: Fractal Design Node 304

The combination of CPU + Mainboard + RAM allows Multi-bit ECC yay! 

<details>
  <summary>Memory Info</summary>
  
  ```bash
  # dmidecode -t memory
# dmidecode 3.4
Getting SMBIOS data from sysfs.
SMBIOS 3.3.0 present.

Handle 0x000C, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: 128 GB
	Error Information Handle: 0x000B
	Number Of Devices: 2

Handle 0x0013, DMI type 17, 92 bytes
Memory Device
	Array Handle: 0x000C
	Error Information Handle: 0x0012
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 16 GB
	Form Factor: DIMM
	Set: None
	Locator: DIMM 0
	Bank Locator: P0 CHANNEL A
	Type: DDR4
	Type Detail: Synchronous Unbuffered (Unregistered)
	Speed: 3200 MT/s
	Manufacturer: Samsung
	Serial Number: 034EF530
	Asset Tag: Not Specified
	Part Number: M391A2G43BB2-CWE    
	Rank: 1
	Configured Memory Speed: 3200 MT/s
	Minimum Voltage: 1.2 V
	Maximum Voltage: 1.2 V
	Configured Voltage: 1.2 V
	Memory Technology: DRAM
	Memory Operating Mode Capability: Volatile memory
	Firmware Version: Unknown
	Module Manufacturer ID: Bank 1, Hex 0xCE
	Module Product ID: Unknown
	Memory Subsystem Controller Manufacturer ID: Unknown
	Memory Subsystem Controller Product ID: Unknown
	Non-Volatile Size: None
	Volatile Size: 16 GB
	Cache Size: None
	Logical Size: None

Handle 0x0016, DMI type 17, 92 bytes
Memory Device
	Array Handle: 0x000C
	Error Information Handle: 0x0015
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 16 GB
	Form Factor: DIMM
	Set: None
	Locator: DIMM 0
	Bank Locator: P0 CHANNEL B
	Type: DDR4
	Type Detail: Synchronous Unbuffered (Unregistered)
	Speed: 3200 MT/s
	Manufacturer: Samsung
	Serial Number: 030D142C
	Asset Tag: Not Specified
	Part Number: M391A2G43BB2-CWE    
	Rank: 1
	Configured Memory Speed: 3200 MT/s
	Minimum Voltage: 1.2 V
	Maximum Voltage: 1.2 V
	Configured Voltage: 1.2 V
	Memory Technology: DRAM
	Memory Operating Mode Capability: Volatile memory
	Firmware Version: Unknown
	Module Manufacturer ID: Bank 1, Hex 0xCE
	Module Product ID: Unknown
	Memory Subsystem Controller Manufacturer ID: Unknown
	Memory Subsystem Controller Product ID: Unknown
	Non-Volatile Size: None
	Volatile Size: 16 GB
	Cache Size: None
	Logical Size: None
  ```
</details>


## Software

### OS
Gentoo

### Filesystem
system: ZFS, boot with unified kernel
https://github.com/ccharon/gentoo/blob/main/movetozfs.md

data: ZFS ... raidz2 over all drives

### Monitoring
https://github.com/ccharon/docs/blob/master/smartd.md

### Services
Samba: 
Samba Shares Documents, Video, Audio, Transfer
Samba Timemachine
https://github.com/ccharon/docs/blob/master/samba.md


rsync Backups

docker: 
Minecraft Server (Java + Bedrock)
Factorio Server
https://github.com/ccharon/server/tree/main/docker-compose

### Tweaks


