# --- Nombre del proyecto ---
TARGET      := NDS64
OUTPUT      := NDS64

# --- Directorios ---
BUILD       := build
SOURCES     := source
INCLUDES    := include
DEVKITPRO   ?= /opt/devkitpro
LIBNDS      := $(DEVKITPRO)/libnds

# --- Configuración devkitARM ---
ifeq ($(strip $(DEVKITARM)),)
$(error "DEVKITARM no está definido. Revisa tu instalación.")
endif

include $(DEVKITARM)/ds_rules

# --- Flags y Librerías ---
# Añadimos las rutas de cabeceras de libnds y de tu proyecto
ARCH    := -mthumb -mthumb-interwork
CFLAGS  := -g -Wall -O2 $(ARCH) -DARM9 -D__NDS__ \
           -I$(INCLUDES) -I$(LIBNDS)/include -I$(LIBNDS)/include/sys/

# Añadimos la ruta de las librerías (.a) para el enlazador
LDFLAGS := -g $(ARCH) -L$(LIBNDS)/lib -Wl,-Map,$(BUILD)/$(OUTPUT).map
LIBS    := -lnds9 

# --- Objetos ---
CFILES      := $(wildcard $(SOURCES)/*.c)
OBJS        := $(CFILES:$(SOURCES)/%.c=$(BUILD)/%.o)

.PHONY: all clean

all: $(OUTPUT).nds

# Generar el binario final .nds
$(OUTPUT).nds: $(BUILD)/$(OUTPUT).elf
	@echo "Generando ROM: $@"
	ndstool -c $@ -9 $< -b $(DEVKITPRO)/libnds/icon.bmp "NDS64;Andhriup;Proyecto DSi"

$(BUILD)/$(OUTPUT).elf: $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

$(BUILD)/%.o: $(SOURCES)/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "Limpiando..."
	rm -rf $(BUILD) $(OUTPUT).nds *.elf *.map
