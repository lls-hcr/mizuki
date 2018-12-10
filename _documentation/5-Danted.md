---
# Page settings
title: Danted # Define a title of your page
description: Danted — Description # Define a description of your page
keywords: # Define keywords for search engines
order: 5 # Define order of this page in list of all documentation documents
comments: false # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: Danted — Title
    text: Danted — Text
---

###### Install Danted.
```bash
sudo apt-get install dante-server
```

###### Backup the original configuration file.
```bash
sudo cp /etc/danted.conf /etc/danted.conf.bkp
```

###### Modify the conf file.
```bash
sudo nano /etc/danted.conf
```

```bash
logoutput: stderr /var/log/dante.log

internal: eth0 port = 1080
external: tun0

method: none
clientmethod: none

user.privileged: proxy
user.notprivileged: nobody
user.libwrap: nobody

client pass {
from: 192.168.0.0/16 port 1-65535 to: 0.0.0.0/0
log: connect error
}

client block {
from: 0.0.0.0/0 to: 0.0.0.0/0
log: connect error
}

block {
from: 0.0.0.0/0 to: 127.0.0.0/8
log: connect error
}

pass {
from: 192.168.0.0/16 to: 0.0.0.0/0
protocol: tcp udp
log: connect error
}

block {
from: 0.0.0.0/0 to: 0.0.0.0/0
log: connect error
}
```

## Credit
- [PrivacyPi on Github](https://github.com/jonathanhaslett/PrivacyPi).