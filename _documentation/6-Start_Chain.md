---
# Page settings
title: OpenVPN + Privoxy + Danted # Define a title of your page
description: OpenVPN + Privoxy + Danted Starting Process — Description # Define a description of your page
keywords: # Define keywords for search engines
order: 6 # Define order of this page in list of all documentation documents
comments: false # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: OpenVPN + Privoxy + Danted Starting Process — Title
    text: OpenVPN + Privoxy + Danted Starting Process — Text
---

###### Run the commands below to disable the auto-start daemon.  

```bash
sudo update-rc.d openvpn disable
sudo update-rc.d privoxy disable
sudo update-rc.d danted disable
```

###### Create the vpn-up script to start programs.

```bash
sudo nano /home/pi/vpn-up
```

```bash
#!/bin/sh
sudo service danted start
sudo service privoxy start
```

###### Create the vpn-down script to stop programs.

```bash
sudo nano /home/pi/vpn-down
```

```bash
#!/bin/sh
sudo service danted stop
sudo service privoxy stop
```

###### Create a start script.

```bash
sudo nano /home/pi/start
```

```bash
#!/bin/sh
sudo service openvpn start
```

###### Create a stop script.

```bash
sudo nano /home/pi/stop
```

```bash
#!/bin/sh
sudo service openvpn stop
```

###### Create a status report script.

```bash
sudo nano /home/pi/status
```

```bash
#!/bin/sh
ifconfig tun0
service openvpn status
service privoxy status
service danted status
```

###### Set execution rights.

```bash
sudo chmod +x /home/pi/vpn-up
sudo chmod +x /home/pi/vpn-down
sudo chmod +x /home/pi/start
sudo chmod +x /home/pi/stop
sudo chmod +x /home/pi/status
```

###### Add the 3 lines below at the end of the openvpn.conf.

```bash
sudo nano /etc/openvpn/openvpn.conf
```

```bash
script-security 2
up /home/pi/vpn-up
down /home/pi/vpn-down
```

## Credit
- [PrivacyPi on Github](https://github.com/jonathanhaslett/PrivacyPi).

<div class="callout callout--info">
    <p><strong>Note:</strong>An installer is available in the PrivacyPi github page.</p>
</div>