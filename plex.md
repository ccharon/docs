# Plex Installation

## Installation 

## Hardware Transcoding

Server without X or wayland also needs mesa ...

make.conf

VIDEO_CARDS="amdgpu radeon radeonsi"

mesa USE Flags: vaapi
emerge mesa libva libva-utils

## Check if everything works
vainfo
```
bugs ~ # vainfo 
Trying display: drm
libva info: VA-API version 1.16.0
libva info: Trying to open /usr/lib64/va/drivers/radeonsi_drv_video.so
libva info: Found init function __vaDriverInit_1_16
libva info: va_openDriver() returns 0
vainfo: VA-API version: 1.16 (libva 2.16.0)
vainfo: Driver version: Mesa Gallium driver 22.1.7 for AMD RENOIR (LLVM 14.0.6, DRM 3.42, 5.15.77-gentoo-dist)
vainfo: Supported profile and entrypoints
      VAProfileMPEG2Simple            :	VAEntrypointVLD
      VAProfileMPEG2Main              :	VAEntrypointVLD
      VAProfileVC1Simple              :	VAEntrypointVLD
      VAProfileVC1Main                :	VAEntrypointVLD
      VAProfileVC1Advanced            :	VAEntrypointVLD
      VAProfileH264ConstrainedBaseline:	VAEntrypointVLD
      VAProfileH264ConstrainedBaseline:	VAEntrypointEncSlice
      VAProfileH264Main               :	VAEntrypointVLD
      VAProfileH264Main               :	VAEntrypointEncSlice
      VAProfileH264High               :	VAEntrypointVLD
      VAProfileH264High               :	VAEntrypointEncSlice
      VAProfileHEVCMain               :	VAEntrypointVLD
      VAProfileHEVCMain               :	VAEntrypointEncSlice
      VAProfileHEVCMain10             :	VAEntrypointVLD
      VAProfileHEVCMain10             :	VAEntrypointEncSlice
      VAProfileJPEGBaseline           :	VAEntrypointVLD
      VAProfileVP9Profile0            :	VAEntrypointVLD
      VAProfileVP9Profile2            :	VAEntrypointVLD
      VAProfileNone                   :	VAEntrypointVideoProc
```