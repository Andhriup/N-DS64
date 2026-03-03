.SUFFIXES:
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

TARGET   := N-DS64
BUILD    := build
SOURCES  := source gfx
INCLUDES   := include
DATA   := data
GRAPHICS   := gfx
CALICO   := $(DEVKITPRO)/calico
ICON := icon.png

ARCH    :=    -march=armv5te -mtune=arm946e-s -mthumb -D__NDS__ -D__NDSi__

CFLAGS  := -g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH) -DARM9 -DARM9i
CFLAGS  +=  -MMD -MP $(INCLUDE)

CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS    :=    -g $(ARCH)
LDFLAGS        =        -specs=dsi_arm9.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

LIBS    := -lnds9 -lcalico_ds9 -lc

LIBDIRS    :=    $(LIBNDS) $(CALICO)

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT    :=    $(CURDIR)/$(TARGET)

export VPATH    :=    $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) $(CURDIR) $(CURDIR)/$(subst /,,$(dir $(ICON)))
export DEPSDIR    :=    $(CURDIR)/$(BUILD)

CFILES      :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.c)))
CPPFILES    :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.cpp)))
SFILES      :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.s)))
PNGFILES := $(foreach dir,$(GRAPHICS),$(notdir $(wildcard $(dir)/*.png)))
BINFILES    :=    $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.bin)))

ifeq ($(strip $(CPPFILES)),)

    export LD    :=    $(CC)
else
    export LD    :=    $(CXX)
endif

export OFILES   := $(BINFILES)\
                   $(PNGFILES:.png=.o)\
                   $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
           -I$(LIBNDS)/include \
           -I$(CALICO)/include \
           -I$(BUILD)

export LIBPATHS    :=    $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

ifeq ($(strip $(ICON)),)
  icons := $(wildcard *.bmp)

  ifneq (,$(findstring $(TARGET).bmp,$(icons)))
    export GAME_ICON := $(CURDIR)/$(TARGET).bmp
  else
    ifneq (,$(findstring icon.bmp,$(icons)))
      export GAME_ICON := $(CURDIR)/icon.bmp
    endif
  endif
else
  ifeq ($(suffix $(ICON)), .grf)
    export GAME_ICON := $(CURDIR)/$(ICON)
  else
    export GAME_ICON := $(CURDIR)/$(BUILD)/$(notdir $(basename $(ICON))).grf
  endif
endif

.PHONY: $(BUILD) clean
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds $(TARGET).ds.gba

else
DEPENDS        :=        $(OFILES:.o=.d)

$(OUTPUT).nds	:	$(OUTPUT).elf $(GAME_ICON)
	ndstool -c $@ -9 $< -7 $(CALICO)/bin/ds7_maine.elf -b $(GAME_ICON) "N-DS64;Proyecto DSi;AI"

$(OUTPUT).elf	:	$(OFILES)
	@echo Enlazando $(notdir $@) 
	$(LD) $(LDFLAGS) $(LIBPATHS) -o $@ $(OFILES) -Wl,--start-group $(LIBS) -Wl,--end-group
	
$(GAME_ICON) : $(notdir $(ICON))
	@echo convert $(notdir $<)
	@grit $< -g -gt -gB4 -gT FF00FF -m! -p -pe 16 -fh! -ftr

%.o : %.c
	@echo $(notdir $<)
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@


%.o : %.cpp
	@echo $(notdir $<)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

%.o : %.bin
	@echo $(notdir $<)
	@bin2s $< | $(AS) $(ASFLAGS) -o $@

%.s %.h : %.png %.grit

	grit $< -fts -o$*

-include $(DEPENDS)

endif