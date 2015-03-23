module adder_ling #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width : 0] s
);
	wire [width - 1 : 0] ling_s;
	wire ling_co;
	LING #(`WIDTH) ling_inst (
		.x(x), .y(y), .s(ling_s), .carry_out(ling_co)
	);
	assign s = (ling_co << width) ^ ling_s;
endmodule

module LING #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width - 1 : 0] s,
	output carry_out
);
	wire [width - 1: 0] h_sum, t, g;
	wire [width:0] h;
	assign g = x & y;
	assign t = x | y;
	assign h[1] = g[0] | 0;
	assign h_sum[0] = x[0] ^ y[0];
	genvar i;
	generate
		for (i = 1; i <= width-1; i = i + 1) begin:m
				assign h[i+1] = g[i] | (t[i] & h[i]);
				assign h_sum[i] = (t[i]^h[i+1])|(g[i]&t[i-1]&h[i]);
		end
	endgenerate
	assign carry_out = t[width-1]&h[width];
	assign s = h_sum;
endmodule
