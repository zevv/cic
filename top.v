
`include "cic.v"


module top(input clk, output LED_R, output LED_G, output LED_B, input IOB_8A, input IOB_9B, input IOB_4A);

	wire reset;
	wire din;
	wire [15:0] val_00;
	wire [15:0] val_01;
	wire [15:0] val_02;

	assign reset = 0;

	wire clk_left;
	wire clk_right;
	wire clk_pcm;
	audio_clock a1 (reset, clk, clk_left, clk_right, clk_pcm);

	cic c_00 (reset, clk_left,  clk_pcm, IOB_8A, val_00);
	cic c_01 (reset, clk_right, clk_pcm, IOB_9B, val_01);
	cic c_02 (reset, clk_left,  clk_pcm, IOB_4A, val_02);

	assign LED_R = val_00[0];
	assign LED_G = val_01[0];
	assign LED_B = val_02[0];

endmodule

// vi: ft=verilog ts=3 sw=3
