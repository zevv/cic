
//`timescale 1ns / 1ps
`include "cic.v"
`include "doa.v"

module test;

	integer i;

	reg reset = 0;
	initial begin
		# 1 reset = 1;
		# 1 reset = 0;
	end

	initial begin
		# 10 din = 1'dx;
		`include "din.v"
		# 1 $finish();
	end

	reg clk = 0;
	always #1 clk <= !clk;

	wire clk_left;
	wire clk_right;
	wire clk_pcm;
	audio_clock a1 (reset, clk, clk_left, clk_right, clk_pcm);

	wire [15:0] val [15:0];
	reg din;
	cic c_00 (reset, clk_left,  clk_pcm, din, val[0]);
	cic c_01 (reset, clk_right, clk_pcm, din, val[1]);

	doa doa_00 (clk, val[0]);

	initial begin
	   $dumpfile("cic.vcd");
	   $dumpvars(0, test);
		for(i=0; i<16; i=i+1) begin
			$dumpvars(1, val[i]);
		end
	end

endmodule

// vi: ft=verilog ts=3 sw=3
