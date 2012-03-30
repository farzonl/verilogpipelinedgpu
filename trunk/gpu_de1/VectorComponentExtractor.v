// Module for extracting 4 components from a value from a vector register.
// Logic is not clocked.
// Tested as of 03/30/2012
								
module VectorComponentExtractor(
								// Inputs:
								// 1 64-bit value from a vector register
								in_vector_val,
								// Outputs:
								// 4 16-bit values extracted from 4 components of input vector value
								// component0 is least significant bits, component3 is most significant bits
								out_component0,
								out_component1,
								out_component2,
								out_component3);
								
	// input/output declarations
	input [63:0] in_vector_val;
	output [15:0] out_component0;
	output [15:0] out_component1;
	output [15:0] out_component2;
	output [15:0] out_component3;
	
	// wire assignments - extracts components from vector value
	assign out_component0 = in_vector_val[15:0];
	assign out_component1 = in_vector_val[31:16];
	assign out_component2 = in_vector_val[47:32];
	assign out_component3 = in_vector_val[63:48];

endmodule