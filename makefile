SRC_DIRS = src/required src/program
SRC = $(foreach dir, $(SRC_DIRS), $(wildcard $(dir)/*.s))
TAR = $(foreach file, $(notdir $(SRC)), built_object_files/$(file:.s=.o))

all: $(TAR)

built_object_files/%.o :
	@mkdir -p $(dir $@)
	arm-none-eabi-as -mcpu=cortex-m0plus -mthumb --warn src/*/$*.s -o $@

clean:
	rm -f $(TAR)
