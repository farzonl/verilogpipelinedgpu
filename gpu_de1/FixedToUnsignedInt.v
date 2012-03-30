// Module for converting 1.8.7 fixed-point number to unsigned integer.

// If input is negative, 0 will be returned.
// If fractional part is 0.5 or greater, value will be rounded-up.
// Otherwise, integer component is returned as-is

// Logic is not clocked.
// Tested as of 03/30/2012

// Inputs:
// in_fixel_val - 1.8.7 fixed-point value to convert

// Outputs:
// out_fixed_val - wire to hold 16-bit unsigned int value
module FixedToUnsignedInt(in_fixed_val, out_int_val);

	// input/output declarations
	input [15:0] in_fixed_val;
	output [15:0] out_int_val;
	
	// if-else statements using ? : operator
	assign out_int_val = 	// negative, so set to lowest possible unsigned value
							(in_fixed_val[15] == 1'b1) ? (16'b0) :
							// 0.5 or greater fraction, so round-up
							(in_fixed_val[6] == 1'b1) ? ((in_fixed_val[14:7]) + 1'b1) :
							// regular, so just return int portion
							(in_fixed_val[14:7]);


endmodule