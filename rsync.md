# rsync

# macos

Damit rsync auch Zugriff hat wenn man von remote synchronisieren will
Settings -> Security & Privacy -> Privacy -> Full Disk Access -> sshd-keygen-wrapper

also sowas:
```bash
rsync -avzh --progress christian@192.168.2.87:/Users/Christian/Documents/ /daten/christian/rsync/
```
