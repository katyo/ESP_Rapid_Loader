include rules.mk
include image.mk

CFLAGS += -Os
CFLAGS += -Wall -Wno-pointer-sign
CFLAGS += -fno-tree-ccp -foptimize-register-move
CFLAGS += -mno-target-align -mno-serialize-volatile

CDEFS += __ets__ ICACHE_FLASH

CFLAGS += -Wundef -Wpointer-arith -Werror
CFLAGS += -Wl,-EL -fno-inline-functions -nostdlib
CFLAGS += -mlongcalls -mtext-section-literals

loader.CDIRS += app/include

loader.SRCS += \
  app/loader/loader.c \
  app/loader/loader_flash_boot.S

rapid_loader.LIBS += loader
rapid_loader.LDSCRIPTS += ld/eagle.app.v6.ld
rapid_loader.LDSCRIPTS += ld/eagle.rom.addr.v6.ld

rapid_loader.LDFLAGS += \
	-nostdlib \
  -Tld/eagle.app.v6.ld \
	-Wl,--no-check-sections	\
  -u call_user_start \
	-u loader_flash_boot	\
  -Wl,-static

$(eval $(call LIB_RULES,loader))
$(eval $(call IMG_RULES,rapid_loader))
