# Config
SRC_DIRS := src/required src/program
TAR_DIR := build_garbage
ELF := final.elf

# Gather all source files
SRC := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.s))

# Map to object files (flattened)
TAR := $(addprefix $(TAR_DIR)/, $(notdir $(SRC:.s=.o)))

.PHONY: all flash clean

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

flash: $(ELF)
	sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "adapter speed 5000" -c "program $(ELF) verify reset exit"

debug: $(ELF)
	@echo "Caching Root Password"; \
	sudo -v || exit $$?; \
	echo "Starting OpenOCD..."; \
	sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "adapter speed 5000" & \
	OCD_PID=$$!; \
	sleep 1; \
	echo "Starting GDB..."; \
	gdb -ex "target remote localhost:3333" $<; \
	echo "Killing OpenOCD..."; \
	sudo kill $$OCD_PID

# Clean build files
clean:
	rm -rf $(TAR_DIR)
	rm -f $(ELF)
