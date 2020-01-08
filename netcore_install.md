# Installieren von .net core auf Debian Buster
```bash
wget -q https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb 
apt-get update

# gucken was es gibt
apt-cache search dotnet-sdk

# installieren was man braucht
apt-get install  dotnet-sdk-3.1
```
Wenn man noch die Telemetriedaten abschalten möchte dann das hier in die .bashrc oder .zshrc oder was auch immer
export DOTNET_CLI_TELEMETRY_OPTOUT=1
Damit es in der aktuellen Shell auch geht, dort direkt ausführen
