# Flasing a gotek floppy emulator with flashfloppy via usb


## Programming the device
perforn this as root:

1. install dfu-util

```bash
$ emerge dfu-util
```

2. [download the flashfloppy release](https://github.com/keirf/flashfloppy/releases) and unpack it. There will be a dfu/ directory containing the firmware file. You want to use the .dfu file, not the .hex file.

3. set the programming jumper on the gotek as per wiki
   <img src="programming_jumper.jpg" alt="programming jumper" width="300"/>

4. attach gotek to linux box via usb-a to usb-a cable

5. This should display two entries for one device (just different alt numbers). If more than one device is shown, you'll have to add the --device option as per the dfu-util manpage
   ```bash
   dfu-util --list
   ```
   
6. this will fail with an error, but will unprotect the internal flash in the process
   ```bash
   dfu-util -D /path/to/flashfloppy-at415-st105-3.36.dfu -a 0 -s 0x08000000:unprotect:force
   ``` 

7. Now that the flash is unlocked, the device will be programmed. NOTE: if this step fails with "dfu-util: ERASE_PAGE not correctly executed" repeat step 6 and then this step again
   ```bash
   dfu-util -D /path/to/flashfloppy-at415-st105-3.36.dfu -a 0
   ```

8. unplug usb cable. Move programming jumper back to non-programming position. Apply 5v to appropriate berg header pins. 7-segment display should read "F-F" if the programming was successful

## Sources

https://github.com/keirf/flashfloppy/wiki/Firmware-Programming

https://github.com/keirf/flashfloppy/discussions/698#discussioncomment-3901322
