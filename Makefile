# Public settings
PROJECT_NAME              ?= RGBW-bar
UPLOAD_PORT               ?= /dev/ttyUSB0

# Add the file to be unittested
UNITTEST_SOURCE_FILES_CPP += src/Led.cpp 

# Directories
SOURCE_DIR                := src
BUILD_DIR                 := build
BIN_DIR                   := bin

# File name patterns (operation system dependent)
OBJECT_FILE_PATTERN       := %.o
EXECUTABLE_FILE_PATTERN   := %

FileName                   = $(foreach file,$1,$(dir $(file))$(patsubst %,$2,$(notdir $(basename $(file)))))
ObjectFileName             = $(call FileName,$1,$(OBJECT_FILE_PATTERN))
ExecutableFileName         = $(call FileName,$1,$(EXECUTABLE_FILE_PATTERN))

# Utility functions
wildcard_recursive_1       = $(wildcard $1$2) $(foreach dir,$(wildcard $1*/),$(call wildcard_recursive_1,$(dir),$2))
wildcard_recursive         = $(foreach base_dir,$1,$(call wildcard_recursive_1,$(base_dir),$2))

# Determine Firmware files
FIRMWARE_SOURCE_FILES_CPP := $(wildcard src/*.cpp) # Make recursive
FIRMWARE_SOURCE_FILES_C   := $(wildcard src/*.c)   # Make recursive
FIRMWARE_SOURCE_FILES     := $(FIRMWARE_SOURCE_FILES_CPP) $(FIRMWARE_SOURCE_FILES_C)

FIRMWARE_BUILD_DIR         = $(BUILD_DIR)/firmware
FIRMWARE_OBJECT_FILES      = $(call ObjectFileName, $(addprefix $(FIRMWARE_BUILD_DIR)/, $(FIRMWARE_SOURCE_FILES)))

FIRMWARE_ELF_FILE          = $(BUILD_DIR)/$(PROJECT_NAME).elf
FIRMWARE_HEX_FILE          = $(BIN_DIR)/$(PROJECT_NAME).hex

# Determine Unittest files
UNITTEST_SOURCE_DIRS       = $(call wildcard_recursive,$(SOURCE_DIR)/,unittest/)

UNITTEST_SOURCE_FILES_CPP += $(call wildcard_recursive,$(UNITTEST_SOURCE_DIRS),*.cpp)
UNITTEST_SOURCE_FILES_C   += $(call wildcard_recursive,$(UNITTEST_SOURCE_DIRS),*.c)
UNITTEST_SOURCE_FILES      = $(UNITTEST_SOURCE_FILES_CPP) $(UNITTEST_SOURCE_FILES_C)

UNITTEST_BUILD_DIR         = $(BUILD_DIR)/unittest
UNITTEST_OBJECT_FILES      = $(call ObjectFileName, $(addprefix $(UNITTEST_BUILD_DIR)/, $(UNITTEST_SOURCE_FILES)))

UNITTEST_EXECUTABLE_FILE   = $(call ExecutableFileName, $(BIN_DIR)/$(PROJECT_NAME)_unittest)

# Dependency generation
DEPFLAGS = -MT $@ -MMD -MP -MF $(basename $@).d

# Determine avrdude args
AVRDUDE_ARGS               = -carduino -P$(UPLOAD_PORT) -b57600

# Utility functions
echo_execute = (echo "$1"; $1)
mkdir        = test -d "$1" && exit 0 || mkdir -p $1

# Check needed programs
check_program = $(strip $(if $(shell which $1),some string,$(error "No $(strip $1), please install with: $(strip $2)"))))
K := $(call check_program, avr-gcc, sudo apt install gcc-avr avr-libc)
K := $(call check_program, avrdude, sudo apt install avrdude)

# Public targets
.PHONY: all
.PHONY: firmware
.PHONY: unittest
.PHONY: test
.PHONY: clean
.PHONY: cleanall
.PHONY: upload

all: firmware test

firmware: $(FIRMWARE_HEX_FILE)

unittest: $(UNITTEST_EXECUTABLE_FILE)

test: unittest
	./$(UNITTEST_EXECUTABLE_FILE)

clean:
	@test -d "$(BUILD_DIR)" && rm -r $(BUILD_DIR) || :

cleanall: clean
	@test -d "$(BUILD_DIR)" && rm -r $(BUILD_DIR) || :
	@test -d "$(BIN_DIR)" && rm -r $(BIN_DIR) || :

upload: $(FIRMWARE_HEX_FILE)
	avrdude -p m328p $(AVRDUDE_ARGS) -D -U flash:w:$(FIRMWARE_HEX_FILE)

# Firmware 

$(FIRMWARE_HEX_FILE): $(FIRMWARE_ELF_FILE)
	@$(call mkdir, $(dir $@))
	avr-objcopy -O ihex -j .text -j .data $< $@

$(FIRMWARE_ELF_FILE): $(FIRMWARE_OBJECT_FILES)
	@$(call mkdir, $(dir $@))
	avr-gcc -mmcu=atmega16 $^ -o $@

$(FIRMWARE_BUILD_DIR)/%.o: %.cpp
$(FIRMWARE_BUILD_DIR)/%.o: %.cpp $(FIRMWARE_BUILD_DIR)/%.d
	@$(call mkdir, $(dir $@))
	avr-gcc -c -Wall -Os $(DEPFLAGS) -mmcu=atmega16 $< -o $@

# Unittest
bla:
	@echo $(DEPFILES)

$(UNITTEST_EXECUTABLE_FILE): $(UNITTEST_OBJECT_FILES)
	@$(call mkdir, $(dir $@))
	echo $(UNITTEST_OBJECT_FILES)
	g++ -o $@ $^ /usr/src/gtest/lib/libgtest.a

$(UNITTEST_BUILD_DIR)/%.o: %.cpp
$(UNITTEST_BUILD_DIR)/%.o: %.cpp $(UNITTEST_BUILD_DIR)/%.d
	@$(call mkdir, $(dir $@))
	g++ -c $(DEPFLAGS) -Isrc/unittest/fakeavr -o $@ $< 

DEPFILES := $(UNITTEST_OBJECT_FILES:%.o=%.d)
DEPFILES += $(FIRMWARE_OBJECT_FILES:%.o=%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))
