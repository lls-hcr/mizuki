---
# Page settings
title: Virtual Private Network # Define a title of your page
description: Set up a VPN server # Define a description of your page
keywords: Raspberry Pi, Privoxy, Squid, SquidGuard, Parental Control, Web Filter, backup, rsnapshot, vpn, openvpn # Define keywords for search engines
order: 4 # Define order of this page in list of all documentation documents
comments: true # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: VPN server
    text: Install a <span style="color:red">personal VPN server</span> with OpenVPN.
---

_Last update: <span style="color:red">2021.04.10</span>_

Having a personal Virtual Private Network server can be useful. When traveling, I connect to my VPN server at home to encrypt communication when browsing from hotel and other public networks or to watch live TV streaming that necessitate a local IP from my country. Setting a VPN server is quite easy. For this project, I am using OpenVPN.

First, update the system

```bash
sudo apt-get update && sudo apt-get upgrade -y
```

Install OpenVPN and OpenSSL

```bash
sudo apt-get install openvpn openssl
```

Then let's disable OpenVPN

```bash
sudo update-rc.d openvpn disable
```

Copy the `easy-rsa` scripts in the OpenSSL configuration directory

```bash
sudo cp -r /usr/share/easy-rsa /etc/openvpn/easy-rsa
```

Open the following config file for editing

```bash
sudo nano /etc/openvpn/easy-rsa/vars
```

Find

```bash
export EASY_RSA="`pwd`
```

And replace with

```bash
export EASY_RSA="/etc/openvpn/easy-rsa"
```

Set the key size to `2048`. That is good enough for a r-pi 3 or 4 (1024 for less security or 4096 for more security)

```bash
export KEY_SIZE=2048
```

Change directory

```bash
cd /etc/openvpn/easy-rsa
```

Type the three commands below

```bash
sudo su
source vars
ln -s openssl-1.0.0.cnf openssl.cnf
```

If you see an error message, it could be that some files are not found. This can be fixed with the following commands

```bash
sudo cp /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf
sudo cp /etc/openvpn/easy-rsa/openssl-easyrsa.cnf /etc/openvpn/easy-rsa/openssl.cnf
```

Now, we can create keys

<div class="callout callout--warning">
    <p><strong>Note</strong> If you intent to connect form multiple device, such as a tablet, a mobile phone and a laptop, it is advised to create a different key for each device.</p>
</div>

```bash
./clean-all
./build-ca OpenVPN
```

You will be asked to enter some information. Enter the two letters identifying your country (US=USA; FR=France; DE=Germany; etc.) The other fields are optional. You can fill them in or leave them blank and press the `return` key.

Now, create a key for the server

```bash
./build-key-server server
```

Then, create a key for the client. Give it a name of your choice

```bash
./build-key-pass name_of_your_choice
```

You will be asked to set a password

Finally, type the command below to generate a certificate

```bash
./build-dh
```

Then

```bash
exit
```

Now, create a configuration file for the server

```bash
sudo nano /etc/openvpn/openvpn.conf
```

With the following (1194 is the default port)

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

# DNS servers provided by OpenDNS
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 208.67.220.220"
log-append /var/log/openvpn

persist-key
persist-tun
user nobody
group nogroup
status /var/log/openvpn-status.log
verb 3
client-to-client
comp-lzo

ifconfig-pool-persist /etc/openvpn/ipp.txt
```

Change directory with `sudo su`

```bash
sudo su
cd /etc/openvpn/easy-rsa/keys
```

And create a configuration fole for the client

```bash
nano name_of_your_choice
```

With the following. Make sure you have correctly adjusted `remote`, `cert` and `key` according to your setting

<div class="callout callout--warning">
    <p><strong>Note</strong> After "remote", use an IP or a domain name as needed.</p>
</div>

```bash
dev tun
client
proto udp
remote x.x.x.x 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert name_of_your_choice.crt
key name_of_your_choice.key
comp-lzo
verb 3
```

Now you can zip the files you will need to install on your client. Install zip first if you don't have it already installed

```bash
apt-get install zip
```

Then

```bash
zip /home/USER/name_of_your_choice.zip ca.crt name_of_your_choice.crt name_of_your_choice.key name_of_your_choice.ovpn
```

Change ownership (again, adjust as needed)

```bash
chown USER:USER /home/USER/name_of_your_choice.zip
```

Finally

```bash
exit
```

Almost done. To access your local network from the VPN, we need to redirect traffic. Create a file with

```bash
sudo nano /etc/init.d/rpivpn
```

Add the following

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

Then

```bash
sudo chmod +x /etc/init.d/rpivpn
sudo update-rc.d rpivpn defaults
```

Now execute and restart

```bash
sudo /etc/init.d/rpivpn
sudo /etc/init.d/openvpn restart
```

That's it. Now install the files you have generated earlier to your client (laptop, tablet or mobile phone) and try to connect to your VPN server.

<div class="callout callout--warning">
    <p><strong>Note</strong> If you have a firewall such as UFW, make sure you allow port 1194/udp</p>
</div>

Last thing, I don't need my VPN server to be running when I don't need it. So, I have created three little script that I can run anytime from my device to start or stop the server. The third one gives me the status.

Start script

```bash
#!/bin/sh
sudo service openvpn start
```

Stop script

```bash
#!/bin/sh
sudo service openvpn stop
```

Status script

```bash
#!/bin/sh
ifconfig tun0
service openvpn status
```

Voilà!

<div class="Reference"></div>

#### Reference

[https://www.ionos.fr/digitalguide/serveur/configuration/installer-un-serveur-vpn-via-raspberry-pi-et-openvpn/](https://www.ionos.fr/digitalguide/serveur/configuration/installer-un-serveur-vpn-via-raspberry-pi-et-openvpn/)