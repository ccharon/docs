# Getting and refreshing letsencrypt wildcard certificated with acme.sh (for domains managed by netcup)
Netcup has an API to add the required TXT record needed for the dnscheck.

## Using Netcup API
- in netcup customercontrolpanel create an API Key and Secret.
- export the credentials (only needed for first use)

## install acme.sh (https://github.com/acmesh-official/acme.sh)
```bash
# curl https://get.acme.sh | sh -s email=my@example.com
```

### switch to letsencrypt
```bash
acme.sh --set-default-ca --server letsencrypt
```

## create certificate
```bash
export NC_CID="<numeric customer id>"
export NC_Apikey="<api key>"
export NC_Apipw="<api password>"

. "/root/.acme.sh/acme.sh.env"

# acme.sh --issue --dns dns_netcup -d "erdferkel.eu" -d "*.erdferkel.eu"
```

## install certificate
```bash
# mkdir -p /etc/nginx/ssl/erdferkel.eu
# acme.sh --install-cert -d "erdferkel.eu"   --key-file "/etc/nginx/ssl/erdferkel.eu/key.pem"   --fullchain-file "/etc/nginx/ssl/erdferkel.eu/fullchain.pem"   --reloadcmd "systemctl reload nginx"
```

## usage in nginx

### in server block ...
```
    ssl_certificate /etc/nginx/ssl/erdferkel.eu/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/erdferkel.eu/key.pem;
    include /etc/nginx/ssl/options.conf;
    ssl_dhparam /etc/nginx/ssl/dhparam.pem
```
## dhparam.pem
```bash
# openssl dhparam -out dhparams.pem 4096
```

## options.conf taken at some point from certbot
```
ssl_session_timeout 1440m;
ssl_session_tickets off;

ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;

ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
```
