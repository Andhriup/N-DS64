# --- Nombre del proyecto ---
TARGET      := NDS64
# Usamos un nombre de archivo seguro para el binario final
OUTPUT      := NDS64

# --- Directorios ---
BUILD       := build
SOURCES     := source
INCLUDES    := include
GRAPHICS    := gfx

# --- Configuración devkitARM ---
ifeq ($(strip $(DEVKITARM)),)
$(error "DEVKITARM no está definido. Revisa tu instalación.")
endif

include $(DEVKITARM)/ds_rules

# --- Flags y Librerías ---
ARCH    := -mthumb -mthumb-interwork
CFLAGS  := -g -Wall -O2 $(ARCH) -D__NDS__ -I$(INCLUDES)
LDFLAGS := -g $(ARCH) -Wl,-Map,$(BUILD)/$(OUTPUT).map
LIBS    := -libnds

# --- Objetos ---
CFILES		:= $(wildcard $(SOURCES)/*.c)
OBJS		:= $(CFILES:$(SOURCES)/%.c=$(BUILD)/%.o)

.PHONY: all clean

all: $(OUTPUT).nds

# Empaquetado final para DSi/DS
$(OUTPUT).nds: $(BUILD)/$(OUTPUT).elf
	@echo "Generando ROM: $@"
	@ndstool -c $@ -9 $< "N$$DS64;Andhriup;Proyecto DSi"

$(BUILD)/$(OUTPUT).elf: $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

$(BUILD)/%.o: $(SOURCES)/%.c
	@mkdir -p $(BUILD)
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "Limpiando..."
	@rm -rf $(BUILD) $(OUTPUT).nds