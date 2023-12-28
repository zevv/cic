
`include "cic.v"


module top(input [3:0] SW, input clk);

	wire reset;
	wire din;
	wire [23:0] val;

	assign din = SW[1];
	assign reset = SW[0];

	cic c1 (reset, clk, din, val);

endmodule
