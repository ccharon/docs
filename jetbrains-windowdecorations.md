# make clion or idea respect the serverside window decorations on Wayland.

add this to the custom vm options (Help -> Edit custom VM Options)

```
-Dawt.toolkit.name=WLToolkit
-Dsun.awt.wl.WindowDecorationStyle=server
```
