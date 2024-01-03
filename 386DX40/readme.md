# Project 386DX40

## Hardware

| image                                                                                                                                                                                                                                     | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <img src="./images/board.jpeg" alt="mainboard" style="width:500px;"/>                                                                                                                                                                     | The&nbsp;mainboard&nbsp;is&nbsp;a&nbsp;[TK&nbsp;TK-82C491/386-4N-D02C](https://theretroweb.com/motherboards/s/tk-tk-82c491-386-4n-d02c)<br/>which is a clone of an [ABIT AB AK-3](https://theretroweb.com/motherboards/s/abit-ab-ak3)<br/><br/><b>Chipset:</b>&nbsp;UMC&nbsp;UM82C491<br/><b>Socket:</b>&nbsp;PQFP132<br/><b>FSB:</b> 40MHz<br/><b>Cache:</b> 128KB<br/><b>RAM:</b> 8x 1mb 30-pin SIMM<br/><b>Dimensions:</b> Baby AT (170mm x 220mm)<br/><b>Jumper Settings:</b> [mainboard-jumper.pdf](./ressources/mainboard-jumper.pdf)<br/><b>Dimensions:</b> Baby AT (170mm x 220mm)<br/><b>Bios:</b>The latest available AMI Bios [this](./ressources/bios/RA16AMI.BIN). I liked the [AWARD Bios from the Abit AB AK-3](./ressources/bios/ABITAK3-4.BIN) more, so I used it. <br/><br/> Choosing None as Drive C is ok, XTIDE will autodetect the drive<img src="./images/bios1.jpeg" alt="bios1" style="width:500px;"/><img src="./images/bios2.jpeg" alt="bios2" style="width:500px;"/><img src="./images/bios3.jpeg" alt="bios3" style="width:500px;"/> |
| <img src="./images/controller.jpeg" alt="controller" style="width:500px;"/>                                                                                                                                                               | Holtek&nbsp;Microelectronics&nbsp;Inc&nbsp;Multi&nbsp;I/O&nbsp;Card&nbsp;SIO2A. Providing 2 COM Ports + 1 Parallel Port, Floppy Controller IDE Controller                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| <img src="./images/grafik.jpeg" alt="grafik" style="width:500px;"/>                                                                                                                                                                       | the graphics card is a Realtek RTG3106 with 1mb RAM<br/><br/><b>Jumper Settings</b><br/><br/><b>JP1</b> (VGA FEATURE CONNECTOR POWER CONFIGURATION)<br/>M12 & M13 connect to Vcc. (Ground) Closed<br/>M12 & M13 floating (Open) Open<br/><br/><b>JP2</b> (BASE ADDRESS DECODING CONFIGURATION)<br/>Unlatched (Fast) Open<br/>Latched (Slow) Closed<br/><br/><b>JP3</b> (VGA GRAPHICS MODE CONFIGURATION)<br/>Interlaced Open <br/>Non-interlaced Closed<br/><br/><b>JP4</b> (not installed, BUS SIZE DETECTION CONFIGURATION)<br/>Auto detect Closed<br/>8-bit Open<br/><br/><b>JP5</b> (INTERRUPT SELECTION)<br/>2/9 Pins 1 & 2 Closed<br/>7 Pins 2 & 3 Closed<br/>? no interrupt Open ?<br/><br/>VESA 2.0 compliance via [UNIVBE 6.7](./ressources/scitech.7z)                                                                                                                                                                                                                                                                                                  |
| <img src="./images/netzwerk.jpeg" alt="netzwerk" style="width:500px;"/>                                                                                                                                                                   | Set to Interrupt 10 Address 300 via [3com EtherDisk](./ressources/3Com%20EtherDisk%20v5.0.img). Installing and activating a XTIDE Boot ROM allows to use Harddisks (CF-Cards) larger than 512mb)<br/><img src="./images/3comsettings.jpeg" alt="3comsettings" style="width:500px;"/>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| <img src="./images/sound.jpeg" alt="sound" style="width:500px;"/>                                                                                                                                                                         | SET BLASTER=A220 I5 D1 H3 T4 <br/>C:\UNISOUND\UNISOUND.COM /VC80 /VL80 /VF60<br/><br/>[Unisound 0.80a](./ressources/UNISOUND080a.zip)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| <img src="./images/cf-karte.jpeg" alt="cf-karte" style="width:500px;"/> <br/> <img src="./images/cf-adapter.jpeg" alt="cf-adapter" style="width:500px;"/> <br/> <img src="./images/kabel-hdd.jpeg" alt="kabel-hdd" style="width:500px;"/> | BIOS Settings for cf card (autodetected by different pc bios)<br/>cylinders: 987<br/>heads 16<br/>sectors 63<br/>precomp 65535<br/>lzone 986                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| <img src="./images/diskette1.jpeg" alt="diskette1" style="width:500px;"/> <br/> <img src="./images/diskette2.jpeg" alt="diskette2" style="width:500px;"/> <br/> <img src="./images/kabel-fdd.jpeg" alt="kabel-fdd" style="width:500px;"/> |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| <img src="./images/gehaeuse.jpeg" alt="gehaeuse" style="width:500px;"/>                                                                                                                                                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |


## Interrupts, I/O, DMA
as this is not a plug and play system this is to keep track
### Interrupts
| IRQ | usage                                |
|----:|--------------------------------------|
|   0 | Timer                                |
|   1 | Keyboard                             |
|   2 | Connects to IRQ 9                    |
|   3 | COM2                                 |
|   4 | COM1                                 |
|   5 | Orpheus I (SB Pro) via unisound      |
|   6 | Floppy                               |
|   7 | LPT1                                 |
|   8 | Real-time clock                      |
|   9 | Orpheus I (MPU) via unisound         |
|  10 | 3COM network card via config program |
|  11 |                                      |
|  12 |                                      |
|  13 | Math coprocessor                     |
|  14 | IDE Controller                       |
|  15 |                                      |

### I/O
| I/O Address | Usage                  |
|-------------|------------------------|
| 1F0h        | Primary IDE interface  |
| 200h        | Orpheus I (JOY)        |
| 220h        | Orpheus I (ADD SB Pro) |
| 2F8h        | COM2 with IRQ3         |
| 300h        | 3Com network adapter   |
| 330h        | Orpheus I (MPU)        |
| 378h        | LPT1 with IRQ7         |
| 388h        | Orpheus I (OPL)        |
| 3F8h        | COM1 with IRQ4         |
| 534h        | Orpheus I (WSS)        | 

### DMA
| DMA | Usage              |
|-----|--------------------|
| 1   | Orpheus I (SB Pro) |
| 3   | Orpheus I (WSS)    | 

## System setup
after everything is assembled stuff gets installed via 3.5" floppy disks, creating real disks from images can be performed by another old pc or by using some specialized hardware like a [Greaseweazle](https://github.com/keirf/greaseweazle)

### Operating System MS DOS 6.22
https://winworldpc.com/product/ms-dos/622

### config.sys
```
SWITCHES=/F

REM disk change signal for drive a not working. Cause might be usage of a
REM cf-card connected to the ISA IDE controller, for this reason the drive(D:0)
REM is configured explicitly and without the option C. If this configuration is
REM omitted programs like dir show old content after swapping a disk. 
DRIVPARM=/D:0 /F:7

[MENU]
MENUITEM=DEFAULT, Normaler Start 
MENUITEM=DEFAULTEMS, + EMS
MENUITEM=NETWORK,    + Netzwerk 
MENUITEM=NETWORKEMS, + EMS und Netzwerk 
MENUITEM=MINIMUM, Nur HIMEM.SYS, Tastatur und Maus
MENUDEFAULT=DEFAULT,3
MENUCOLOR=7,0

[DEFAULT]
DOS=HIGH,UMB
DEVICE=C:\DRV\DOSMAX\DOSMAX.EXE /C+ /P- /R-
DEVICE=C:\DOS\HIMEM.SYS /TESTMEM:OFF
DEVICE=C:\DOS\EMM386.EXE NOEMS I=B000-B7FF

INCLUDE=DRIVERS

[DEFAULTEMS]
DOS=HIGH,UMB

DEVICE=C:\DRV\DOSMAX\DOSMAX.EXE /C+ /P- /R-
DEVICE=C:\DOS\HIMEM.SYS /TESTMEM:OFF
DEVICE=C:\DOS\EMM386.EXE RAM I=B000-B7FF

INCLUDE=DRIVERS

[DRIVERS]
BUFFERS=20
FILES=40
FCBS=1
STACKS=9,256
LASTDRIVE=E

DEVICEHIGH=C:\DOS\SETVER.EXE
COUNTRY=049,850,C:\DOS\COUNTRY.SYS
DEVICEHIGH=C:\DOS\DISPLAY.SYS CON=(EGA,,1)
DEVICEHIGH=C:\DOS\ANSI.SYS

SHELL=C:\PGM\4DOS\4DOS.COM C:\PGM\4DOS\ /P

[NETWORK]
INCLUDE=DEFAULT

[NETWORKEMS]
INCLUDE=DEFAULTEMS

[MINIMUM]
DOS=HIGH
DEVICE=C:\DOS\HIMEM.SYS /TESTMEM:OFF

BUFFERS=20
FILES=30
FCBS=1
STACKS=9,256
LASTDRIVE=E
```

### autoexec.bat
```
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\PGM\NC;C:\PGM\NU;C:\PGM\PACKER

SET DIRCMD=/O:GN
SET TEMP=C:\TEMP
SET TMP=C:\TEMP

GOTO %CONFIG%

:DEFAULT
:DEFAULTEMS
MODE CON CODEPAGE PREPARE=((850) C:\DOS\EGA.CPI)
MODE CON CODEPAGE SELECT=850

LH KEYB GR,,C:\DOS\KEYBOARD.SYS
LH C:\DRV\MOUSE\CTMOUSE.EXE /V

GOTO END

:NETWORK
:NETWORKEMS
SET PATH=%PATH%;C:\PGM\NET

MODE CON CODEPAGE PREPARE=((850) C:\DOS\EGA.CPI)
MODE CON CODEPAGE SELECT=850

LH KEYB GR,,C:\DOS\KEYBOARD.SYS
LH C:\DRV\MOUSE\CTMOUSE.EXE /V

ECHO. 
ECHO Initializing network ...
ECHO.
SET MTCPCFG=C:\DRV\NET\CONFIG\MTCP.CFG
SET WATTCP.CFG=C:\DRV\NET\CONFIG
C:\DRV\3COM\3C5X9PD.COM 0x60
C:\PGM\NET\DHCP.EXE > NUL
C:\DRV\NET\DHCP.COM /M /W

:: SOMMERZEIT UTC-2:00, WINTERZEIT UTC-1:00
SET TZ=UTC-1:00
CALL C:\PGM\NET\NTP.BAT

GOTO END

:MINIMUM
LH KEYB GR,850,C:\DOS\KEYBOARD.SYS
C:\DRV\MOUSE\CTMOUSE.EXE /V
GOTO END

:END
ECHO.
SET BLASTER=A220 I5 D1 H3 T4
C:\DRV\UNISOUND\UNISOUND.COM /VC80 /VL80 /VF60
```
