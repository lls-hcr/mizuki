---
# Page settings
title: IoT Project # Define a title of your page
description: LoRaWan Gateway and Node # Define a description of your page
keywords: Raspberry Pi, LoRaWan, IoT, Gateway, Lora Node # Define keywords for search engines
order: 6 # Define order of this page in list of all documentation documents
comments: true # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: IoT Gateway and Node
    text: Deploy an <span style="color:red">IoT</span> Gateway and Node on <span style="color:red">TTN</span>.
---

_Last update: <span style="color:red">2023.01.12</span>_

###### **The Gateway**

Some time ago, I built a LoRaWan gateway that I deployed on The Things Network (TTN). The gateway has a Raspberry Pi 3+ and a IoT Gateway HAT from Pi Supply. The board utilises the RAKWireless RAK833 LoRa gateway concentrator module.

It also has a Pi PoE Switch HAT and a PiJuice HAT, also from Pi Supply. In addition to the LoRa antenna, I put a [Small GNSS Antenna (GPS)](https://www.antennas.us/UC-1574-653RS-small-GPS-GNSS-antenna.html) that I purchased at the [Antennas & RF Electronics Store](https://www.antennas.us/). All is assembled in the Nebra IP67 Enclosure.

![image](/images/gateway.jpg)

I have deployed the software using balenaCloud. This conveniently allows to remotely manage and update the gateway through the balenaCloud application.

![image](/images/balena_gateway.png)

The Gateway is then deployed on TTN.

![image](/images/ttn_node.png)

###### **The Node**

I am also using a Raspberry Pi IoT LoRa pHAT together with a Raspberry Pi Zero W. I added to it a Pimoroni BME680 Breakout sensor that can measure air quality, temperature, pressure and humidity.

![image](/images/node.jpg)

To send the data to the Gateway, I am using the Python code below. This will send temperature, barometric pressure and humidity values to TTN. The sensor.set_temp_offset(offset) and display_data(-3) code allow compensating the temperature by +/- n degrees. I noticed that the temperature value may be a few degrees too high, especially if the sensor is in a box or close to a battery that generates heat.

###### **The Code**

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from rak811.rak811 import Mode, Rak811
import bme680
import time

lora = Rak811()
lora.hard_reset()
time.sleep(2)
lora.mode = Mode.LoRaWan
lora.band = 'EU868'
lora.set_config(dev_eui='XXXXXXXXXXXXXXXX',
app_eui='XXXXXXXXXXXXXXXX',
app_key='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
lora.join_otaa()
lora.dr = 5

sensor = bme680.BME680(bme680.I2C_ADDR_PRIMARY)
sensor.set_humidity_oversample(bme680.OS_2X)
sensor.set_pressure_oversample(bme680.OS_4X)
sensor.set_temperature_oversample(bme680.OS_8X)
sensor.set_filter(bme680.FILTER_SIZE_3)

while True:
     def display_data(offset=0):
         sensor.set_temp_offset(offset)
     if sensor.get_sensor_data():
         Temp = int(10*round(sensor.data.temperature, 1))
         Pression = int(10*round(sensor.data.pressure, 1))
         HR = int(2*sensor.data.humidity)
         display_data(-3)
         lora.send(bytes.fromhex('0167{:04x}0273{:04x}0368{:02x}'.format(Temp, Pression, HR)))
         time.sleep(15)

lora.close()
```

Data is sent to the Gateway and can be seen on the Live Data board.

![image](/images/ttn_data.png)

###### **The Data Visualisation**

Finally, I am using Datacake to visualise the data through a custom dashboard.

![image](/images/datacake_bme680.png)

That’s it !


<div class="Reference"></div>

#### Reference

[https://www.framboise314.fr/connecter-une-gateway-lora-rak833-a-ttn-v3/](https://www.framboise314.fr/connecter-une-gateway-lora-rak833-a-ttn-v3/)<br />
[https://www.hardill.me.uk/wordpress/2020/08/01/another-lora-temperature-humidity-sensor/?unapproved=28525&moderation-hash=625a6af01e4b6e29e7c066ecb3b2271d#comment-28525](https://www.hardill.me.uk/wordpress/2020/08/01/another-lora-temperature-humidity-sensor/?unapproved=28525&moderation-hash=625a6af01e4b6e29e7c066ecb3b2271d#comment-28525)<br />
[https://learn.pimoroni.com/article/getting-started-with-bme680-breakout](https://learn.pimoroni.com/article/getting-started-with-bme680-breakout)<br />
[https://docs.datacake.de/lorawan/using-cayenne-lpp](https://docs.datacake.de/lorawan/using-cayenne-lpp)<br />


#### Material

[IoT Gateway HAT for Raspberry Pi](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi?_pos=23&_sid=b7540842e&_ss=r)<br />
[Raspberry Pi IoT LoRa pHAT](https://uk.pi-supply.com/products/iot-lora-node-phat-for-raspberry-pi)<br />
[Raspberry Pi Zero W](https://uk.pi-supply.com/products/raspberry-pi-zero-w)<br />
[Nebra IP67 Enclosure](https://uk.pi-supply.com/products/die-cast-outdoor-weatherproof-enclosure)<br />
[Mounting Expansion Board](https://uk.pi-supply.com/products/nebra-ip67-case-gateway-hat-mounting-and-expansion-board)<br />
[Pi PoE Switch HAT](https://uk.pi-supply.com/products/pi-poe-switch-hat-power-over-ethernet-for-raspberry-pi?_pos=9&_sid=c4cadcfd7&_ss=r)<br />
[PiJuice HAT](https://uk.pi-supply.com/products/pijuice-standard?_pos=22&_sid=6e5cbdb02&_ss=r)<br />
[BME680 Sensor](https://shop.pimoroni.com/collections/breakout-garden)<br />
[Ublox NEO-6M GPS UART](https://uk.pi-supply.com/products/ublox-neo-6m-gps-uart-module-breakout-with-antenna)<br />
[Small GNSS Antenna (GPS)](https://www.antennas.us/UC-1574-653RS-small-GPS-GNSS-antenna.html)


#### Assembly Guide

[How to assemble your HAT Holder for the Nebra IP67 Case](https://learn.pi-supply.com/make/how-to-assemble-your-hat-holder-for-the-nebra-ip67-case/)<br />