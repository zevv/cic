
module integrator #(parameter W=16)
	(input reset, input clk, input signed [W-1:0] din, output reg signed [W-1:0] dout);

	always @(posedge clk)
	begin
		if (reset)
			dout <= 0;
		else
			dout <= dout + din;
	end

endmodule


module comb #(parameter W=16)
	(input reset, input clk, input signed [W-1:0] din, output reg signed [W-1:0] dout);

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


module cic #(parameter W=24)
	(input reset, input clk, input din, output signed [W-1:0] out);

	reg [5:0] counter = 0;

	reg signed [W-1:0] d0;
	wire signed [W-1:0] d1;
	wire signed [W-1:0] d2;
	wire signed [W-1:0] c1;
	wire signed [W-1:0] c2;
	wire clk_comb = counter[4];

	integrator #(.W(W)) int0 (reset, clk, d0, d1);
	integrator #(.W(W)) int1 (reset, clk, d1, d2);

	comb #(.W(W)) comb0 (reset, clk_comb, d2, c1);
	comb #(.W(W)) comb1 (reset, clk_comb, c1, c2);

	assign out = c2;

	always @(posedge clk)
	begin
		if (reset) begin
			counter <= 0;
			d0 <= 0;
		end else begin

			if (din == 0)
				d0 <= +24'd1;
			else
				d0 <= -24'd1;

			counter <= counter + 1;
		end
	end

endmodule


