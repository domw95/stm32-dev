# Target binary name
TARGET = main
ELF = $(TARGET).elf
# Compiler and tools
CC = arm-none-eabi-gcc
SZ = arm-none-eabi-size
CP = arm-none-eabi-objcopy

# Path to build to 
BUILD_DIR = build

# C source files
SOURCES = $(wildcard src/*.c) \
			cmsis_device_f7/Source/Templates/system_stm32f7xx.c
OBJECTS = $(SOURCES:%.c=$(BUILD_DIR)/%.o)
# C header dirs
INCLUDE_DIRS = inc/ \
			stm32f7xx_hal_driver/Inc \
			cmsis_device_f7/Include \
			cmsis_core/Include \
			$(wildcard cmsis_core/*/Include)
INCLUDES = $(addprefix -I,$(INCLUDE_DIRS))

AMS_SOURCES = $(wildcard asm/*.s)
OBJECTS += $(AMS_SOURCES:%.s=$(BUILD_DIR)/%.o)

# Flags
CPU = -mcpu=cortex-m7
FPU = -mfpu=fpv5-sp-d16
FLOAT-ABI = -mfloat-abi=hard
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

DEFS = -DSTM32F746xx

# Flags to generate dependencies for each source file
DEPS = -MMD -MP -MF"$(@:%.o=%.d)"

# flags for compiling C source to objects
CFLAGS = $(MCU) $(DEFS) $(INCLUDES) $(DEPS) -nostdlib
# Place each item into its own section
CFLAGS += -fdata-sections -ffunction-sections -g
# All warnings
CFLAGS += -Wall

# Path to linker script
LDSCRIPT = STM32F746ZGTx_FLASH.ld

# Libraries
# -lc = libc
# -ln = libm (math)
LIBS = -lnosys -lc -lm
# Linker flags
# -lnosys
LDFLAGS = -T$(LDSCRIPT) $(MCU) $(LIBS) --specs=nosys.specs 
# --specs=nosys.specs -lnosys

# Main build 
$(BUILD_DIR)/$(ELF): $(OBJECTS)
	@echo Building main target
	$(CC) $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

# Compile objects
# Creates intermediate directories then compiles source c to object
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	mkdir -p $(@D)
	$(CC) $< $(CFLAGS) -c -o $@

$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	mkdir -p $(@D)
	$(CC) $< -c -o $@

# Make the build directory
$(BUILD_DIR):
	mkdir $@


print:
	@echo Sources: $(SOURCES)
	@echo Includes: $(INCLUDES)
	@echo Objects: $(OBJECTS)

clean:
	rm -rf $(BUILD_DIR)/*