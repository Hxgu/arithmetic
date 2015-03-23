module adder_cla #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width : 0] s
);
	wire [width - 1 : 0] cla_s;
	wire cla_co;
	CLA #(`WIDTH) cla_inst (
		.x(x), .y(y), .s(cla_s), .carry_out(cla_co)
	);
	assign s = (cla_co << width) ^ cla_s;
endmodule

module CLA #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width - 1 : 0] s,
	output carry_out
);
	wire [width - 1: 0] h_sum, carry_gen, carry_prop, carry_in_internal;
	assign h_sum = x ^ y;
	assign carry_gen = x & y;
	assign carry_prop = x ^ y;
	assign carry_in_internal[1] = carry_gen[0] | (carry_prop[0] & 0);
	genvar i;
	generate
		for (i = 1; i <= width-2; i = i + 1) begin:m
				assign carry_in_internal[i+1] = carry_gen[i] | (carry_prop[i] & carry_in_internal[i]);
		end
	endgenerate
	assign carry_out = carry_gen[width -1] | (carry_prop[width -1] & carry_in_internal[width -1]);
	assign carry_in_internal[0] = 0;
	assign s = h_sum ^ carry_in_internal;
endmodule
