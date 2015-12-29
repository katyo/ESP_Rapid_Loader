# ESP8266 Rapid Loader V3

Специальный загрузчик для ESP8266, разработанный
для ускорения загрузки и поддержки 48 Кб IRAM.

Ответвлено от [pvvx:Rapid_Loader](//github.com/pvvx/Rapid_Loader)

[График загрузки ESP8266ex c Rapid Loader](./doc/ESP-01-StartSignals.gif)

Вывод загрузки:

```
 ets Jan  8 2013,rst cause:2, boot mode:(3,6)

load 0x40100000, len 108, room 16 
tail 8
chksum 0x83
csum 0x83
```

где 'chksum 0x83' это:

* Первая цифра контрольной суммы указывает на частоту работы SPI с Flash.
* Вторая цифра контрольной суммы указывает на версию Rapid Loader.

Может использоваться для ускорения загрузки любого стандартного
проекта на ESP8266 путем копирования в начало первого блока кода:

```
mv -f 0x00000.bin 0x00000.bin~orig
dd if=rapid_loader.bin >0x00000.bin
dd if=0x00000.bin~orig >>0x00000.bin
```
