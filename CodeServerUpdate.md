# Code Server Image aktualisieren

## Container stoppen
```bash
sudo docker-compose stop
``` 

## das neue code-server image holen
```bash
sudo docker pull ghcr.io/linuxserver/code-server:latest
```

## das eigene Image neu bauen
```bash
sudo docker-compose build
``` 

## neu starten
```bash
sudo docker-compose up -d
``` 
