module adder_cra #(parameter width = `WIDTH) (
	input [width - 1 : 0] x, y,
	output [width : 0] s
);
	wire [width - 1 : 0] cra_s;
	wire cra_co;
	CRA #(`WIDTH) cra_inst (
		.x(x), .y(y), .s(cra_s), .carry_out(cra_co)
	);
	assign s = (cra_co << width) ^ cra_s;
endmodule

module CRA #(parameter width = `WIDTH)(
   input [width-1:0] x,y,
   output [width-1:0] s,
   output carry_out
);
	wire [width-1:0] carry;
   genvar i;
   full_adder full_adder_inst (
		.a(x[0]), .b(y[0]), .cin(0), .sum(s[0]), .cout(carry[0])
		);
   generate 
   for(i=1;i<= width-1;i=i+1)
     begin
			full_adder full_adder_inst (
				.a(x[i]), .b(y[i]), .cin(carry[i-1]), .sum(s[i]), .cout(carry[i])
			);
     end
   endgenerate
	assign carry_out = carry[width-1];
endmodule

module half_adder(
   input a,b,
   output sum,carry
);
   assign sum=a^b;
   assign carry=a&b;
endmodule

module full_adder(
   input a,b,cin,
   output sum,cout
);
   wire   t1,t2,temp;
   half_adder h_inst(
		.a(a), .b(b), .sum(t1), .carry(t2)
		);
   assign temp=t1&cin;
   assign sum=t1^cin;
   assign cout=t2|temp;
endmodule 
