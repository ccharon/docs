# install Minecraft (Java) on Debian Buster.
```bash
#Download the official Minecraft.deb
wget https://launcher.mojang.com/download/Minecraft.deb
```

The Minecraft.deb has a deprecated dependency "default-jdk" so we fix the package by replacing the dependency with "openjdk-11-jre"

```bash
# fix dependency, replace default-jre with openjdk-11-jre
fakeroot sh -c 'mkdir tmp; dpkg-deb -R Minecraft.deb tmp; sed -i 's/default-jre/openjdk-11-jre/g' tmp/DEBIAN/control; dpkg-deb -b tmp fixedminecraft.deb ; rm -r tmp'

# install fixed package
apt-get install ./fixedminecraft.deb
```

