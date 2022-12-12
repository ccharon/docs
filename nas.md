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
  <summary>CPU Info 1 of 8 Cores</summary>
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 23
model		: 96
model name	: AMD Ryzen 3 PRO 4350G with Radeon Graphics
stepping	: 1
microcode	: 0x8600106
cpu MHz		: 1400.000
cache size	: 512 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 16
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate ssbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 cqm rdt_a rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local clzero irperf xsaveerptr rdpru wbnoinvd arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif v_spec_ctrl umip rdpid overflow_recov succor smca
bugs		: sysret_ss_attrs spectre_v1 spectre_v2 spec_store_bypass retbleed
bogomips	: 7603.05
TLB size	: 3072 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]
	
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


