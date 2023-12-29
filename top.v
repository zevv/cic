
`include "cic.v"
`include "doa.v"


module top(input clk, output LED_R, output LED_G, output LED_B, input IOB_8A, input IOB_9B, input IOB_4A);

	wire reset;
	wire [15:0] val[16];

	assign reset = 0;

	wire en_left;
	wire en_right;
	wire en_pcm;
	wire clk_out_pdm;
	audio_clock a1 (reset, clk, clk_out_pdm, en_left, en_right, en_pcm);

	cic c_00 (reset, clk, en_left,  en_pcm, IOB_8A, val[0]);
	cic c_01 (reset, clk, en_right, en_pcm, IOB_8A, val[1]);
	cic c_02 (reset, clk, en_left,  en_pcm, IOB_9B, val[2]);

	assign LED_R = val[0][0];
	assign LED_G = val[1][0];
	assign LED_B = val[2][0];

endmodule

// vi: ft=verilog ts=3 sw=3
