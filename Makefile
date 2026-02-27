# --- Configuración del Proyecto ---
TARGET      := NDS64
BUILD       := build
SOURCES     := source
INCLUDES    := include

# --- Importar Reglas de devkitPro ---
# Esto define automáticamente LIBNDS, DEVKITARM y las rutas de calico.h
ifeq ($(strip $(DEVKITARM)),)
$(error "DEVKITARM no está definido. Revisa tu entorno.")
endif

include $(DEVKITARM)/ds_rules

# --- Flags Corregidos ---
# -DARM9 es vital para que nds.h sepa qué arquitectura usar
# Usamos $(LIBNDS) que es la variable oficial de devkitPro
ARCH    := -mthumb -mthumb-interwork
CFLAGS  := $(ARCH) -O2 -Wall -DARM9 -D__NDS__ \
           -I$(INCLUDES) -I$(LIBNDS)/include

LDFLAGS := $(ARCH) -L$(LIBNDS)/lib
LIBS    := -lnds9

# --- Lógica de Compilación ---
CFILES  := $(wildcard $(SOURCES)/*.c)
OBJS    := $(CFILES:$(SOURCES)/%.c=$(BUILD)/%.o)

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(BUILD)/$(TARGET).elf
	@echo "Creando ROM..."
	$(NDSTOOL) -c $@ -9 $<

$(BUILD)/$(TARGET).elf: $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

$(BUILD)/%.o: $(SOURCES)/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -rf $(BUILD) $(TARGET).nds
