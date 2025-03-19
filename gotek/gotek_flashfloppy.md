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
   ```
   
6. this will fail with an error, but will unprotect the internal flash in the process
   ```bash
   $ dfu-util -D /path/to/flashfloppy-at415-st105-3.36.dfu -a 0 -s 0x08000000:unprotect:force
   ``` 

7. Now that the flash is unlocked, the device will be programmed. NOTE: if this step fails with "dfu-util: ERASE_PAGE not correctly executed" repeat step 6 and then this step again
   ```bash
   $ dfu-util -D /path/to/flashfloppy-at415-st105-3.36.dfu -a 0
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
