
//`timescale 1ns / 1ps
`include "main.v"

module test(output clk_out_pdm);

	integer i;

	reg reset = 0;
	initial begin
		# 1 reset = 1;
		# 1 reset = 0;
	end

	initial begin
		# 3
		`include "din.v"
		# 1 $finish();
	end

	reg clk = 0;
	always #1 clk <= !clk;

	reg [7:0] din;
	wire hop;
	main main(reset, clk, clk_out_pdm, din, hop);

	initial begin
	   $dumpfile("cic.vcd");
	   $dumpvars(0, test);
		for(i=0; i<16; i=i+1) begin $dumpvars(1, test.main.val[i]); end
	end

endmodule

// vi: ft=verilog ts=3 sw=3
