module adder_mcc #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width : 0] s
);
	wire [width - 1 : 0] mcc_s;
	wire mcc_co;
	MCC #(`WIDTH) mcc_inst (
		.x(x), .y(y), .s(mcc_s), .carry_out(mcc_co)
	);
	assign s = (mcc_co << width) ^ mcc_s;
endmodule

module MCC #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width - 1 : 0] s,
	output carry_out
);
	wire [width - 1: 0] h_sum, carry_gen, t, carry_in_internal;
	assign h_sum = x ^ y;
	assign carry_gen = x & y;
	assign t = x | y;
	assign carry_in_internal[1] = carry_gen[0] | (t[0] & 0);
	genvar i;
	generate
		for (i = 1; i <= width-2; i = i + 1) begin:m
				assign carry_in_internal[i+1] = carry_gen[i] | (t[i] & carry_in_internal[i]);
		end
	endgenerate
	assign carry_out = carry_gen[width -1] | (t[width -1] & carry_in_internal[width -1]);
	assign carry_in_internal[0] = 0;
	assign s = h_sum ^ carry_in_internal;
endmodule
