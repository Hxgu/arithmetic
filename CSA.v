module adder_csa #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width : 0] s
);
	CSA #(`WIDTH) csa_inst (
		.x(x), .y(y), .s0(s[width - 1 : 0]), .co0(s[width])
	);
endmodule

// Conditional Sum Adder
module CSA #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width - 1 : 0] s0, s1,
	output co0, co1
);
	
	if (width == 'h1)
	begin
		assign s0 = x ^ y;
		assign s1 = ~(x ^ y);
		assign co0 = x & y;
		assign co1 = x | y;
	end
	else
	begin
		wire [width / 2 - 1 : 0] s0_l, s1_l;
		wire [width / 2 - 1 : 0] s0_h, s1_h;
		wire co0_l, co1_l;
		wire co0_h, co1_h;
		
		CSA #(width >> 1) csa_l(
			.x(x[width / 2 - 1 : 0]),
			.y(y[width / 2 - 1 : 0]),
			.s0(s0_l), .s1(s1_l),
			.co0(co0_l), .co1(co1_l)
		);
		CSA #(width >> 1) csa_h(
			.x(x[width - 1 : width / 2]),
			.y(y[width - 1 : width / 2]),
			.s0(s0_h), .s1(s1_h),
			.co0(co0_h), .co1(co1_h)
		);
		
		assign co0 = co0_l ? co1_h : co0_h;
		assign co1 = co1_l ? co1_h : co0_h;
		assign s0[width - 1 : width / 2] = co0_l ? s1_h : s0_h;
		assign s1[width - 1 : width / 2] = co1_l ? s1_h : s0_h;
		assign s0[width / 2 - 1 : 0] = s0_l;
		assign s1[width / 2 - 1 : 0] = s1_l;
	
	end
	
endmodule
	
	
