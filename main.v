`include "cic.v"

module main (input reset, input clk, output clk_out_pdm, input [7:0] din, output hop);

	wire en_left;
	wire en_right;
	wire en_pcm;
	audio_clock a1 (reset, clk, clk_out_pdm, en_left, en_right, en_pcm);

	/* verilator lint_off UNUSEDSIGNAL */
	wire [15:0] val [15:0];
	/* verilator lint_on UNUSEDSIGNAL */

	generate
		genvar i;
		for (i=0; i<8; i=i+1) begin
			cic cic0 (reset, clk, en_left,  en_pcm, din[i], val[i*2+0]);
			cic cic1 (reset, clk, en_right, en_pcm, din[i], val[i*2+1]);
		end
	endgenerate


	reg [15:0] val_0[7:0];
	reg [15:0] val_1[7:0];
	reg [15:0] val_2[7:0];
	reg [15:0] val_3[7:0];
	reg [15:0] val_4[7:0];
	reg [15:0] val_5[7:0];
	reg [15:0] val_6[7:0];
	reg [15:0] val_7[7:0];


	always @(posedge clk) begin
		if (en_pcm) begin
			val_0[7] <= val_0[6];
			val_0[6] <= val_0[5];
			val_0[5] <= val_0[4];
			val_0[4] <= val_0[3];
			val_0[3] <= val_0[2];
			val_0[2] <= val_0[1];
			val_0[1] <= val_0[0];
			val_0[0] <= val[0];

			val_1[7] <= val_1[6];
			val_1[6] <= val_1[5];
			val_1[5] <= val_1[4];
			val_1[4] <= val_1[3];
			val_1[3] <= val_1[2];
			val_1[2] <= val_1[1];
			val_1[1] <= val_1[0];
			val_1[0] <= val[1];

			val_2[7] <= val_2[6];
			val_2[6] <= val_2[5];
			val_2[5] <= val_2[4];
			val_2[4] <= val_2[3];
			val_2[3] <= val_2[2];
			val_2[2] <= val_2[1];
			val_2[1] <= val_2[0];
			val_2[0] <= val[2];

			val_3[7] <= val_3[6];
			val_3[6] <= val_3[5];
			val_3[5] <= val_3[4];
			val_3[4] <= val_3[3];
			val_3[3] <= val_3[2];
			val_3[2] <= val_3[1];
			val_3[1] <= val_3[0];
			val_3[0] <= val[3];

			val_4[7] <= val_4[6];
			val_4[6] <= val_4[5];
			val_4[5] <= val_4[4];
			val_4[4] <= val_4[3];
			val_4[3] <= val_4[2];
			val_4[2] <= val_4[1];
			val_4[1] <= val_4[0];
			val_4[0] <= val[4];

			ang0 <= val_0[0] + val_1[1] + val_2[2] + val_3[3] + val_4[4];
			ang1 <= val_0[0] + val_1[0] + val_2[0] + val_3[0] + val_4[0];
			ang2 <= val_0[4] + val_1[3] + val_2[2] + val_3[1] + val_4[0];
		end
	end

	reg [7:0] n = 0;
	always @(posedge clk)
	begin
		if (en_pcm) begin
			n <= n + 1;
			if (n == 32) begin
				ang0 <= 0;
				ang1 <= 0;
				ang2 <= 0;
				n <= 0;
			end
		end
	end



	reg [15:0] ang0 = 0;
	reg [15:0] ang1 = 0;
	reg [15:0] ang2 = 0;

	assign hop = ang1[1];

endmodule

// vi: ft=verilog ts=3 sw=3
