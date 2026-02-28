#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
#---------------------------------------------------------------------------------
TARGET       := 'N$DS64'
BUILD        := build
SOURCES      := source gfx
INCLUDES     := include
DATA         := data
GRAPHICS     := gfx
#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH        :=        -march=armv5te -mtune=arm946e-s -mthumb

CFLAGS  := -g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH) -DARM9 $(INCLUDE)

CPPFLAGS := $(CFLAGS)

CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS        :=        -g $(ARCH)
LDFLAGS        =        -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS        := -lnds9


#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS        :=        $(LIBNDS)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT        :=        $(CURDIR)/$(TARGET)

export VPATH        :=        $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) $(CURDIR)
export DEPSDIR        :=        $(CURDIR)/$(BUILD)

CFILES                :=        $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.c)))
CPPFILES        :=        $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.cpp)))
SFILES                :=        $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.s)))
BINFILES        :=        $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.bin)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
        export LD        :=        $(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
        export LD        :=        $(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export OFILES        :=        $(BINFILES:.bin=.o) \
                                        $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export INCLUDE        :=        $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                                        $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                                        -I$(CURDIR)/$(BUILD)

export LIBPATHS        :=        $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean

#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds $(TARGET).ds.gba

else

DEPENDS	:=	$(OFILES:.o=.d)

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
	@echo Compilando $(notdir $<)
	$(CC) $(CPPFLAGS) $(INCLUDE) -c $< -o $@

%.o : %.cpp
	@echo Compilando $(notdir $<)
	$(CXX) $(CXXFLAGS) -$(INCLUDE) -c $< -o $@

%.o : %.bin
	@echo Procesando binario $(notdir $<)
	$(bin2o)

-include $(DEPENDS)

endif

#---------------------------------------------------------------------------------------