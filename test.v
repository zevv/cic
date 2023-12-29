
//`timescale 1ns / 1ps
`include "cic.v"

module test;

	reg reset = 0;
	initial begin
		# 1 reset = 1;
		# 2 reset = 0;
	end

	initial begin
		# 10 din = 1'dx;
		`include "din.v"
		# 1 $finish();
	end

	reg clk = 0;
	always #1 clk = !clk;

	wire clk_left;
	wire clk_right;
	wire clk_pcm;
	audio_clock a1 (reset, clk, clk_left, clk_right, clk_pcm);

	wire [15:0] val_l;
	wire [15:0] val_r;
	reg din;
	cic cl (reset, clk_left,  clk_pcm, din, val_l);
	cic cr (reset, clk_right, clk_pcm, din, val_r);

	initial begin
	   $dumpfile("cic.vcd");
	   $dumpvars(0, test);
	end

endmodule

// vi: ft=verilog ts=3 sw=3
