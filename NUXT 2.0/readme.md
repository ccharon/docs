# NUXT 2.0

## Hardware

### NUXT 2.0

### Soundcard

### Network

### EMS

## Ressource Assignments

### IRQ
Integrated XT-IDE does not require an IRQ. Also the EMS Card does not use an IRQ

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
| 2C0h | Network Card                |
| 2F8h | Serial Port 2 (COM2)        |
| 3F8h | Serial Port 1 (COM1)        |
| 378h | Parallel Port 1 (LPT1)      |


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

## Configuration

## AUTOEXEC.BAT
```
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\UTILS\NC;C:\UTILS\CHECKIT;C:\UTILS\IMGDSK;C:\WINDOWS
SET TEMP=C:\TEMP
SET TMP=C:\TEMP
```

## CONFIG.SYS
```
FILES=30
BUFFERS=20
DOS=UMB,HIGH
DEVICE=C:\UTILS\USE!UMBS\USE!UMBS.SYS C800-DFFF
DEVICEHIGH=C:\UTILS\LTEMM\LTEMM.EXE /p:E000 /i:260
DEVICEHIGH=C:\UTILS\DOSMAX\DOSMAX.EXE /R+ /N+ /P-
DEVICEHIGH=C:\DOS\SETVER.EXE
SHELL=C:\UTILS\DOSMAX\SHELLMAX.COM C:\COMMAND.COM C:\ /E:256 /P
```