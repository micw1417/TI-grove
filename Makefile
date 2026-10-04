# ==============================================================
# Makefile for TM4C123G / MSP432 — Multi-board capable
# Toolchain: arm-none-eabi-gcc
# Flash/DBG: OpenOCD + arm-none-eabi-gdb
#
# USAGE:
#   make                          # builds default board (tm4c123g)
#   make TARGET_BOARD=tm4c123g    # explicit TM4C build
#   make TARGET_BOARD=msp432      # MSP432 build (needs its own flags)
#   make flash TARGET_BOARD=tm4c123g
#   make clean TARGET_BOARD=tm4c123g
# ==============================================================

# ==============================================================
# Board Selection — change this default to switch projects
# =================================================c=============
TARGET_BOARD ?= tm4c123g
# The ?= means: use this value UNLESS overridden on the command line
# e.g.  make TARGET_BOARD=msp432  will override it

# Source folder is named after the board
SRC_DIR = $(TARGET_BOARD)

# ==============================================================
# Directories
# ==============================================================
ARM_TOOLCHAIN_DIR  = /c/ti/gcc_arm_none_eabi_9_2_1
ARM_BIN_DIR        = $(ARM_TOOLCHAIN_DIR)/bin
TIVAWARE_DIR = /c/ti/TivaWare_C_Series-2.2.0.295

OPENOCD_DIR        = /c/ti/openocd
OPENOCD_BIN_DIR    = $(OPENOCD_DIR)/bin
OPENOCD_SCRIPTS    = $(OPENOCD_DIR)/share/openocd/scripts

# Build outputs go into board-specific subdirectories
# so tm4c123g and msp432 builds never overwrite each other
BUILD_DIR = build/$(TARGET_BOARD)
OBJ_DIR   = $(BUILD_DIR)/obj
BIN_DIR   = $(BUILD_DIR)/bin

# ==============================================================
# Toolchain Binaries
# ==============================================================
CC      = $(ARM_BIN_DIR)/arm-none-eabi-gcc.exe
GDB     = $(ARM_BIN_DIR)/arm-none-eabi-gdb.exe
OBJCOPY = $(ARM_BIN_DIR)/arm-none-eabi-objcopy.exe
SIZE    = $(ARM_BIN_DIR)/arm-none-eabi-size.exe
RM      = rm

# ==============================================================
# Auto-discover source files from chosen SRC_DIR
# ==============================================================
# find all .c files recursively under the board's source folder
# This means you never have to manually update OBJECTS when
# adding new .c files — just drop them in the folder.
#
# How it works:
#   shell find ... -name "*.c"   → lists all .c paths
#   patsubst SRC_DIR/%.c, OBJ_DIR/%.o, ...  → maps each to its .o path
SRCS    = $(shell find $(SRC_DIR) -name "*.c")
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

# Print discovered sources when running make (helpful for debugging)
$(info >>> TARGET_BOARD : $(TARGET_BOARD))
$(info >>> SRC_DIR      : $(SRC_DIR))
$(info >>> Sources found: $(SRCS))

TARGET  = $(BIN_DIR)/$(TARGET_BOARD)

# ==============================================================
# Compiler Flags
# ==============================================================
CPU_FLAGS  = -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffreestanding

DEFINES    = -DPART_TM4C123GH6PM
DEFINES   += -DTARGET_IS_TM4C123_RB1
DEFINES   += -Dccs=ccs

INCLUDES   = -I$(TIVAWARE_DIR)
INCLUDES  += -I$(SRC_DIR)
# Uncomment if grove headers are in a subdirectory:
# INCLUDES  += -I$(SRC_DIR)/grove

OPT_FLAGS  = -Og    # -Og = optimize for debugging (better than -O2 in debug builds)
DBG_FLAGS  = -g
SECTION_FLAGS = -ffunction-sections -fdata-sections
WFLAGS     = -Wall -Wextra -Wno-missing-declarations

CFLAGS  = $(CPU_FLAGS) $(DEFINES) $(INCLUDES)
CFLAGS += $(OPT_FLAGS) $(DBG_FLAGS) $(SECTION_FLAGS) $(WFLAGS)


LINKER_SCRIPT = linker/tm4c123g.ld

# ==============================================================
# Linker Flags
# ==============================================================
LDFLAGS    = $(CPU_FLAGS)
LDFLAGS   += -T$(LINKER_SCRIPT)
LDFLAGS   += -Wl,--entry,ResetISR
LDFLAGS   += -Wl,--gc-sections
LDFLAGS   += -Wl,--defsym,__STACK_SIZE=512
LDFLAGS   += -Wl,--defsym,__HEAP_SIZE=0
LDFLAGS   += -Wl,--print-memory-usage
LDFLAGS   += -Wl,-Map=$(BIN_DIR)/$(TARGET_BOARD).map

# Libraries — MUST come after object files in link order.
# GNU ld scans left-to-right: objects must appear before the
# libraries that satisfy their undefined references.
# Putting -ldriver before $^ means ld discards it before seeing
# any .o that needs GPIOPinWrite, SysCtlDelay etc.
LDLIBS     = -L$(TIVAWARE_DIR)/driverlib/gcc -ldriver
# ==============================================================
# Build Rules
# ==============================================================

# Pattern rule — works for any depth of subdirectory under SRC_DIR
# e.g. tm4c123g/grove/grove_buzzer.c → build/tm4c123g/obj/grove/grove_buzzer.o
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET).elf: $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@
	@$(SIZE) $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# ==============================================================
# Phony Targets
# ==============================================================
.PHONY: all clean flash debug size

all: $(TARGET).elf $(TARGET).bin

size: $(TARGET).elf
	$(SIZE) --format=berkeley $<

clean:
	$(RM) -rf $(BUILD_DIR)
flash: $(TARGET).elf
	@taskkill //F //IM openocd.exe 2>/dev/null || true
	@echo "Flashing $(TARGET).elf ..."
	$(OPENOCD_BIN_DIR)/openocd.exe \
	    -s "$(OPENOCD_SCRIPTS)" \
	    -f board/ti_ek-tm4c123gxl.cfg \
	    -c "program $(TARGET).elf verify reset exit"
	@echo "Flash complete!"

debug: $(TARGET).elf
	@taskkill //F //IM openocd.exe 2>/dev/null || true
	@sleep 1
	@echo "Starting OpenOCD GDB server on :3333 ..."
	@$(OPENOCD_BIN_DIR)/openocd.exe \
	    -s "$(OPENOCD_SCRIPTS)" \
	    -f board/ti_ek-tm4c123gxl.cfg \
	    -c "tcl_port disabled" \
	    -c "telnet_port disabled" \
	    -c "gdb_port 3333" &
	@sleep 3
	$(GDB) \
	    -ex "set confirm off" \
	    -ex "target remote localhost:3333" \
	    -ex "monitor reset halt" \
	    -ex "load" \
	    $(TARGET).elf