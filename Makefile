PROJECT_NAME = RGBW-bar

OBJECT_FILE_PATTERN      = %.o
EXECUTABLE_FILE_PATTERN  = %

BUILD_DIR                = build
BIN_DIR                  = bin
FIRMWARE_SOURCE_DIR      = src
UNITTEST_SOURCE_DIR      = unittest

FIRMWARE_BUILD_DIR       = $(BUILD_DIR)/$(FIRMWARE_SOURCE_DIR)
FIRMWARE_SOURCE_FILES    = $(wildcard $(FIRMWARE_SOURCE_DIR)/*.cpp)
FIRMWARE_OBJECT_FILES    = $(call ObjectName, $(patsubst $(FIRMWARE_SOURCE_DIR)/%.cpp,$(FIRMWARE_BUILD_DIR)/%,$(FIRMWARE_SOURCE_FILES)))
FIRMWARE_ELF_FILE        = $(FIRMWARE_BUILD_DIR)/$(PROJECT_NAME).elf
FIRMWARE_HEX_FILE        = $(BIN_DIR)/$(PROJECT_NAME).hex

UNITTEST_BUILD_DIR       = $(BUILD_DIR)/$(UNITTEST_SOURCE_DIR)
UNITTEST_SOURCE_FILES    = $(wildcard $(UNITTEST_SOURCE_DIR)/*.cpp)
#UNITTEST_SOURCE_FILES   += $(FIRMWARE_SOURCE_FILES)
UNITTEST_OBJECT_FILES    = $(call ObjectName, $(patsubst %.cpp,$(UNITTEST_BUILD_DIR)/%,$(UNITTEST_SOURCE_FILES)))
UNITTEST_EXECUTABLE_FILE = $(call ExecutableName, $(BIN_DIR)/unittest)

bla:
	echo $(UNITTEST_OBJECT_FILES)

# Utility functions

FileName                 = $(foreach file,$1,$(dir $(file))$(patsubst %,$2,$(notdir $(basename $(file)))))
ObjectName               = $(call FileName,$1,$(OBJECT_FILE_PATTERN))
ExecutableName           = $(call FileName,$1,$(EXECUTABLE_FILE_PATTERN))

# Check needed programs
check_program = $(strip $(if $(shell which $1),some string,$(error "No $(strip $1), please install with: $(strip $2)"))))
K := $(call check_program, avr-gcc, sudo apt install gcc-avr avr-libc)

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
	avrdude -p m328p -carduino -P/dev/ttyUSB0 -b57600 -D -U flash:w:$(FIRMWARE_HEX_FILE)

# Firmware 

$(FIRMWARE_HEX_FILE): $(FIRMWARE_ELF_FILE)
	avr-objcopy -O ihex -j .text -j .data $< $@

$(FIRMWARE_ELF_FILE): $(FIRMWARE_OBJECT_FILES) | mkdir_$(dir $(FIRMWARE_HEX_FILE))
	avr-gcc -mmcu=atmega16 $^ -o $@

$(FIRMWARE_BUILD_DIR)/%.o: $(FIRMWARE_SOURCE_DIR)/%.cpp | mkdir_$(FIRMWARE_BUILD_DIR)/
	avr-gcc -c -Wall -Os -mmcu=atmega16 $< -o $@

# Unittest

$(UNITTEST_EXECUTABLE_FILE): $(UNITTEST_OBJECT_FILES) | mkdir_$(BIN_DIR)/
	g++ -o $@ $< /usr/src/gtest/lib/libgtest.a

$(UNITTEST_BUILD_DIR)/%.o: %.cpp | mkdir_$(dir $(UNITTEST_BUILD_DIR)/%)
	g++ -c -o $@ $< 

# Utility targets

.PHONY: mkdir_%/

mkdir_%/:
	@test -d "$*" && exit 0 || (echo "mkdir -p $*"; mkdir -p $*)
