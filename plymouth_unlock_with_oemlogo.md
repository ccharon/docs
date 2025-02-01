# Plymouth unlock screen to keep OEM logo.

Found here:
https://srijan.ch/graphical-password-prompt-for-disk-decryption

```bash
# cd /usr/share/plymouth/themes
# cp -r bgrt bgrt-custom
# cd bgrt-custom
# mv bgrt.plymouth bgrt-custom.plymouth
```

```diff
diff --git a/../bgrt/bgrt.plymouth b/bgrt-custom.plymouth
index e8e9713..ca7a293 100644
--- a/../bgrt/bgrt.plymouth
+++ b/bgrt-custom.plymouth
@@ -30,8 +30,8 @@ Name[he]=BGRT
 Name[fa]=BGRT
 Name[fi]=BGRT
 Name[ie]=BGRT
-Name=BGRT
-Description=Jimmac's spinner theme using the ACPI BGRT graphics as background
+Name=BGRT-Custom
+Description=Customized Jimmac's spinner theme using the ACPI BGRT graphics as background
 ModuleName=two-step

 [two-step]
@@ -39,9 +39,9 @@ Font=Cantarell 12
 TitleFont=Cantarell Light 30
 ImageDir=/usr/share/plymouth/themes//spinner
 DialogHorizontalAlignment=.5
-DialogVerticalAlignment=.382
+DialogVerticalAlignment=.75
 TitleHorizontalAlignment=.5
-TitleVerticalAlignment=.382
+TitleVerticalAlignment=.75
 HorizontalAlignment=.5
 VerticalAlignment=.7
 WatermarkHorizontalAlignment=.5
@@ -52,7 +52,7 @@ BackgroundStartColor=0x000000
 BackgroundEndColor=0x000000
 ProgressBarBackgroundColor=0x606060
 ProgressBarForegroundColor=0xffffff
-DialogClearsFirmwareBackground=true
+DialogClearsFirmwareBackground=false
 MessageBelowAnimation=true

 [boot-up]
```

```bash
plymouth-set-default-theme -R bgrt-custom
```

Plymouth was taking a long time before displaying the password prompt. On further digging, I found a parameter called DeviceTimeout in /etc/plymouth/plymouthd.conf with default value of 8 seconds.
