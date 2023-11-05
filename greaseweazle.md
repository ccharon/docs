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

[ ! -d $HOME/Programme/greaseweazle/images ] && mkdir -p $HOME/greaseweazle/images
cd $HOME/greaseweazle/images

bash --init-file <(echo "source $HOME/greaseweazle/venv/bin/activate;gw info")

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
to get more information about possible reading formats and outputs use ```gw read --help```
reading an msdos 1.44MB HD 3.5" Disk
```bash
$ gw read --format ibm.1440 a.scp
Reading c=0-79:h=0-1 revs=2
Format ibm.1440
T0.0: IBM MFM (18/18 sectors) from Raw Flux (172457 flux in 399.82ms)
T0.1: IBM MFM (18/18 sectors) from Raw Flux (181444 flux in 399.78ms)
T1.0: IBM MFM (18/18 sectors) from Raw Flux (154986 flux in 399.83ms)
T1.1: IBM MFM (18/18 sectors) from Raw Flux (154716 flux in 399.76ms)
T2.0: IBM MFM (18/18 sectors) from Raw Flux (151418 flux in 399.75ms)
...

```

### writing a disk
#### stp file 
#### img file
