include rules.mk
include image.mk

CFLAGS += -Os
CFLAGS += -Wall -Wno-pointer-sign
CFLAGS += -fno-tree-ccp -foptimize-register-move
CFLAGS += -mno-target-align -mno-serialize-volatile

CDEFS += __ets__ ICACHE_FLASH

LDDIRS += lib

app/loader.CFLAGS += -Wundef -Wpointer-arith -Werror
app/loader.CFLAGS += -Wl,-EL -fno-inline-functions -nostdlib
app/loader.CFLAGS += -mlongcalls -mtext-section-literals

app/loader.CDIRS += app/include

GEN_IMAGES = eagle.app.v6.out
GEN_BINS = eagle.app.v6.bin

rapid_loader.LIBS += app/loader

rapid_loader.LDFLAGS += \
	-nostdlib \
  -Tld/eagle.app.v6.ld \
	-Wl,--no-check-sections	\
  -u call_user_start \
	-u loader_flash_boot	\
  -Wl,-static

DEPENDS_eagle.app.v6 = \
                $(LD_FILE) \
                $(LDDIR)/eagle.rom.addr.v6.ld

$(eval $(call LIB_RULES,app/loader))
$(eval $(call IMG_RULES,rapid_loader))
