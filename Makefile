NAME := cic

PCF := io.pcf
ASC := $(NAME).asc
BIN := $(NAME).bin
JSON := $(NAME).json
VP := $(NAME).vp
VCD := $(NAME).vcd

SRCS += top.v
SRCS += cic.v


all: $(BIN)

sim: $(VCD)

$(BIN): $(ASC)
	icepack $(NAME).asc $@

$(JSON): $(SRCS)
	yosys -q -p "synth_ice40 -top top -json $(NAME).json" top.v

$(ASC): $(JSON)
	nextpnr-ice40 --quiet --package sg48 --up5k --json $(JSON) --pcf $(PCF) --asc $(ASC)

gui: $(ASC) $(PCF)
	nextpnr-ice40 --quiet --package sg48 --up5k --json $(JSON) --pcf $(PCF) --gui

$(VP): $(SRCS) test.v din.v
	iverilog -Wall -Winfloop -o $(VP) test.v 

$(VCD): $(VP) $(SRCS)
	vvp $(VP)

din.v: cic.c
	gcc -Wall -Werror cic.c -o cic -lm && ./cic > din.v

lint: ${SRCS}
	verilator --lint-only -Wall --timing --top top top.v
	verilator --lint-only -Wall --timing --top test test.v

prog: #for sram
	iceprog -S $(NAME).bin

prog_flash:
	iceprog $(NAME).bin

clean:
	rm -rf $(JSON) $(ASC) $(BIN) din.v $(VP) $(VCD)
