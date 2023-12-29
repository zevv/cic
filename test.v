
//`timescale 1ns / 1ps
`include "cic.v"

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

	wire en_left;
	wire en_right;
	wire en_pcm;
	audio_clock a1 (reset, clk, clk_out_pdm, en_left, en_right, en_pcm);

	/* verilator lint_off UNUSEDSIGNAL */
	wire [15:0] val [15:0];
	/* verilator lint_on UNUSEDSIGNAL */

	reg din[15:0];
	cic c_00 (reset, clk, en_left,  en_pcm, din[0], val[0]);
	cic c_01 (reset, clk, en_right, en_pcm, din[0], val[1]);
	cic c_02 (reset, clk, en_left,  en_pcm, din[1], val[2]);
	cic c_03 (reset, clk, en_right, en_pcm, din[1], val[3]);


	initial begin
	   $dumpfile("cic.vcd");
	   $dumpvars(0, test);
		for(i=0; i<16; i=i+1) begin $dumpvars(1, val[i]); end
		for(i=0; i<8; i=i+1) begin $dumpvars(1, din[i]); end
	end

endmodule

// vi: ft=verilog ts=3 sw=3
