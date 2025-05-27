# All Variables
SRC_DIRS = src/required src/program
SRC = $(foreach dir, $(SRC_DIRS), $(wildcard $(dir)/*.s))
TAR_DIR = build_garbage
TAR = $(foreach file, $(notdir $(SRC)), $(TAR_DIR)/$(file:.s=.o))
ELF = final.elf

# Mark which targets are not files
.PHONY: all clean

# Make the elf file
all: $(ELF)

# dynamically make the object files
$(TAR_DIR)/%.o :
	@mkdir -p $(dir $@)
	arm-none-eabi-as -mcpu=cortex-m0plus -mthumb --warn src/*/$*.s -o $@

# make the final elf file
$(ELF) : $(TAR)
	arm-none-eabi-ld -T src/linker/pico_linker.ld -Map=$(TAR_DIR)/final.map -o $@ $^

clean:
	rm -rf $(TAR_DIR)
	rm -f $(ELF)
