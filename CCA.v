module adder_cca #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width : 0] s
);	
	wire [width - 1 : 0] cca_s;
	wire [width - 1 : 0] cca_c;
	CCA #(`WIDTH) cca_inst(
		.x(x), .y(y), .s(cca_s), .co0(cca_c)
	);
	assign s = (cca_c << 1) ^ cca_s;
endmodule

module CCA #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width - 1 : 0] s,
	output [width - 1 : 0] co0, co1
);
	
	if (width == 'h1)
	begin
		assign s = x ^ y;
		assign co0 = x & y;
		assign co1 = x | y;
	end
	else
	begin
		wire [width / 2 - 1 : 0] s_l;
		wire [width / 2 - 1 : 0] s_h;
		wire [width / 2 - 1 : 0] co0_l, co1_l;
		wire [width / 2 - 1 : 0] co0_h, co1_h;
		
		CCA #(width >> 1) csa_l(
			.x(x[width / 2 - 1 : 0]),
			.y(y[width / 2 - 1 : 0]),
			.s(s_l),
			.co0(co0_l), .co1(co1_l)
		);
		CCA #(width >> 1) csa_h(
			.x(x[width - 1 : width / 2]),
			.y(y[width - 1 : width / 2]),
			.s(s_h),
			.co0(co0_h), .co1(co1_h)
		);
		
		assign co0 = ((co0_l[width / 2 - 1] ? co1_h : co0_h) << (width / 2)) | co0_l;
		assign co1 = ((co1_l[width / 2 - 1] ? co1_h : co0_h) << (width / 2)) | co1_l;
		assign s[width / 2 - 1 : 0] = s_l;
		assign s[width - 1 : width / 2] = s_h;
	end
	
endmodule
	
	
