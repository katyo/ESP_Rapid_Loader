ifneq ($(V),)
  Q :=
else
  Q := @
endif

# Paths patterns
BIN_P = bin/$(1).elf
MAP_P = bin/$(1).map
LIB_P = lib/$(1).a
DEP_P = obj/$(1).d
OBJ_P = obj/$(1).o
SRC_P = $(1).$(2)

# Compiler configuration
COMPILER_PREFIX ?= $(if $(COMPILER_PATH),$(COMPILER_PATH)/)xtensa-lx106-elf-

CC := $(COMPILER_PREFIX)gcc
AR := $(COMPILER_PREFIX)ar
LD := $(COMPILER_PREFIX)gcc
NM := $(COMPILER_PREFIX)nm
CPP := $(COMPILER_PREFIX)cpp
OBJDUMP := $(COMPILER_PREFIX)objdump
OBJCOPY := $(COMPILER_PREFIX)objcopy

# Compiler flags
CFLAGS += $(addprefix -D,$(CDEFS))
CFLAGS += $(addprefix -I,$(CDIRS))

# Linker flags
LDFLAGS += $(addprefix -L,$(LDDIRS))

build:
clean:

# Compilation rules
define CC_RULES
#$(1).SRC.$(2) := $$(wildcard $$(call SRC_P,$(1)/*,$(2)))
$(1).SRC.$(2) += $$(filter %.$(2),$$($(1).SRCS))
$(1).SRC += $$($(1).SRC.$(2))

$(1).OBJ.$(2) := $$(patsubst $$(call SRC_P,%,$(2)),$$(call OBJ_P,$(1)/%.$(2)),$$($(1).SRC.$(2)))
$(1).OBJ += $$($(1).OBJ.$(2))

$(1).DEP.$(2) := $$(patsubst $$(call SRC_P,%,$(2)),$$(call DEP_P,$(1)/%.$(2)),$$($(1).SRC.$(2)))
$(1).DEP += $$($(1).DEP.$(2))

$$(call OBJ_P,$(1)/%.$(2)): $$(call SRC_P,%,$(2))
	@echo TARGET $(1) CC $(2) $$<
	$(Q)mkdir -p $$(dir $$@)
	$(Q)$(CC) -MD -MF $$(call DEP_P,$(1)/$$*.$(2)) -c $$(CFLAGS) $$($(1).CFLAGS) -o $$@ $$<

include $$(wildcard $$(call DEP_P,$(1)/*))
endef

# Library rules
define LIB_RULES
$(1).SRC :=
$(1).OBJ :=

$(1).CFLAGS += $$(addprefix -D,$$($(1).CDEFS))
$(1).CFLAGS += $$(addprefix -I,$$($(1).CDIRS))

$$(eval $$(call CC_RULES,$(1),c))
$$(eval $$(call CC_RULES,$(1),S))

$(1).LIB := $$(call LIB_P,$(1))

build: build.lib.$(1)
build.lib.$(1): $$($(1).LIB)

$$($(1).LIB): $$($(1).OBJ)
	@echo TARGET $(1) LIB
	$(Q)mkdir -p $$(dir $$@)
	$(Q)$(AR) ru $$@ $$^

clean: clean.lib.$(1)
clean.lib.$(1):
	@echo TARGET $(1) LIB CLEAN
	$(Q)rm -f $$($(1).LIB) $$($(1).OBJ) $$($(1).DEP)
endef

# Binary rules
define BIN_RULES
$(1).LIB := $$(patsubst %,$$(call LIB_P,%),$$($(1).LIBS))
$(1).BIN := $$(call BIN_P,$(1))

build: build.bin.$(1)
build.bin.$(1): $$($(1).BIN)

$$($(1).BIN): $$($(1).DEPLIBS) $$($(1).LDSCRIPTS)
	@echo TARGET $(1) BIN
	$(Q)mkdir -p $$(dir $$@)
	$(Q)$(LD) $$(LDFLAGS) $$($(1).LDFLAGS) -Wl,-Map -Wl,$$(call MAP_P,$(1)) -Wl,--start-group $$($(1).LIB) -Wl,--end-group -o $$@

clean: clean.bin.$(1)
clean.bin.$(1):
	@echo TARGET $(1) BIN CLEAN
	$(Q)rm -f $$($(1).BIN)
endef
