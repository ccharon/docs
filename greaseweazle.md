# Software installation and usage examples of a greaseweazle (device for accessing a floppy drive at the raw flux level)

## installation under Linux (Gentoo) in a separate python venv
```bash
python -m venv $HOME/greaseweazle
. $HOME/greaseweazle/bin/activate
pip install git+https://github.com/keirf/greaseweazle@latest
```

to use the now installed ```gw``` the venv has to be active. to activate it use:
```bash
. $HOME/greaseweazle/bin/activate
```
