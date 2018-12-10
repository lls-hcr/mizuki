---
# Page settings
title: Static IP # Define a title of your page
description: Give r-pi a static IP # Define a description of your page
keywords: # Define keywords for search engines
order: 1 # Define order of this page in list of all documentation documents
comments: false # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: Static IP
    text: Assign a static IP to your r-pi
---

```bash
sudo nano /etc/dhcpcd.conf
```

```bash
#Config for static IP on eth0

interface eth0 
static ip_address=192.168.1.xxx/24 
static routers=192.168.1.1 
static domain_name_servers=192.168.1.1
```