# NUXT 2.0

## Hardware

### NUXT 2.0

### Soundcard

### Network

### EMS

## Ressource Assignments

### IRQ
Integrated XT-IDE and EMS Card do not require an IRQ

| IRQ | DEVICE                 |
|-----|------------------------|
| 0   | System Timer           |
| 1   | Keyboard Controller    |
| 2   | Network Card           |
| 3   | Serial Port 2 (COM2)   |
| 4   | Serial Port 1 (COM1)   |
| 5   | Soundblaster 1.5       |
| 6   | Floppy Controller      |
| 7   | Parallel Port 1 (LPT1) |

### DMA
| DMA | DEVICE           |
|-----|------------------|
| 1   | Soundblaster 1.5 |

### Address
| I/O  | DEVICE                      |
|------|-----------------------------|
| 070h | RTC                         |
| 170h | XT-ID                       |
| 200h | Soundblaster 1.5 (Gameport) |
| 220h | Soundblaster 1.5            |
| 260h | EMS Card                    |
| 2F8h | Serial Port 2 (COM2)        |
| 300h | Network Card                |
| 378h | Parallel Port 1 (LPT1)      |
| 3F8h | Serial Port 1 (COM1)        |

### Memory Layout
| Memory Range | Usage                                                                                 |
|--------------|---------------------------------------------------------------------------------------|
| FC00-FFFF    | System BIOS                                                                           |
| F400-FBFF    | 32kb Free Space in ROM                                                                |
| F000-F3FF    | XT IDE BIOS                                                                           |
| E000-EFFF    | 64kb EMS Window (UMB Switch 5, 6 OFF)                                                 |
| D000-DFFF    | 64kb useable as UMB (UMB Switch 3, 4 ON)                                              |
| C800-CFFF    | 32kb useable as UMB (UMB Switch 2 ON)                                                 |
| C000-C7FF    | 32kb EGA/VGA Bios (UMB Switch 1 OFF)                                                  |
| B800-BFFF    | 32kb CGA Video RAM 16kb (the entire 32k is filled with repeats of the first 16k area) |
| B000-B7FF    | 32kb MDA Video RAM  4kb (the entire 32k is filled with repeats of the first  4k area) |
| A000-AFFF    | 64kb EGA Video RAM                                                                    |

NUXT 2.0 is not mapping RAM between A000-BFFF, these areas can not be used for UMB

## Configuration
### NUXT 2.0
#### Hardware switches
For details about other switch positions see the NUXT 2.0 manual.

##### SW1: System Config
| Switch | Setting | Description                                                                        |
|--------|---------|------------------------------------------------------------------------------------|
| 1      | **ON**  | **Enabled for VGA**                                                                |
| 2      | **ON**  | **Enabled for VGA**                                                                |
| 3      | OFF     | Disabled keyboard E0 scancode passthrough for the AT to XT                         |
| 4      | **ON**  | **Enable onboard RAM**                                                             |
| 5      | OFF     | First part of the ROM is used as the NEC V20 has 80186 instructions, faster XT-IDE |
| 6      | **ON**  | **Enable onboard floppy controller**                                               |
| 7      | **ON**  | **Enable onboard ide controller**                                                  |
| 8      | **ON**  | **CF-Card ist IDE-Master**                                                         |


##### SW2: Upper Memory Blocks Config
RAM can be mapped in 32kb chunks to the following locations

| Switch | Setting | Description                                  |
|--------|---------|----------------------------------------------|
| 1      | OFF     | C0000-C8000 (VGA BIOS uses this memory area) |
| 2      | **ON**  | **C8000-D0000** (used as UMB)                |
| 3      | **ON**  | **D0000-D8000** (used as UMB)                |
| 4      | **ON**  | **D8000-E0000** (used as UMB)                |
| 5      | OFF     | E0000-E8000 (EMS card uses this memory area) |
| 6      | OFF     | E8000-F0000 (EMS card uses this memory area) |

This Configuration creates 96kb of UMB (C8000-DFFFF) useable by USE!UMBS.SYS 

##### SW3: UART Config set to COM1
| Switch | Setting | Description      |
|--------|---------|------------------|
| 1      | **ON**  | **IRQ 4**        |
| 2      | OFF     | IRQ 3            |
| 3      | **ON**  | **address 3F8h** |
| 4      | OFF     | address 2F8h     |
| 5      | OFF     | address 3E8h     |
| 6      | OFF     | address 2E8h     |

##### SW4: UART Config set to COM2 (PS/2 Mouse Port connected to this)
| Switch | Setting | Description      |
|--------|---------|------------------|
| 1      | OFF     | IRQ 4            |
| 2      | **ON**  | **IRQ 3**        |
| 3      | OFF     | address 3F8h     |
| 4      | **ON**  | **address 2F8h** |
| 5      | OFF     | address 3E8h     |
| 6      | OFF     | address 2E8h     |

##### SW5: Parallel Port Config
| Switch | Setting | Description      |
|--------|---------|------------------|
| 1      | **ON**  | **IRQ 7**        |
| 2      | OFF     | IRQ 5            |
| 3      | **ON**  | **address 378h** |
| 4      | OFF     | address 278h     |

#### BIOS
to enter the BIOS Setup, press F1 then Esc during the RAM test or Video BIOS splash.
1. 'C' 9 Set Startup Speed to 9.55 Mhz
2. 'F' 4 Set first Floppy to 1.44M 3 1/2"
3. 'D' set RTC time

### MS-DOS 6.22
#### AUTOEXEC.BAT
```
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\UTILS\NC;C:\UTILS\CHECKIT;C:\UTILS\IMGDSK;C:\WINDOWS
SET TEMP=C:\TEMP
SET TMP=C:\TEMP
```

#### CONFIG.SYS
```
FILES=30
BUFFERS=20
REM No HIGH memory on PC XT, but this triggers DOSMAX
DOS=UMB,HIGH

REM For USE!UMBS E000 is expanded to E0000 then -1, so C8000-DFFFF is used
DEVICE=C:\UTILS\USE!UMBS\USE!UMBS.SYS C800-E000

DEVICEHIGH=C:\UTILS\LTEMM\LTEMM.EXE /p:E000 /i:260
DEVICEHIGH=C:\UTILS\DOSMAX\DOSMAX.EXE /R+ /N+ /P-
DEVICEHIGH=C:\DOS\SETVER.EXE
SHELL=C:\UTILS\DOSMAX\SHELLMAX.COM C:\COMMAND.COM C:\ /E:256 /P
```
