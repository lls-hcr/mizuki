---
# Page settings
title: Virtual Private Network (2) # Define a title of your page
description: Set up a VPN server with Wireguard # Define a description of your page
keywords: Raspberry Pi, Privoxy, Squid, SquidGuard, Parental Control, Web Filter, backup, rsnapshot, vpn, openvpn # Define keywords for search engines
order: 5 # Define order of this page in list of all documentation documents
comments: true # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: Wireguard VPN server
    text: Install a personal <span style="color:red">VPN server</span> with <span style="color:red">Wireguard</span>.
---

_Last update: <span style="color:red">2021.04.25</span>_

I have been using OpenVPN for some time now, always with full satisfaction. Recently, I decided to try an alternative called Wireguard. It is said to be faster, simpler and more secure than most other VPN solutions. I describe below how to install and configure vpn tunnels using this new tool. I have to say thet the process is pleasently easy. 

First, update the system

```bash
sudo apt-get update && sudo apt-get upgrade -y
```

Install Wireguard

```bash
sudo apt-get install wireguard
```

Change directory as super user

```bash
sudo su
cd /etc/wireguard
umask 077
```

Generate Server security keys

```bash
wg genkey | tee server_private_key | wg pubkey > server_public_key
```

Generate Client security keys. Repeat as many time as needed (e.g. phone, tablet, laptop)

```bash
wg genkey | tee iPhone_private_key | wg pubkey > iPhone_public_key
```

Retrieve the **Server** Private/Public keys with the `cat` command

```bash
cat server_private_key
ID4Ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
cat server_public_key
UulJ9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
```

Retrieve the **Client** Private/Public keys with the `cat` command

```bash
cat iPhone_private_key
IOrKgxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
cat iPhone_public_key
+gfhexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
```

Create the **Server** configuration file

```bash
nano wg0.conf
```

Add

```bash
[Interface]
Address = 10.9.0.1/24
PrivateKey = insert server_private_key
ListenPort = 51900
DNS = 1.1.1.1

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
# client1 - iPhone
PublicKey = insert client_public_key
AllowedIPs = 10.9.0.2/32
PersistentkeepAlive = 60
```

<div class="callout callout--warning">
    <p><strong>Note</strong> You can have multiple peers if necessary. Each must be under the tag [Peer] with at least PublicKey and AllowedIPs. Obviously, each client will have its own public key and its own assigned IP</p>
</div>

Next, create the **Client** configuration file

```bash
nano wg0-iPhone.conf
```

Add

```bash
[Interface]
Address = 10.9.0.2/32
PrivateKey = insert client_private_key
    
[Peer]
PublicKey = insert server_public_key
Endpoint = your.publicdns.com::51900
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
```

Enable so the wg0 will start on boot and set permissions

```bash
systemctl enable wg-quick@wg0
chown -R root:root /etc/wireguard/
chmod -R og-rwx /etc/wireguard/* 
```

Type `exit`

You can always start/stop Wireguard with the following commands

```bash
sudo wg-quick up wg0
sudo wg-quick down wg0
```

Edit the `sysctl.conf` file

```bash
nano /etc/sysctl.conf
```

Find `net.ipv4.ip_forward=1` and uncomment

```bash
net.ipv4.ip_forward=1
```

Reboot and make sure the wg0 service is running with `ifconfig`. You should see the following:

```bash
wg0: flags=209<UP,POINTOPOINT,RUNNING,NOARP>  mtu 1420
        inet 10.9.0.1  netmask 255.255.255.0  destination 10.9.0.1
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 1000  (UNSPEC)
        RX packets 99827  bytes 22086788 (21.0 MiB)
        RX errors 162  dropped 0  overruns 0  frame 162
        TX packets 250690  bytes 273049948 (260.4 MiB)
        TX errors 0  dropped 762 overruns 0  carrier 0  collisions 0
```

Now, let's install `qrencode`. This tool will generate QR codes making the configuration of Wireguard on a mobile device super easy.

Install with the following 2commands

```bash
sudo apt-get install python-pip
```

then

```bash
sudo apt-get install qrencode
```

now, as super user type the following to generate the QR code and scan it with your mobile phone

```bash
sudo su
qrencode -t ansiutf8 < /etc/wireguard/wg0-iPhone.conf
```

That's it! Pretty easy, isn't it.

Type the command below to see the state of your connection

```bash
sudo wg
```

<div class="callout callout--warning">
    <p><strong>Firewall</strong> If you are behind a firewall such as UFW, don't forget to open the port wireguard is listening to (51900/udp)</p>
</div>


<div class="callout callout--warning">
    <p><strong>Port Forward</strong> Don't forget to set port forwarding as necessary</p>
</div>


<div class="Reference"></div>

#### Reference

[https://tutox.fr/2020/02/07/installer-un-vpn-wireguard-sur-sa-raspberry-tuto/](https://tutox.fr/2020/02/07/installer-un-vpn-wireguard-sur-sa-raspberry-tuto/)<br />
[https://engineerworkshop.com/blog/how-to-set-up-wireguard-on-a-raspberry-pi/](https://engineerworkshop.com/blog/how-to-set-up-wireguard-on-a-raspberry-pi/)<br />
[https://www.sigmdel.ca/michel/ha/wireguard/wireguard_02_en.html](https://www.sigmdel.ca/michel/ha/wireguard/wireguard_02_en.html)<br />
