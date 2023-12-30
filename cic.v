
/* verilator lint_off DECLFILENAME */

module integrator #(parameter W=16)
	(input reset, input clk, input en, input signed [W-1:0] din, output reg signed [W-1:0] dout = 0);

	always @(posedge clk)
	begin
		if (reset)
			dout <= 0;
		else
			if (en)
				dout <= dout + din;
	end

endmodule


module comb #(parameter W=16)
	(input reset, input clk, input en, input signed [W-1:0] din, output reg signed [W-1:0] dout = 0);

	reg signed [W-1:0] din_prev = 0;

	always @(posedge clk)
	begin
		if (reset) begin
			dout <= 0;
			din_prev <= 0;
		end else begin
			if (en) begin
				dout <= din - din_prev;
				din_prev <= din;
			end
		end

	end
endmodule


module cic #(parameter W=16)
	(input reset, input clk, input en_sample, input en_pcm, input din, output signed [W-1:0] out);

	reg signed [W-1:0] d0 = 0;
	wire signed [W-1:0] d1;
	wire signed [W-1:0] d2;
	wire signed [W-1:0] c1;
	wire signed [W-1:0] c2;

	integrator #(.W(W)) int0 (reset, clk, en_sample, d0, d1);
	integrator #(.W(W)) int1 (reset, clk, en_sample, d1, d2);

	comb #(.W(W)) comb0 (reset, clk, en_pcm, d2, c1);
	comb #(.W(W)) comb1 (reset, clk, en_pcm, c1, c2);

	assign out = c2;

	always @(posedge clk)
	begin
		if (reset)
			d0 <= 0;
		else
			if (din == 0)
				d0 <= +1;
			else
				d0 <= -1;
	end

endmodule


module audio_clock(input reset, input clk, output reg clk_out_pdm, output reg en_left, output reg en_right, output reg en_pcm);

	reg [8:0] cnt = 0;
	reg [4:0] div = 0;

	always @(posedge clk)
	begin

		en_left <= 0;
		en_right <= 0;
		en_pcm <= 0;

		if (reset) begin
			cnt <= 0;
			div <= 0;
			clk_out_pdm <= 0;
			en_left <= 0;
			en_right <= 0;
			en_pcm <= 0;
		end else begin
			cnt <= cnt + 1;

			case (cnt)
				 0: begin
					 clk_out_pdm <= 0;
				 end
				 7: begin
					 en_left <= 1;
				 end
				 10: begin
					clk_out_pdm <= 1;
				 end
				 18: begin
					 en_right <= 1;
				 end
				 19: begin
					 div <= div + 1;
					 cnt <= 0;
					 if (div == 31) en_pcm <= 1;
				 end
		 endcase

		end

	end


endmodule


module delay(input clk, input en, input signed [15:0] din);

	reg signed [15:0] hist [15:0];

	always @(posedge clk)
	begin
		if (en) begin
			hist[15] <= hist[14];
			hist[14] <= hist[13];
			hist[13] <= hist[12];
			hist[12] <= hist[11];
			hist[11] <= hist[10];
			hist[10] <= hist[9];
			hist[9] <= hist[8];
			hist[8] <= hist[7];
			hist[7] <= hist[6];
			hist[6] <= hist[5];
			hist[5] <= hist[4];
			hist[4] <= hist[3];
			hist[3] <= hist[2];
			hist[2] <= hist[1];
			hist[1] <= hist[0];
			hist[0] <= din;
		end
	end
endmodule

// vi: ft=verilog ts=3 sw=3
