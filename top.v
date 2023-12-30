
`include "main.v"


module top(input clk, output LED_R, output LED_G, output LED_B,
	input IOB_8A,
	input IOB_9B,
	input IOB_4A,
	input IOB_18A,
	input IOB_20A,
	input IOB_22A,
	input IOB_23B,
	input IOB_24A);


	wire reset;
	assign reset = 0;

	wire clk_out_pdm;

	wire [7:0] din;
	assign din = { IOB_9B, IOB_8A, IOB_4A, IOB_18A, IOB_20A, IOB_22A, IOB_23B, IOB_24A };

	wire hop;

	main main(reset, clk, clk_out_pdm, din, hop);

	assign LED_R = clk_out_pdm;
	assign LED_G = hop;
	assign LED_B = 0;

endmodule

// vi: ft=verilog ts=3 sw=3
