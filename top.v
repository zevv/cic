
`include "cic.v"
`include "doa.v"


module top(input clk, output LED_R, output LED_G, output LED_B, input IOB_8A, input IOB_9B, input IOB_4A);

	wire reset;
	wire [15:0] val[16];

	assign reset = 0;

	wire clk_left;
	wire clk_right;
	wire clk_pcm;
	audio_clock a1 (reset, clk, clk_left, clk_right, clk_pcm);

	cic c_00 (reset, clk_left,  clk_pcm, IOB_8A, val[0]);
	cic c_01 (reset, clk_right, clk_pcm, IOB_9B, val[1]);
	cic c_02 (reset, clk_left,  clk_pcm, IOB_4A, val[2]);
	
	doa doa_00 (clk, val[0]);

	assign LED_R = val[0][0];
	assign LED_G = val[1][0];
	assign LED_B = val[2][0];

endmodule

// vi: ft=verilog ts=3 sw=3
