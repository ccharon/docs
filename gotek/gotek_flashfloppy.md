# Flasing a gotek floppy emulator with flashfloppy via usb


## Programming the device
the steps have to be performed as root

1. install dfu-util

   ```bash
   $ emerge dfu-util
   ```

2. [download the flashfloppy release](https://github.com/keirf/flashfloppy/releases) and unpack it. There will be a dfu/ directory containing the firmware file. You want to use the .dfu file, not the .hex file.

3. set the programming jumper on the gotek. a paperclip works
   
   <img src="programming_jumper.jpg" alt="programming jumper" width="300"/>

4. attach gotek to linux box via usb-a to usb-a cable. USB A tO USB C worked for me too, but its not guaranteed.

5. This should display two entries for one device (just different alt numbers). If more than one device is shown, you'll have to add the --device option as per the dfu-util manpage
   ```bash
   $ dfu-util --list
   dfu-util 0.11
   
   Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
   Copyright 2010-2021 Tormod Volden and Stefan Schmidt
   This program is Free Software and has ABSOLUTELY NO WARRANTY
   Please report bugs to http://sourceforge.net/p/dfu-util/tickets/
   
   Found DFU: [2e3c:df11] ver=0200, devnum=11, cfg=1, intf=0, path="1-10", alt=1, name="@Option Byte   /0x1FFFF800/02*016 e", serial="AT32"
   Found DFU: [2e3c:df11] ver=0200, devnum=11, cfg=1, intf=0, path="1-10", alt=0, name="@Internal Flash  /0x08000000/ 128*1Kg", serial="AT32"

   ```
   
6. this will fail with an error, but will unprotect the internal flash in the process
   ```bash
   $ dfu-util -D flashfloppy-at415-st105-3.43.dfu -a 0 -s 0x08000000:unprotect:forcedfu-util 0.11

   Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
   Copyright 2010-2021 Tormod Volden and Stefan Schmidt
   This program is Free Software and has ABSOLUTELY NO WARRANTY
   Please report bugs to http://sourceforge.net/p/dfu-util/tickets/
   
   Match vendor ID from file: 0483
   Match product ID from file: df11
   Multiple alternate interfaces for DfuSe file
   Opening DFU capable USB device...
   Device ID 2e3c:df11
   Device DFU version 011a
   Claiming USB DFU Interface...
   Setting Alternate Interface #0 ...
   Determining device status...
   DFU state(2) = dfuIDLE, status(0) = No error condition is present
   DFU mode device DFU version 011a
   Device returned transfer size 2048
   DfuSe interface name: "Internal Flash  "
   DFU state(5) = dfuDNLOAD-IDLE, status(0) = No error condition is present
   dfu-util: Wrong state after command "READ_UNPROTECT" download

   ``` 

7. Now that the flash is unlocked, the device will be programmed. NOTE: if this step fails with "dfu-util: ERASE_PAGE not correctly executed" repeat step 6 and then this step again
   ```bash
   $ dfu-util -D flashfloppy-at415-st105-3.43.dfu -a 0 
   dfu-util 0.11
   
   Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
   Copyright 2010-2021 Tormod Volden and Stefan Schmidt
   This program is Free Software and has ABSOLUTELY NO WARRANTY
   Please report bugs to http://sourceforge.net/p/dfu-util/tickets/
   
   Match vendor ID from file: 0483
   Match product ID from file: df11
   Multiple alternate interfaces for DfuSe file
   Opening DFU capable USB device...
   Device ID 2e3c:df11
   Device DFU version 011a
   Claiming USB DFU Interface...
   Setting Alternate Interface #0 ...
   Determining device status...
   DFU state(2) = dfuIDLE, status(0) = No error condition is present
   DFU mode device DFU version 011a
   Device returned transfer size 2048
   DfuSe interface name: "Internal Flash  "
   File contains 1 DFU images
   Parsing DFU image 1
   Target name: ST...
   Image for alternate setting 0, (2 elements, total size = 116552)
   Setting Alternate Interface #0 ...
   Parsing element 1, address = 0x08000000, size = 30260
   Erase           [=========================] 100%        30260 bytes
   Erase    done.
   Download        [=========================] 100%        30260 bytes
   Download done.
   Parsing element 2, address = 0x08008000, size = 86276
   Erase           [=========================] 100%        86276 bytes
   Erase    done.
   Download        [=========================] 100%        86276 bytes
   Download done.
   Done parsing DfuSe file
   ```

8. unplug usb cable. Move programming jumper back to non-programming position. Apply 5v to appropriate berg header pins. 7-segment display should read "F-F" if the programming was successful

## Hints

### ibmpc mode
Setting ibmpc mode (interface property) instead of default shugart, Jumper JC closed or [FF.CFG](https://github.com/keirf/flashfloppy/blob/master/examples/FF.CFG#L21)

### usb stick
use FAT32 and a MBR formatted USB Stick. EFI partition tables do not work

## Sources

https://github.com/keirf/flashfloppy/wiki/Firmware-Programming

https://github.com/keirf/flashfloppy/discussions/698#discussioncomment-3901322
