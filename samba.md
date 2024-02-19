# create Samba Config
replaces synology nas

## Samba linux visibility with Windows 10+ network
https://github.com/christgau/wsdd

## Shares
smb.conf
```ini
[global]
   workgroup = ACME
   server string = %h (Samba Server)
   map to guest = Bad User
   log file = /var/log/samba/%m
   log level = 1
   server role = standalone server

   # kde dolphin kio (23.08.4) will not work without
   client min protocol = SMB2
   client max protocol = SMB3

```


### transfer 
everyone is allowed

make shared folder read & writeable for everyone ```chmod 777 /daten/transfer``` 

smb.conf
```ini
[transfer]
   # r/w access for everyone
   path = /daten/transfer
   read only = no
   guest ok = yes
   guest only = yes
```

### each user a share, read/write only for the user
user has to be created locally, ideally in a way that he cannot log in to the computer. you can enter the same password for passwd and smbpasswd

```bash
 useradd -M -s /sbin/nologin demoUser
 passwd demoUser
 smbpasswd -a demoUser  
 
```

the shared directory also needs corresponding user permissions

```bash

chown demoUser:demoUser /daten/demoUser 
chmod 700 /daten/demoUser

``` 

smb.conf
```ini
[demoUser]
   # r/w only for demouser
   path = /daten/demoUser
   valid users = demoUser
   browsable = yes
   writable = yes
   read only = no
   create mask = 0600
   directory mask = 0700
   force create mode = 0600
   force directory mode = 0700
```

### timemachine
backup space for macs

```bash
useradd -M -s /sbin/nologin mcfly
passwd mcfly
smbpasswd -a mcfly
 
chown mcfly:mcfly /daten/timemachine 
chmod 700 /daten/timemachine
```


```ini
[global]
   ...
   vfs objects = fruit streams_xattr
   fruit:metadata = stream
   fruit:model = MacSamba
   fruit:posix_rename = yes
   fruit:veto_appledouble = no
   fruit:nfs_aces = no
   fruit:wipe_intentionally_left_blank_rfork = yes
   fruit:delete_empty_adfiles = yes

[timemachine]
   comment = Time Machine Backups
   path = /daten/timemachine
   valid users = mcfly
   browsable = yes
   writable = yes
   read only = no
   create mask = 0600
   directory mask = 0700
   force create mode = 0600
   force directory mode = 0700
   fruit:aapl = yes
   fruit:time machine = yes
   fruit:time machine max size = 2T
```

you also have to install avahi and then store this file under /etc/avahi/services/timemachine.service

timemachine.service
```xml
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_smb._tcp</type>
    <port>445</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>9</port>
    <txt-record>model=TimeCapsule8,119</txt-record>
  </service>
  <service>
    <type>_adisk._tcp</type>
    <port>9</port>
    <txt-record>dk0=adVN=timemachine,adVF=0x82</txt-record>
    <txt-record>sys=adVF=0x100</txt-record>
  </service>
</service-group>

```

### shares for groups

a group accesses a share ... demoGroup

group has to be created locally and users have to be added to the group

```bash
 groupadd demoGroup
 usermod -aG demoGroup demoUser1
 usermod -aG demoGroup demoUser2
 usermod -aG demoGroup demoUser3
 
```

the shared directory must still needs access rights

```bash
chown nobody:demoGroup /daten/demoGroup
# sgid bid 2 is important, this way the group of the parent directory is used for new objects and not the users default group

chmod 2770 /daten/demoGroup
``` 

smb.conf
```ini
[demoGroup]
   # r/w for everyone in demoGroup except demoUser3
   path = /daten/demoGroup
   valid users = @demoGroup
   invalid users = demoUser3
   browsable = yes
   writable = yes
   read only = no
   create mask = 0660
   directory mask = 0770
   force create mode = 0660
   force directory mode = 0770
```
