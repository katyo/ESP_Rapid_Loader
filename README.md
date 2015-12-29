# ESP8266 Rapid Loader V3

Special loader for ESP8266, which has been developed
in order to quick start and support download up to 48 KB IRAM.

Forked from [pvvx:Rapid_Loader](//github.com/pvvx/Rapid_Loader)

[The diagram of loading ESP8266ex using Rapid Loader](./doc/ESP-01-StartSignals.gif)

Loader output:

```
 ets Jan  8 2013,rst cause:2, boot mode:(3,6)

load 0x40100000, len 108, room 16 
tail 8
chksum 0x83
csum 0x83
```

where line 'chksum 0x83' means:

* First digit of checksum is flash SPI frequency.
* Second digit of checksum is version of Rapid Loader.

It can be used to speed up loading of any ESP8266 project
by inserting to begin of first code block:

```
mv -f 0x00000.bin 0x00000.bin~orig
dd if=rapid_loader.bin >0x00000.bin
dd if=0x00000.bin~orig >>0x00000.bin
```
