# rsync

# macos

Damit rsync auch Zugriff hat wenn man von remote synchronisieren will
Settings -> Security & Privacy -> Privacy -> Full Disk Access -> sshd-keygen-wrapper

also sowas:
```bash
rsync -avzh --progress user@192.168.1.100:/Users/user/Documents/ /daten/user/rsync/
```
