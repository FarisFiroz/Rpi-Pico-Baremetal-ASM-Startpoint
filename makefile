# Config
SRC_DIRS := src/required src/program
TAR_DIR := build_garbage
ELF := final.elf

# Gather all source files
SRC := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.s))

# Map to object files (flattened)
TAR := $(addprefix $(TAR_DIR)/, $(notdir $(SRC:.s=.o)))

.PHONY: all clean

# Default target
all: $(ELF)

# Compile each source into a flattened object file
$(TAR_DIR)/%.o: $(SRC)
	@mkdir -p $(dir $@)
	arm-none-eabi-as -mcpu=cortex-m0plus -mthumb --warn $(filter %/$*.s, $(SRC)) -o $@

# Link object files into final ELF
$(ELF): $(TAR)
	@mkdir -p $(TAR_DIR)
	arm-none-eabi-ld -T src/linker/pico_linker.ld -Map=$(TAR_DIR)/final.map -o $@ $^

# Clean build files
clean:
	rm -rf $(TAR_DIR)
	rm -f $(ELF)
