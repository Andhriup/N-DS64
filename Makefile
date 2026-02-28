.SUFFIXES:
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

TARGET   := 'N$DS64'
BUILD    := build
SOURCES  := source gfx
INCLUDES   := include
DATA   := data
GRAPHICS   := gfx

ARCH    :=    -march=armv5te -mtune=arm946e-s -mthumb

CFLAGS  := -g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH) -DARM9

CFLAGS  += $(INCLUDE) 

CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS    :=    -g $(ARCH)
LDFLAGS    =    -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

LIBS    := -lnds9

LIBDIRS    :=    $(LIBNDS)

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT    :=    $(CURDIR)/$(TARGET)

export VPATH    :=    $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) $(CURDIR)
export DEPSDIR    :=    $(CURDIR)/$(BUILD)

CFILES      :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.c)))
CPPFILES    :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.cpp)))
SFILES      :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.s)))
BINFILES    :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.bin)))

ifeq ($(strip $(CPPFILES)),)

    export LD    :=    $(CC)
else
    export LD    :=    $(CXX)
endif

export OFILES    :=    $(BINFILES:.bin=.o) \
              $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export INCLUDE        :=        $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                                        $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                                        -I$(DEVKITPRO)/calico/
                                        -I$(CURDIR)/$(BUILD)

export LIBPATHS    :=    $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds $(TARGET).ds.gba

else
DEPENDS        :=        $(OFILES:.o=.d)

#--- Reglas Principales ---
$(OUTPUT).nds	:	$(OUTPUT).elf icon.bmp
	ndstool -c $@ -9 $< -7 "$(DEVKITPRO)/calico/bin/ds7_sphynx.elf" -b icon.bmp "NS64;Andhriup;Proyecto DSi"

$(OUTPUT).elf	:	$(OFILES)
	@echo Enlazando $(notdir $@)
	$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@

icon.bmp : ../icon.png
	grit ../icon.png -g -gb -gB4 -gz0 -p -ftb -fh! -o icon.bmp

#--- Reglas de Compilación ---
%.o : %.c
	@echo $(notdir $<)
	$(CC) $(CFLAGS) -c $< -o $@

%.o : %.cpp
	@echo $(notdir $<)
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o : %.bin
	@echo $(notdir $<) $bin2o)

-include $(DEPENDS)

endif