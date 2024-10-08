# Linux Server grundlegend absichern
https://dev.to/samerickson/how-to-create-a-minecraft-server-hardening-the-server-30ko

## Securing SSHD

### Generate Keypair for authentication
Auf dem eigenen Rechner:
ssh-keygen -t ed25519

Dann Public Key auf den Server kopieren
ssh-copy-id -i ~/.ssh/id_ed25519 <username>@hostip

### Configuring SSHD (on serverside)
/etc/ssh/sshd_config

- PermitRootLogin no
- PubKeyAuthentication yes
- PasswordAuthentication no
- PermitEmptyPasswords no
- Port 2444
- KbdInteractiveAuthentication no
ListenAddress <your-public-ip-address>

Before restarting ssh open firewall port
ufw allow 2444/tcp

restart sshd
service ssh restart

exit 
on client change ~/.ssh/config


host 192.168.2.6
    HostName 192.168.2.6
    User genesis
    Port 2444
    IdentityFile ~/.ssh/id_ed25519



dann /etc/sysctl.conf



# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0 
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Block SYN attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0 
net.ipv6.conf.default.accept_redirects = 0

# Ignore Directed pings
net.ipv4.icmp_echo_ignore_all = 1
