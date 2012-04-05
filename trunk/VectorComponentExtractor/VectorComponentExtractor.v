// PROTOTYPE by Jacob Pike
// Currently hasn't been tested, but is pretty simple
// Module for extracting 4 components from a value from a vector register
							// Inputs:
								// 1 64-bit value from a vector register
module VectorComponentExtractor(in_vector_val, clock,
							// Outputs:
								// 4 16-bit values extracted for 4 components of input vector value
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
	input clock;
	
	reg [21:0]compx;
	reg [21:0]compy;
	reg [15:0]in_compx;
	reg [15:0]in_compy;
	reg [15:0]interm_compy;
  reg [15:0]out_compx;
	reg [15:0]out_compy;
	reg [15:0]temp5 = (15'd5<<7);
	
	always @(posedge clock) begin
	  
	  //I used blocking assignments here because this work needs to be executed serially.
	  
	  in_compx = in_vector_val[63:48];
 	  in_compy = in_vector_val[47:32];
 	  //Add 5 to input to move origin to left hand side of plane
 	  //shift by 6 to multiply by the constant scaling factor of 64
 	  if(in_compx[15]==1'b1) begin
 	    compx[21:0] = ((~in_compx[14:0]+1'b1) + temp5[15:0])<<6;
 	  end
 	  else begin 
 	    compx[21:0] = in_compx[15:0]<<6;
 	  end
 	  //subtract 5 from the to move the origin to the top of the plane
 	  if(in_compy[15]==1'b0) begin
 	    interm_compy[14:0] = ~(in_compy[14:0] - temp5[14:0]) + 1;
 	  end
 	  else begin 
 	    interm_compy[14:0] = ~((~in_compy[14:0] + 1'b1) - temp5[14:0]) + 1;
 	  end
	  interm_compy[15] = 1'b0;
	  //Adding these 2 shifted values is the same as mult. by 40
	  compy = (interm_compy[15:0]<<5) + (interm_compy[15:0]<<3);
	  
	  //Somehow truncate the fixed point values
	  out_compy[14:0] <= compy[21:7] + compy[6];
	  out_compy[15] <= 1'b0;
	  out_compx[14:0] <= compx[21:7] + compy[6];
	  out_compx[15] <= 1'b0;
	end 
	  
	
	// wire assignments - extracts components from vector value
	assign out_component0 = in_vector_val[15:0];
	assign out_component1 = in_vector_val[31:16];
	assign out_component2 = out_compy[15:0];
	assign out_component3 = out_compx[15:0];

endmodule