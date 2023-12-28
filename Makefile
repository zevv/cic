NAME = cic
PCF = io.pcf

build:
	yosys -p "synth_ice40 -top top -json $(NAME).json" $(NAME).v
	nextpnr-ice40 --up5k --json $(NAME).json --pcf $(PCF) --asc $(NAME).asc
	icepack $(NAME).asc $(NAME).bin

sim: cic.c din.v
	iverilog -o cic.vp test.v cic.v
	vvp cic.vp

din.v: cic.c
	gcc cic.c -o cic -lm && ./cic > din.v

prog: #for sram
	iceprog -S $(NAME).bin

prog_flash:
	iceprog $(NAME).bin

clean:
	rm -rf $(NAME).blif $(NAME).asc $(NAME).bin
