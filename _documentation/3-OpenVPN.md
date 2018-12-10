---
# Page settings
title: OpenVPN # Define a title of your page
description: OpenVPN — Description # Define a description of your page
keywords: # Define keywords for search engines
order: 3 # Define order of this page in list of all documentation documents
comments: false # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: OpenVPN
    text: Install a VPN server with OpenVPN.
---

###### Install openvpn and openssl.
```bash
sudo apt-get install openvpn openssl
```

###### Move easy-rsa.
```bash
sudo cp -r /usr/share/easy-rsa /etc/openvpn/easy-rsa
```

###### Find `'export EASY_RSA'` and change the path.
```bash
sudo nano /etc/openvpn/easy-rsa/vars
```

<div class="callout callout--info">
    <p><strong>Replace:</strong>export EASY_RSA="`pwd`</p>
    <p><strong>With:</strong>export EASY_RSA="/etc/openvpn/easy-rsa"</p>
</div>


###### Execute the following commands.
```bash
cd /etc/openvpn/easy-rsa
sudo su
source vars
ln -s openssl-1.0.0.cnf openssl.cnf
```

(sudo cp /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf)

###### Create cert and keys. Replace `'anyName'` by whatever name you want.
```bash
./clean-all
./build-ca OpenVPN
./build-key-server server
./build-key-pass 'anyName'
./build-dh

exit
```

###### Create openvpn server conf file.
```bash
sudo nano /etc/openvpn/openvpn.conf
```

<div class="example"></div>

```bash
dev tun
proto udp
port 1194

ca /etc/openvpn/easy-rsa/keys/ca.crt
cert /etc/openvpn/easy-rsa/keys/server.crt
key /etc/openvpn/easy-rsa/keys/server.key
dh /etc/openvpn/easy-rsa/keys/dh2048.pem

server 10.8.0.0 255.255.255.0

push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 217.237.150.188"
push "dhcp-option DNS 8.8.8.8"
log-append /var/log/openvpn

persist-key
persist-tun
#user nobody
#group nogroup
status /var/log/openvpn-status.log
verb 3
client-to-client
comp-lzo

script-security 2
up /home/pi/vpn-up
down /home/pi/vpn-down
```


<div class="callout callout--info">
    <p>1194 is the default port used by openvpn. Change port if needed.</p><p>See XXXXX for vpn-up and vpn-down configuration.</p>
</div>


###### Execute the following commands. Replace `'anyName'` with the name you want to give to your .ovpn file (the same name as defined above).
```bash
sudo su
cd /etc/openvpn/easy-rsa/keys
nano 'anyName'.ovpn
```

<div class="example"></div>

```bash
dev tun
client
proto udp
remote 'yourDomainName.com' 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert 'anyName'.crt
key 'anyName'.key
comp-lzo
verb 3
```

###### Install zip so you can create compressed folders.
```bash
apt-get install zip
```

###### Create a compressed folder in your home directory. The folder will contain all the files needed to connect to your vpn server. Change `'anyName'`.
```bash
zip /home/pi/raspberry_'anyName'.zip ca.crt 'anyName'.crt 'anyName'.key 'anyName'.ovpn
```

###### Define ownership. Change `'anyName'`.
```bash
chown pi:pi /home/pi/'anyName'.zip

exit
```

###### To access the local network through a VPN tunnel, we need a redirection.
```bash
sudo nano /etc/init.d/rpivpn
```

```bash
#! /bin/sh
### BEGIN INIT INFO
# Provides:          rpivpn
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: VPN initialization script
### END INIT INFO

echo 'echo "1" > /proc/sys/net/ipv4/ip_forward' | sudo -s

iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT

iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
```

###### Define correct access rights and make it start at boot.
```bash
sudo chmod +x /etc/init.d/rpivpn
sudo update-rc.d rpivpn defaults
sudo /etc/init.d/rpivpn
```

###### Restart openvpn.
```bash
sudo /etc/init.d/openvpn restart
```


## Credit
- [Installer un serveur VPN à partir de Raspberry Pi : tutoriel avec OpenVPN](https://www.ionos.fr/digitalguide/serveur/configuration/installer-un-serveur-vpn-via-raspberry-pi-et-openvpn/).