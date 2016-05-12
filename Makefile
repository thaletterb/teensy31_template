#  Teensy 3.1 Project Makefile
#  Karl Lunt
#  with modifications by Kevin Cuzner
#  and Brian V 
#  
#  5/11/16:
#  	- Add project directory structure:
#  		- Implemented making all .o files in .obj subdir
#  5/15/15:
#  	- First working build. 
#  		- Changed TOOLPATH, BASEPATH and TEENSYDIR to point to appropriate local locations
#

#  Project Name
PROJECT=blinky

#  Project directory structure
SRCDIR = src
OUTPUTDIR = bin
OBJDIR = obj

#  Type of CPU/MCU in target hardware
CPU = cortex-m4

#  Build the list of object files needed.  All object files will be built in
#  the working directory, not the source directories.
#
#  You will need as a minimum your $(PROJECT).o file.
#  You will also need code for startup (following reset) and
#  any code needed to get the PLL configured.
OBJECTS	+= $(PROJECT).o \
	       sysinit.o \
	       crt0.o

#  Select the toolchain by providing a path to the top level
#  directory; this will be the folder that holds the
#  arm-none-eabi subfolders.
#  BV - Change this to local toolchain directory
#  Default: TOOLPATH = /home/brian/arduino-1.0.6/arduino-1.0.6/hardware/tools
TOOLPATH = /home/brian/arduino-1.0.6/arduino-1.0.6/hardware/tools/arm-none-eabi

#  Provide a base path to your Teensy firmware release folder.
#  This is the folder containing all of the Teensy source and
#  include folders.  For example, you would expand any Freescale
#  example folders (such as common or include) and place them
#  here.
#  BV - Change this to the local basepath directory, where the common and include files live
TEENSY3X_BASEPATH = /home/brian/Projects/teensy/teensy31/teensy_basepath

#
# SOME ADDITIONAL TEENSY VARS
# BV 2/2/15
#
TEENSYDIR = /home/brian/arduino-1.0.6/arduino-1.0.6/hardware

#  Select the target type.  This is typically arm-none-eabi.
#  If your toolchain supports other targets, those target
#  folders should be at the same level in the toolchain as
#  the arm-none-eabi folders.
TARGETTYPE = arm-none-eabi

#  Describe the various include and source directories needed.
#  These usually point to files from whatever distribution
#  you are using (such as Freescale examples).  This can also
#  include paths to any needed GCC includes or libraries.
TEENSY3X_INC     = $(TEENSY3X_BASEPATH)/include
GCC_INC          = $(TOOLPATH)/$(TARGETTYPE)/include


#  All possible source directories other than '.' must be defined in
#  the VPATH variable.  This lets make tell the compiler where to find
#  source files outside of the working directory.  If you need more
#  than one directory, separate their paths with ':'.
VPATH = $(TEENSY3X_BASEPATH)/common

				
#  List of directories to be searched for include files during compilation
INCDIRS  = -I$(GCC_INC)
INCDIRS += -I$(TEENSY3X_INC)
INCDIRS += -I.


# Name and path to the linker script
LSCRIPT = $(TEENSY3X_BASEPATH)/common/Teensy31_flash.ld


OPTIMIZATION = 0
DEBUG = -g

#  List the directories to be searched for libraries during linking.
#  Optionally, list archives (libxxx.a) to be included during linking. 
LIBDIRS  = -L"$(TOOLPATH)\$(TARGETTYPE)\lib"
LIBS =

#  Compiler options
GCFLAGS = -Wall -fno-common -mcpu=$(CPU) -mthumb -O$(OPTIMIZATION) $(DEBUG)
GCFLAGS += $(INCDIRS)

# You can uncomment the following line to create an assembly output
# listing of your C files.  If you do this, however, the sed script
# in the compilation below won't work properly.
# GCFLAGS += -c -g -Wa,-a,-ad 


#  Assembler options
ASFLAGS = -mcpu=$(CPU)

# Uncomment the following line if you want an assembler listing file
# for your .s files.  If you do this, however, the sed script
# in the assembler invocation below won't work properly.
#ASFLAGS += -alhs


#  Linker options
LDFLAGS  = -nostdlib -nostartfiles -Map=$(PROJECT).map -T$(LSCRIPT)
LDFLAGS += --cref
LDFLAGS += $(LIBDIRS)
LDFLAGS += $(LIBS)


#  Tools paths
#
#  Define an explicit path to the GNU tools used by make.
#  If you are ABSOLUTELY sure that your PATH variable is
#  set properly, you can remove the BINDIR variable.
#
BINDIR = $(TOOLPATH)/bin

CC = $(BINDIR)/arm-none-eabi-gcc
AS = $(BINDIR)/arm-none-eabi-as
AR = $(BINDIR)/arm-none-eabi-ar
LD = $(BINDIR)/arm-none-eabi-ld
OBJCOPY = $(BINDIR)/arm-none-eabi-objcopy
SIZE = $(BINDIR)/arm-none-eabi-size
OBJDUMP = $(BINDIR)/arm-none-eabi-objdump

#  Define a command for removing folders and files during clean.  The
#  simplest such command is Linux' rm with the -f option.  You can find
#  suitable versions of rm on the web.
REMOVE = rm -f


#########################################################################

all:: $(PROJECT).hex $(PROJECT).bin stats dump

$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary -j .text -j .data $(PROJECT).elf $(PROJECT).bin

$(PROJECT).hex: $(PROJECT).elf
	$(OBJCOPY) -R .stack -O ihex $(PROJECT).elf $(PROJECT).hex

#  Linker invocation
$(PROJECT).elf: $(OBJECTS)
	#$(LD) $(OBJDIR)/$(OBJECTS) $(LDFLAGS) -o $(PROJECT).elf
	$(LD) $(OBJDIR)/*.o $(LDFLAGS) -o $(PROJECT).elf


stats: $(PROJECT).elf
	$(SIZE) $(PROJECT).elf
	
dump: $(PROJECT).elf
	$(OBJDUMP) -h $(PROJECT).elf	

program:: $(PROJECT).hex $(PROJECT).bin stats dump load

load: $(PROJECT).elf
	$(OBJCOPY) -O ihex -R .eeprom $(PROJECT).elf $(PROJECT).hex
	$(TEENSYDIR)/tools/teensy_post_compile -file=$(PROJECT) -path=$(shell pwd) -tools=$(TEENSYDIR)/tools
	$(TEENSYDIR)/tools/teensy_reboot

clean:
	$(REMOVE) $(OBJDIR)/*.o
	$(REMOVE) $(PROJECT).hex
	$(REMOVE) $(PROJECT).elf
	$(REMOVE) $(PROJECT).map
	$(REMOVE) $(PROJECT).bin
	$(REMOVE) *.lst

#  The toolvers target provides a sanity check, so you can determine
#  exactly which version of each tool will be used when you build.
#  If you use this target, make will display the first line of each
#  tool invocation.
#  To use this feature, enter from the command-line:
#    make -f $(PROJECT).mak toolvers
toolvers:
	$(CC) --version | sed q
	$(AS) --version | sed q
	$(LD) --version | sed q
	$(AR) --version | sed q
	$(OBJCOPY) --version | sed q
	$(SIZE) --version | sed q
	$(OBJDUMP) --version | sed q
	
#########################################################################
#  Default rules to compile .c and .cpp file to .o
#  and assemble .s files to .o

#  There are two options for compiling .c files to .o; uncomment only one.
#  The shorter option is suitable for making from the command-line.
#  The option with the sed script on the end is used if you want to
#  compile from Visual Studio; the sed script reformats error messages
#  so Visual Studio's IntelliSense feature can track back to the source
#  file with the error.
.c.o :
	@echo Compiling $<, writing to $@...
#	$(CC) $(GCFLAGS) -c $< -o $@ > $(basename $@).lst
	$(CC) $(GCFLAGS) -c $< -o $(OBJDIR)/$@ 2>&1 | sed -e 's/\(\w\+\):\([0-9]\+\):/\1(\2):/'
    
.cpp.o :
	@echo Compiling $<, writing to $@...
	$(CC) $(GCFLAGS) -c $<

#  There are two options for assembling .s files to .o; uncomment only one.
#  The shorter option is suitable for making from the command-line.
#  The option with the sed script on the end is used if you want to
#  compile from Visual Studio; the sed script reformats error messages
#  so Visual Studio's IntelliSense feature can track back to the source
#  file with the error.
.s.o :
	@echo Assembling $<, writing to $@...
#	$(AS) $(ASFLAGS) -o $@ $<  > $(basename $@).lst
	$(AS) $(ASFLAGS) -o $(OBJDIR)/$@ $<  2>&1 | sed -e 's/\(\w\+\):\([0-9]\+\):/\1(\2):/'
#########################################################################

