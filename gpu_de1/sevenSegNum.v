// Module for displaying numbers on 7-segment display
// Based on code in 11.verilog_2.pptx

// Inputs:
// NUM - 4-bit number to display on 7-segment hex display

// Outputs:
// DISP - 7-segment display to display NUM on
module sevenSegNum(DISP, NUM);

	input  [3:0] NUM;
	output [6:0] DISP;
	
	assign DISP =
				(NUM == 4'h0) ? 7'b1000000 :
				(NUM == 4'h1) ? 7'b1111001 :
				(NUM == 4'h2) ? 7'b0100100 :
				(NUM == 4'h3) ? 7'b0110000 :
				(NUM == 4'h4) ? 7'b0011001 :
				(NUM == 4'h5) ? 7'b0010010 :
				(NUM == 4'h6) ? 7'b0000010 :
				(NUM == 4'h7) ? 7'b1111000 :
				(NUM == 4'h8) ? 7'b0000000 :
				(NUM == 4'h9) ? 7'b0010000 :
				(NUM == 4'hA) ? 7'b0001000 :
				(NUM == 4'hb) ? 7'b0000011 :
				(NUM == 4'hc) ? 7'b1000110 :
				(NUM == 4'hd) ? 7'b0100001 :
				(NUM == 4'he) ? 7'b0000110 :
				/*NUM == 4'hf*/ 7'b0001110 ;

endmodule