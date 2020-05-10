# hmmm

## macOS Catalina Installations ISO erstellen
### Create a DMG Disk Image
hdiutil create -o /tmp/Catalina -size 8500m -volname Catalina -layout SPUD -fs HFS+J
### Mount it to your macOS
hdiutil attach /tmp/Catalina.dmg -noverify -mountpoint /Volumes/Catalina
### Create macOS Catalina Installer
sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/Catalina --nointeraction
### Unmount Catalina Disk
hdiutil detach /volumes/Install\ macOS\ Catalina
### Convert the dmg file to a iso file
hdiutil convert /tmp/Catalina.dmg -format UDTO -o ~/Desktop/Catalina.cdr
### Rename and Move to Desktop
mv ~/Desktop/Catalina.cdr ~/Desktop/Catalina.iso
