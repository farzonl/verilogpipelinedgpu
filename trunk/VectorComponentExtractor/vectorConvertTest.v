//test

module vectorConvertTest(clock, x_out, y_out);
  
  input clock;
  output [15:0]x_out;
  output [15:0]y_out;
  reg [63:0]vectReg;
  wire [15:0]x_comp;
  wire [15:0]y_comp;
  wire [15:0]z_comp;
  wire [15:0]w_comp;

  initial vectReg[63]    = 1'd1;
  initial vectReg[62:55] = 8'd2;
  initial vectReg[54:48] = 7'b1110000;
  initial vectReg[47]    = 1'b1;
  initial vectReg[46:39] = 8'd2;
  initial vectReg[38:32] = 7'b1110000;
  initial vectReg[31:0] = 32'd0;
  
  VectorComponentExtractor vectExtr(.in_vector_val(vectReg),
                .clock(clock),
							// Outputs:
								// 4 16-bit values extracted for 4 components of input vector value
								// component0 is least significant bits, component3 is most significant bits
								.out_component0(w_comp),
								.out_component1(z_comp),
								.out_component2(y_comp),
								.out_component3(x_comp));
								
	assign x_out = x_comp;
  assign y_out = y_comp;
								
								
endmodule