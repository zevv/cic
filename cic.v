//light up the leds according to a counter to cycle through every one


module integrator(reset, clk, din, dout);
	input reset;
	input clk;
	input signed [23:0] din;
	output reg signed [23:0] dout;

	always @(posedge clk)
	begin
		if (reset)
			dout <= 0;
		else
			dout <= dout + din;

	end

endmodule


module comb(reset, clk, din, dout);
	input reset;
	input clk;
	input signed [23:0] din;
	output reg signed [23:0] dout;

	reg signed [23:0] din_prev;

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



module cic(reset, clk, din, val);
	input reset;
	input clk;
	input din;
	output [23:0] val;

	reg [8:0] counter = 0;

	reg signed [23:0] d0 = 0;
	wire signed [23:0] d1;
	wire signed [23:0] d2;
	reg clk_comb = 0;


	integrator int0 (reset, clk, d0, d1);
	integrator int1 (reset, clk, d1, d2);

	wire signed [23:0] c0;
	wire signed [23:0] c1;
	comb comb0 (reset, clk_comb, d2, c0);
	comb comb1 (reset, clk_comb, c0, c1);


	always @(posedge clk)
	begin
		if (reset) begin
			counter <= 0;
			d0 <= 0;
		end else begin
			if (din)
				d0 <= 24'd1;
			else
				d0 <= -24'd1;

			if (counter == 48) begin
				clk_comb <= 1'd1;
				counter <= 0;
			end else begin
				clk_comb <= 1'd0;
				counter <= counter + 1;
			end
		end
	end
endmodule
