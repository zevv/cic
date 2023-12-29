
module integrator #(parameter W=16)
	(input reset, input clk, input signed [W-1:0] din, output reg signed [W-1:0] dout = 0);

	always @(posedge clk)
	begin
		if (reset)
			dout <= 0;
		else
			dout <= dout + din;
	end

endmodule


module comb #(parameter W=16)
	(input reset, input clk, input signed [W-1:0] din, output reg signed [W-1:0] dout = 0);

	reg signed [W-1:0] din_prev = 0;

	always @(posedge clk)
	begin
		if (reset) begin
			dout <= 0;
			din_prev <= 0;
		end else begin
			dout <= din - din_prev;
			din_prev <= din;
		end

	end
endmodule


module cic #(parameter W=16)
	(input reset, input clk, input clk_pcm, input din, output signed [W-1:0] out);

	reg signed [W-1:0] d0 = 0;
	wire signed [W-1:0] d1;
	wire signed [W-1:0] d2;
	wire signed [W-1:0] c1;
	wire signed [W-1:0] c2;

	integrator #(.W(W)) int0 (reset, clk, d0, d1);
	integrator #(.W(W)) int1 (reset, clk, d1, d2);

	comb #(.W(W)) comb0 (reset, clk_pcm, d2, c1);
	comb #(.W(W)) comb1 (reset, clk_pcm, c1, c2);

	assign out = c2;

	always @(posedge clk)
	begin
		if (reset)
			d0 <= 0;
		else

			if (din == 0)
				d0 <= +24'd1;
			else
				d0 <= -24'd1;
	end

endmodule


module audio_clock(input reset, input clk, output clk_left, output clk_right, output clk_pcm);

	reg [8:0] cnt = 0;
	reg [8:0] div = 0;

	assign clk_left  =  div[0];
	assign clk_right = ~div[0];
	assign clk_pcm   =  div[5];

	always @(posedge clk)
	begin
		if (reset) begin
			cnt <= 0;
			div <= 0;
		end else begin
			cnt <= cnt + 1;
			if(cnt == 20-1) begin
				cnt <= 0;
				div <= div + 1;
			end
		end

	end


endmodule

// vi: ft=verilog ts=3 sw=3
