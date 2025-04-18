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

### DMI Decode
<details>
  <summary>dmidecode</summary>
	
```bash
# dmidecode 3.4
Getting SMBIOS data from sysfs.
SMBIOS 3.3.0 present.
Table at 0x000E6CC0.

Handle 0x0000, DMI type 0, 26 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: P7.20
	Release Date: 04/28/2022
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 16 MB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
		UEFI is supported
	BIOS Revision: 5.17

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: To Be Filled By O.E.M.
	Product Name: A320M-ITX
	Version: To Be Filled By O.E.M.
	Serial Number: To Be Filled By O.E.M.
	UUID: ad59a1a8-2873-0000-0000-000000000000
	Wake-up Type: Power Switch
	SKU Number: To Be Filled By O.E.M.
	Family: To Be Filled By O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASRock
	Product Name: A320M-ITX
	Version:                       
	Serial Number:                       
	Asset Tag:                       
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis:                       
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
	Manufacturer: To Be Filled By O.E.M.
	Type: Desktop
	Lock: Not Present
	Version: To Be Filled By O.E.M.
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0
	SKU Number: To Be Filled By O.E.M.

Handle 0x0004, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIE1
	Type: x16 PCI Express
	Current Usage: In Use
	Length: Long
	ID: 17
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:00.0

Handle 0x0005, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIE2_M2_1
	Type: x4 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 18
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:00.0

Handle 0x0006, DMI type 11, 5 bytes
OEM Strings
	String 1: To Be Filled By O.E.M.

Handle 0x0007, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0008, DMI type 40, 14 bytes
Additional Information 1
	Referenced Handle: 0x00a1
	Referenced Offset: 0x01
	String: MORDOR
	Value: 0x00000000

Handle 0x0009, DMI type 44, 9 bytes
Unknown Type
	Header and Data:
		2C 09 09 00 FF FF 01 01 00

Handle 0x000A, DMI type 43, 31 bytes
TPM Device
	Vendor ID: AMD
	Specification Version: 2.0
	Firmware Revision: 3.84
	Description: AMD
	Characteristics:
		Family configurable via platform software support
	OEM-specific Information: 0x00000000

Handle 0x000B, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x000C, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: 128 GB
	Error Information Handle: 0x000B
	Number Of Devices: 2

Handle 0x000D, DMI type 19, 31 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x007FFFFFFFF
	Range Size: 32 GB
	Physical Array Handle: 0x000C
	Partition Width: 2

Handle 0x000E, DMI type 7, 27 bytes
Cache Information
	Socket Designation: L1 - Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x000F, DMI type 7, 27 bytes
Cache Information
	Socket Designation: L2 - Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2 MB
	Maximum Size: 2 MB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0010, DMI type 7, 27 bytes
Cache Information
	Socket Designation: L3 - Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 4 MB
	Maximum Size: 4 MB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0011, DMI type 4, 48 bytes
Processor Information
	Socket Designation: AM4
	Type: Central Processor
	Family: Zen
	Manufacturer: Advanced Micro Devices, Inc.
	ID: 01 0F 86 00 FF FB 8B 17
	Signature: Family 23, Model 96, Stepping 1
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Multi-threading)
	Version: AMD Ryzen 3 PRO 4350G with Radeon Graphics
	Voltage: 1.2 V
	External Clock: 100 MHz
	Max Speed: 4100 MHz
	Current Speed: 3800 MHz
	Status: Populated, Enabled
	Upgrade: Socket AM4
	L1 Cache Handle: 0x000E
	L2 Cache Handle: 0x000F
	L3 Cache Handle: 0x0010
	Serial Number: Unknown
	Asset Tag: Unknown
	Part Number: Unknown
	Core Count: 4
	Core Enabled: 4
	Thread Count: 8
	Characteristics:
		64-bit capable
		Multi-Core
		Hardware Thread
		Execute Protection
		Enhanced Virtualization
		Power/Performance Control

Handle 0x0012, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

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

Handle 0x0014, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x007FFFFFFFF
	Range Size: 32 GB
	Physical Device Handle: 0x0013
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x0015, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

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

Handle 0x0017, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x007FFFFFFFF
	Range Size: 32 GB
	Physical Device Handle: 0x0016
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x0018, DMI type 127, 4 bytes
End Of Table
```

</details>
