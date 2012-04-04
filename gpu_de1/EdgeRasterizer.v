// Module to perform actual rasterization.
// Uses edge function.
// Input coordinates should be final screen values.
// Will output a control signal when completely done with input triangle (iffy).
// Outputs x, y coordinates of pixel to be written along with depth and color.

// Clock and control signals should be 1-bit
// Pixel screen coordinates and colors are assumed to be 16-bits
// Depth values should be 2-bits

// NOTE: STILL A WORK IS PROGRESS.
// PROBABLY DOES NOT WORK YET.
// HAS NOT BEEN TESTED.
// Jacob Pike - April 3, 2012
module EdgeRasterizer(clock,									// clock - logic here takes multiple cycles
						in_sig_start_new_triangle, 				// control signal to indicate starting new triangle
						in_sig_get_boundary_coords, 			// control signal to indicate should get bounding box coordinates of triangle
						in_sig_form_edges, 						// control signal to indicate should form initial edge function values
						in_sig_pixel_loop_setup,				// control signal to indicate should setup for rasterization loop over pixels
						in_sig_rasterize_pixels, 				// control signal to indicate actual rasterization computation should occur
						in_v0_screen_x, in_v0_screen_y,			// x, y coordinates of vertex 0
						in_v1_screen_x, in_v1_screen_y,			// x, y coordinates of vertex 1
						in_v2_screen_x, in_v2_screen_y,			// x, y coordinates of vertex 2
						in_v0_depth, in_v1_depth, in_v2_depth,	// depth (z-value) for 3 vertices
						in_color,								// color to use for triangle pixels
						out_sig_rasterize_done, 				// signal to indicate rasterization of current triangle is complete (iffy on effectiveness of this actually working)
						out_pixel_x, out_pixel_y,				// x, y coordinates of any output pixels (only pixels inside triangle)
						out_pixel_depth,						// depth (z-value) of any output pixels (only pixels inside triangle) - NOT YET IMPLEMENTED
						out_pixel_color);						// color of any output pixels (only pixels inside triangle)
					
	// standard input/output declarations
	input [0:0] clock;
	input [0:0] in_sig_start_new_triangle;
	input [0:0] in_sig_get_boundary_coords;
	input [0:0] in_sig_form_edges;
	input [0:0] in_sig_pixel_loop_setup;
	input [0:0] in_sig_rasterize_pixels;
	input [15:0] in_v0_screen_x, in_v0_screen_y;
	input [15:0] in_v1_screen_x, in_v1_screen_y;
	input [15:0] in_v2_screen_x, in_v2_screen_y;
	input [1:0] in_v0_depth, in_v1_depth, in_v2_depth;
	input [15:0] in_color;
	
	output [0:0] out_sig_rasterize_done;
	output [15:0] out_pixel_x, out_pixel_y;
	output [1:0] out_pixel_depth;
	output [15:0] out_pixel_color;
	
		
	// Cycle 1 - Save Input Values Into Registers
	// These values should not be messed with until
	// rasterization of this triangle is completed.
	//
	// Note that the "initial" statements are necessary
	// to ensure properly clocked logic assignments.  Leaving
	// it out will have the register effectively reduced to 
	// a constant input value.
	//
	// Thankfully, it looks like that above "initial" fix
	// fixes other registers further down this rasterizer's
	// "pipeline", but if other issues are encountered,
	// try setting initial values for other registers
	reg [15:0] start_v0_screen_x, start_v0_screen_y;
	initial start_v0_screen_x = 16'd0;
	initial start_v0_screen_y = 16'd0;
	reg [15:0] start_v1_screen_x, start_v1_screen_y;
	initial start_v1_screen_x = 16'd0;
	initial start_v1_screen_y = 16'd0;
	reg [15:0] start_v2_screen_x, start_v2_screen_y;
	initial start_v2_screen_x = 16'd0;
	initial start_v2_screen_y = 16'd0;
	reg [1:0] start_v0_depth, start_v1_depth, start_v2_depth;
	initial start_v0_depth = 2'd0;
	initial start_v1_depth = 2'd0;
	initial start_v2_depth = 2'd0;
	reg [15:0] start_color;
	initial start_color = 16'd0;
	
	always @(posedge clock) begin
		if (in_sig_start_new_triangle) begin
			start_v0_screen_x <= in_v0_screen_x;
			start_v0_screen_y <= in_v0_screen_y;
			
			start_v1_screen_x <= in_v1_screen_x;
			start_v1_screen_y <= in_v1_screen_y;
			
			start_v2_screen_x <= in_v2_screen_x;
			start_v2_screen_y <= in_v2_screen_y;
			
			start_v0_depth <= in_v0_depth;
			start_v1_depth <= in_v1_depth;
			start_v2_depth <= in_v2_depth;
			
			start_color <= in_color;
		end
	end
	
		
	// Cycle 2 - Find Min/Max X/Y values for forming
	// bounding box around triangle (used for looping
	// through pixels within bounding box)
	reg [15:0] min_x, min_y;
	reg [15:0] max_x, max_y;
	
	always @(posedge clock) begin
		if (in_sig_get_boundary_coords) begin
			
			// v0 is min x
			if (start_v0_screen_x < start_v1_screen_x &&
				start_v0_screen_x < start_v2_screen_x) begin
				min_x <= start_v0_screen_x;
			end
			// v1 is min x
			else if (start_v1_screen_x < start_v0_screen_x &&
					start_v1_screen_x < start_v2_screen_x) begin
				min_x <= start_v1_screen_x;	
			end
			// v2 is min x
			else begin
				min_x <= start_v2_screen_x;
			end
			
			// v0 is min y
			if (start_v0_screen_y < start_v1_screen_y &&
				start_v0_screen_y < start_v2_screen_y) begin
				min_y <= start_v0_screen_y;
			end
			// v1 is min y
			else if (start_v1_screen_y < start_v0_screen_y &&
				start_v1_screen_y < start_v2_screen_y) begin
				min_y <= start_v1_screen_y;
			end
			// v2 is min y
			else begin
				min_y <= start_v2_screen_y;
			end
			
			// v0 is max x
			if (start_v0_screen_x > start_v1_screen_x &&
				start_v0_screen_x > start_v2_screen_x) begin
				max_x <= start_v0_screen_x;
			end
			// v1 is max x
			else if (start_v1_screen_x > start_v0_screen_x &&
					start_v1_screen_x > start_v2_screen_x) begin
				max_x <= start_v1_screen_x;
			end
			// v2 is max x
			else begin
				max_x <= start_v2_screen_x;
			end
			
			// v0 is max y
			if (start_v0_screen_y > start_v1_screen_y &&
				start_v0_screen_y > start_v2_screen_y) begin
				max_y <= start_v0_screen_y;
			end
			// v1 is max y
			else if (start_v1_screen_y > start_v0_screen_y &&
					start_v1_screen_y > start_v2_screen_y) begin
				max_y <= start_v1_screen_y;
			end
			// v2 is max y
			else begin
				max_y <= start_v2_screen_y;
			end
			
		end
	end
	
	
	// Cycle 3 - Form Edge Functions
	// See slide 6 of 18.opengl_rasterization2.pptx
	// Below is a slightly optimized version with coefficients multiplied out
	// Might want to double-check my work
	reg [15:0] edge0_a, edge0_b, edge0_c;
	reg [15:0] edge1_a, edge1_b, edge1_c;
	reg [15:0] edge2_a, edge2_b, edge2_c;
	
	always @(posedge clock) begin
		if (in_sig_form_edges) begin
		
			// edge 0
			edge0_a <= start_v1_screen_y - start_v2_screen_y;
			edge0_b <= start_v2_screen_x - start_v1_screen_x;
			edge0_c <= start_v2_screen_y * start_v1_screen_x -
						start_v2_screen_x * start_v1_screen_y;
						
			// edge 1
			edge1_a <= start_v2_screen_y - start_v0_screen_y;
			edge1_b <= start_v0_screen_x - start_v2_screen_x;
			edge1_c <= start_v0_screen_y * start_v2_screen_x -
						start_v0_screen_x * start_v2_screen_y;
			
			// edge 2
			edge2_a <= start_v0_screen_y - start_v1_screen_y;
			edge2_b <= start_v1_screen_x - start_v0_screen_x;
			edge2_c <= start_v1_screen_y * start_v0_screen_x - 
						start_v1_screen_x * start_v0_screen_y;
						
		end
	end
	
	// NOTE: Cycles 4 & 5+ have been combined below to properly assign register values
	
	// Cycle 4 - Set up for looping across pixels
	// For now, we'll just go over a rectangle that
	// could cover the entire triangle (for simplicity's sake)
	// We start by assigning the min x, y values as
	// start values for the iterators (like a for-loop setup)
	reg [15:0] x_pixel_iter;
	reg [15:0] y_pixel_iter;
	// Cycle 5 until end
	// Actually loop through pixels to calculate colors.
	// Uses edge function calculations.
	// Values are stored in below registers before being
	// assigned to final wires.
	reg [15:0] out_pixel_x_reg, out_pixel_y_reg;
	reg [1:0] out_pixel_depth_reg;
	reg [15:0] out_pixel_color_reg;
	reg [0:0] out_sig_rasterize_done_reg;	// this reg exists likely due to 1-cycle delay with registers
	
	always @(posedge clock) begin
		if (in_sig_pixel_loop_setup) begin
			x_pixel_iter <= min_x;
			y_pixel_iter <= min_y;
		end
	
		if (in_sig_rasterize_pixels) begin
	
			// compute edge function values - if good, store pixel value for output
			if ( (edge0_a * x_pixel_iter + edge0_b * y_pixel_iter + edge0_c) >= 0 && 		// edge0
				 (edge1_a * x_pixel_iter + edge1_b * y_pixel_iter + edge1_c) >= 0 && 		// edge1
				 (edge2_a * x_pixel_iter + edge2_b * y_pixel_iter + edge2_c) >= 0 ) begin 	// edge2
				
				out_pixel_x_reg <= x_pixel_iter;
				out_pixel_y_reg <= y_pixel_iter;
				out_pixel_depth_reg <= 2'd0;	// TODO - calculate interpolated z-value
				out_pixel_color_reg <= start_color; 
				
			end
			
			// increment x and y pixel iterators
			// basic case - x iter still has room to go on current row
			if (x_pixel_iter < max_x) begin
				x_pixel_iter <= x_pixel_iter + 16'd1;
			end
			// reached end of current row, need to move down to next row
			else if (x_pixel_iter >= max_x && y_pixel_iter < max_y) begin
				x_pixel_iter <= min_x;
				y_pixel_iter <= y_pixel_iter + 16'd1;
			end
			// reached end of entire bounding box of pixels - not 100% sure about this logic
			else if (x_pixel_iter >= max_x && y_pixel_iter >= max_y) begin
				out_sig_rasterize_done_reg <= 1'b1;
			end
	
		end
	end
	
	// Final output wire assignments	
	// not sure about this logic to assign out_sig_rasterize_done
	// CONFIRMED - THIS ASSIGNMENT FOR THIS SIGNAL VALUE DOES NOT WORK AS INTENDED
	assign out_sig_rasterize_done = out_sig_rasterize_done_reg;
					
	assign out_pixel_x = out_pixel_x_reg;
	assign out_pixel_y = out_pixel_y_reg;
	assign out_pixel_depth = out_pixel_depth_reg;
	assign out_pixel_color = out_pixel_color_reg;
					
endmodule