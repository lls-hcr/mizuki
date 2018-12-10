---
# Page settings
title: Privoxy # Define a title of your page
description: Privoxy — Description # Define a description of your page
keywords: # Define keywords for search engines
order: 4 # Define order of this page in list of all documentation documents
comments: false # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: Privoxy — Title
    text: Privoxy — Text
---

###### Install Privoxy.
```bash
sudo apt-get install privoxy
```

###### Backup the original configuration file.
```bash
sudo cp /etc/privoxy/config /etc/privoxy/config.bkp
```

###### Create a config file without commented lines.
```bash
sudo su
cat /etc/privoxy/config.bkp | egrep -v -e '^[[:blank:]]*#|^$' > /etc/privoxy/config
```

###### Modify the conf file.
```bash
sudo nano /etc/privoxy/config
```

```bash
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
filterfile default.filter
filterfile user.filter      # User customizations
logfile logfile
listen-address  192.168.1.xxx:8118
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 1
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 0
forwarded-connect-retries  0
accept-intercepted-requests 0
allow-cgi-request-crunching 0
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
forward-socks5   /               192.168.1.xxx:1080 .
```

<div class="callout callout--warning">
    <p><strong>Note:</strong>The last line is used to forward traffic to Danted.</p>
</div>
