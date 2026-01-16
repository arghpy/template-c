CFLAGS := -Wall -Wextra -Wpedantic -Werror

SRC   := ./src
BUILD := ./build

SRCS := $(wildcard $(SRC)/*.c)
OBJS := $(SRCS:$(SRC)/%.c=$(BUILD)/%.o)

INCLUDES :=
LIBS     :=

TARGET := $(BUILD)/main

.PHONY: all debug perf run bear clean

# default action. Builds target
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $^ -o $@ $(LIBS)

$(BUILD)/%.o: $(SRC)/%.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

debug: CFLAGS += -ggdb
debug: clean $(TARGET)
	gf2 $(TARGET)

perf: CFLAGS += -O3 -march=native
perf: clean $(TARGET)

run: $(TARGET)
	./$(TARGET)

bear:
	@echo "Creating compile_commands.json..."
	bear -- make -B all

clean:
	@echo "Cleaning..."
	rm -rf $(BUILD)
