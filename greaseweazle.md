# Software installation and usage examples of a greaseweazle (device for accessing a floppy drive at the raw flux level)

## installation under Linux (Gentoo) in a separate python venv
```bash
python -m venv $HOME/greaseweazle/venv
. $HOME/greaseweazle/venv/bin/activate
pip install git+https://github.com/keirf/greaseweazle@latest
```

to use the now installed ```gw``` the venv has to be active. to activate it use:
```bash
. $HOME/greaseweazle/bin/activate
```

or use a little script, maybe $HOME/bin/weazle.sh 
```bash
#!/bin/env bash

[ ! -d $HOME/Programme/greaseweazle/images ] && mkdir -p $HOME/Programme/greaseweazle/images
cd $HOME/Programme/greaseweazle/images

bash --init-file <(echo "source $HOME/Programme/greaseweazle/venv/bin/activate;gw info")

```
this enters a new shell with the venv active and already in a directory to store images



## testing if the greaseweazle is recognized
attach the device via USB.
for me it shows up as /dev/ttyACM0

```bash
$ gw info    
Host Tools: 1.16
Device:
  Port:     /dev/ttyACM0
  Model:    Greaseweazle V4
  MCU:      AT32F403, 144MHz, 96kB SRAM
  Firmware: 1.4
  Serial:   GW135194F042054000026C9705
  USB:      Full Speed (12 Mbit/s)
```

## using the greaseweazle

### reading a disk

### writing a disk
#### stp file 
#### img file
