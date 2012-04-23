// EdgeRasterizer.v with Z and Color Interpolation

// Module to perform actual rasterization.
// Uses edge function.
// Input coordinates should be final screen values.
// Will output a control signal when completely done with input triangle.
// Outputs x, y coordinates of pixel to be written along with depth and color.

// Clock and control signals should be 1-bit
// Pixel screen coordinates and colors are assumed to be 16-bits
// Depth values should be 2-bits

// Cycle-by-Cycle Signals to Assert to Rasterize Triangle:
// 1. Assert in_sig_start_new_triangle
// 2. Assert in_sig_get_boundary_coords
// 3. Assert in_sig_form_edges
// 4. Assert in_sig_pixel_loop_setup
// 5. Assert in_sig_rasterize_pixels to start main rasterization loop.  This will take multiple cycles.
//		Continue asserting this signal until rasterization is done (this module will assert
//		out_sig_rasterize_done when rasterization is done) or you have some other odd reason to
//		prematurely stop rasterization.
//
//		During this rasterization loop, pixel values (x, y, color) that are inside the triangle
//		and need to be written to the framebuffer will be outputted.  If this pixel value being
//		outputted is new, then the out_sig_rasterize_write_pixel will be asserted.  If this
//		signal is not asserted, then the output values from this module are likely old pixel values
//		that have been output in previous cycles.
//		As of April 12, 2012, interpolated depth (z) values are also outputted.  If there seems to
//		be a problem with these values later on, it may be necessary to increase the sizes of registers
//		used to store values related to this computation.

// NOTE: TESTED FOR FUNCTIONALITY NEEDED FOR ASSIGNMENT 4/5/6.  APPEARS TO PASS.
// Assuming appropriate control signals are used for setup, this appears to output
// correct pixel values throughout the rasterization operation that occurs
// once "in_sig_rasterize_pixels" (control signal) is on.

// Jacob Pike - April 5, 2012 (Assignment 4 testing complete)
// Jacob Pike - April 12, 2012 (Assignment 5 testing complete)
// Jacob Pike - April 23, 2012 (Assignment 6 testing complete)
module EdgeRasterizerColorInterp(clock,									// clock - logic here takes multiple cycles
								in_sig_start_new_triangle, 				// control signal to indicate starting new triangle
								in_sig_get_boundary_coords, 			// control signal to indicate should get bounding box coordinates of triangle
								in_sig_form_edges, 						// control signal to indicate should form initial edge function values
								in_sig_pixel_loop_setup,				// control signal to indicate should setup for rasterization loop over pixels
								in_sig_rasterize_pixels, 				// control signal to indicate actual rasterization computation should occur
								in_v0_screen_x, in_v0_screen_y,			// x, y coordinates of vertex 0
								in_v1_screen_x, in_v1_screen_y,			// x, y coordinates of vertex 1
								in_v2_screen_x, in_v2_screen_y,			// x, y coordinates of vertex 2
								in_v0_depth, in_v1_depth, in_v2_depth,	// depth (z-value) for 3 vertices
								in_v0_color,							// color for vertex 0
								in_v1_color,							// color for vertex 1
								in_v2_color,							// color for vertex 2
								out_sig_rasterize_write_pixel,			// signal to indicate that current output pixel data is a pixel inside triangle that can be written to framebuffer
								out_sig_rasterize_done, 				// signal to indicate rasterization of current triangle is complete
								out_pixel_x, out_pixel_y,				// x, y coordinates of any output pixels (only pixels inside triangle)
								out_pixel_depth,						// depth (z-value) of any output pixels (only pixels inside triangle)
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
	input [15:0] in_v0_color, in_v1_color, in_v2_color;
	
	output [0:0] out_sig_rasterize_write_pixel;
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
	reg [15:0] start_v0_color, start_v1_color, start_v2_color;
	initial start_v0_color = 16'd0;
	initial start_v1_color = 16'd0;
	initial start_v2_color = 16'd0;
	
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
			
			start_v0_color <= in_v0_color;
			start_v1_color <= in_v1_color;
			start_v2_color <= in_v2_color;
			
		end
	end
	
		
	// Cycle 2 - Find Min/Max X/Y values for forming
	// bounding box around triangle (used for looping
	// through pixels within bounding box)
	// 
	// Also calculate triangle area (for later use)
	// NOTE: This triangle area depends on vertices
	// being in counterclockwise order (otherwise it is negative), 
	// but this should not be an issue sends the vertices are
	// expected to be in that order anyway.
	// The triangle area is calculated for the purposes of
	// z-value interpolation later.  The actual value stored is
	// not the actual area but rather twice that (since that is
	// needed in the formula for converting edge function values
	// to barycentric coordinates).
	//
	// Finally, 16-bit z-values are also computed for the depths.  This
	// is done to eliminate any potential problems related to math
	// done on 2-bit z-values.
	reg [15:0] min_x, min_y;
	reg [15:0] max_x, max_y;
	
	reg [15:0] triangle_area;
	initial triangle_area = 16'b0;
	
	reg [15:0] v0_depth_16, v1_depth_16, v2_depth_16;
	
	// color registers - we can get better interpolation with 16-bit values
	// instead of 4-bit int values
	reg [15:0] v0_color_r_16, v0_color_g_16, v0_color_b_16;
	reg [15:0] v1_color_r_16, v1_color_g_16, v1_color_b_16;
	reg [15:0] v2_color_r_16, v2_color_g_16, v2_color_b_16;
	
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
			
			// calculate triangle area
			// this is actually twice the area since that
			// is what is needed for conversion-to-barycentric later
			triangle_area <= 	(start_v0_screen_x * start_v1_screen_y) +
								(start_v1_screen_x * start_v2_screen_y) +
								(start_v2_screen_x * start_v0_screen_y) -
								(start_v0_screen_x * start_v2_screen_y) -
								(start_v1_screen_x * start_v0_screen_y) - 
								(start_v2_screen_x * start_v1_screen_y);
											
			// calculate "larger" z-values as 16-bit numbers instead of 2-bit
			// this is done to make interpolation less likely to be error prone
			v0_depth_16 <= 16'b0 + (start_v0_depth << 7);
			v1_depth_16 <= 16'b0 + (start_v1_depth << 7);
			v2_depth_16 <= 16'b0 + (start_v2_depth << 7);
			
			// calculate "larger" color values for interpolation
			v0_color_r_16 <= 16'b0 + (start_v0_color[11:8]);
			v0_color_g_16 <= 16'b0 + (start_v0_color[7:4]);
			v0_color_b_16 <= 16'b0 + (start_v0_color[3:0]);
			
			v1_color_r_16 <= 16'b0 + (start_v1_color[11:8]);
			v1_color_g_16 <= 16'b0 + (start_v1_color[7:4]);
			v1_color_b_16 <= 16'b0 + (start_v1_color[3:0]);
			
			v2_color_r_16 <= 16'b0 + (start_v2_color[11:8]);
			v2_color_g_16 <= 16'b0 + (start_v2_color[7:4]);
			v2_color_b_16 <= 16'b0 + (start_v2_color[3:0]);
			
		end
	end
	
	
	// Cycle 3 - Form Edge Functions
	// See slide 6 of 18.opengl_rasterization2.pptx
	// Below is a slightly optimized version with coefficients multiplied out
	// Might want to double-check my work
	//
	// Also computes inverse (reciprocal) of triangle area, 
	// which is needed for z-value interpolation
	reg [15:0] edge0_a, edge0_b, edge0_c;
	reg [15:0] edge1_a, edge1_b, edge1_c;
	reg [15:0] edge2_a, edge2_b, edge2_c;
	
	reg [15:0] inverse_triangle_area;
	initial inverse_triangle_area = 16'b0;
	
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
						
			// conversion to fixed-point
			inverse_triangle_area <= (1'b1 << 7) / (triangle_area);
						
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
	reg [15:0] out_pixel_depth_reg;	// 16-bit to hold higher-resolution z-value; only lowest 2 bits (after reconverting from fixed to int) sent to output wires
	reg [15:0] out_pixel_color_r_reg;	// higher resolution red color value for interpolation
	reg [15:0] out_pixel_color_g_reg;	// higher resolution green color value for interpolation
	reg [15:0] out_pixel_color_b_reg;	// higher resolution blue color value for interpolation
	reg [0:0] out_sig_rasterize_write_pixel_reg;	// reg to hold value if current pixel output should be written to screen
	reg [0:0] out_sig_rasterize_done_reg;	// this reg exists likely due to 1-cycle delay with registers
	
	always @(posedge clock) begin
		if (in_sig_pixel_loop_setup) begin
			// loop iterator setup
			x_pixel_iter <= min_x;
			y_pixel_iter <= min_y;
		end
	
		if (in_sig_rasterize_pixels) begin
	
			// compute edge function values - if good, store pixel value for output
			// check most significant bit to see if negative value (outside) by
			// comparing with "large" value of 7FFF (which is all 1's except most significant bit)
			if ( (edge0_a * x_pixel_iter + edge0_b * y_pixel_iter + edge0_c) <= 16'h7FFF && 		// edge0
				 (edge1_a * x_pixel_iter + edge1_b * y_pixel_iter + edge1_c) <= 16'h7FFF && 		// edge1
				 (edge2_a * x_pixel_iter + edge2_b * y_pixel_iter + edge2_c) <= 16'h7FFF ) begin 	// edge2
				
				out_pixel_x_reg <= x_pixel_iter;
				out_pixel_y_reg <= y_pixel_iter;
				
				// z-value interpolation
				// this is kind of ugly, but to do it in a cleaner way would require
				// more cycles within the rasterizer (which probably isn't worth it
				// since we have the current rasterizer working)
				out_pixel_depth_reg <= v0_depth_16
										+
										(
										(v1_depth_16 - v0_depth_16) * 
										((edge1_a * x_pixel_iter + edge1_b * y_pixel_iter + edge1_c) * inverse_triangle_area)
										>> 7)
										+
										(
										(v2_depth_16 - v0_depth_16) * 
										((edge2_a * x_pixel_iter + edge2_b * y_pixel_iter + edge2_c) * inverse_triangle_area)
										>> 7);	
										
				// color interpolation
				// split up into separate RGB interpolations for correct results
				// red				
				out_pixel_color_r_reg <= v0_color_r_16
										+
										(
										(v1_color_r_16 - v0_color_r_16) * 
										((edge1_a * x_pixel_iter + edge1_b * y_pixel_iter + edge1_c) * inverse_triangle_area)
										>> 7)
										+
										(
										(v2_color_r_16 - v0_color_r_16) * 
										((edge2_a * x_pixel_iter + edge2_b * y_pixel_iter + edge2_c) * inverse_triangle_area)
										>> 7);	
				// green
				out_pixel_color_g_reg <= v0_color_g_16
										+
										(
										(v1_color_g_16 - v0_color_g_16) * 
										((edge1_a * x_pixel_iter + edge1_b * y_pixel_iter + edge1_c) * inverse_triangle_area)
										>> 7)
										+
										(
										(v2_color_g_16 - v0_color_g_16) * 
										((edge2_a * x_pixel_iter + edge2_b * y_pixel_iter + edge2_c) * inverse_triangle_area)
										>> 7);	
				// blue
				out_pixel_color_b_reg <= v0_color_b_16
										+
										(
										(v1_color_b_16 - v0_color_b_16) * 
										((edge1_a * x_pixel_iter + edge1_b * y_pixel_iter + edge1_c) * inverse_triangle_area)
										>> 7)
										+
										(
										(v2_color_b_16 - v0_color_b_16) * 
										((edge2_a * x_pixel_iter + edge2_b * y_pixel_iter + edge2_c) * inverse_triangle_area)
										>> 7);	
				
				out_sig_rasterize_write_pixel_reg <= 1'b1;
				
			end
			else begin
				out_sig_rasterize_write_pixel_reg <= 1'b0;
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
			
			// reached end of entire bounding box of pixels
			if (x_pixel_iter >= max_x && y_pixel_iter >= max_y) begin
				out_sig_rasterize_done_reg <= 1'b1;
			end
			else begin	// otherwise, still rasterizing
				out_sig_rasterize_done_reg <= 1'b0;
			end
	
		end
		// if not rasterizing any pixels in the first place, then no need to assert out_sig_rasterize_done
		// or write pixel signal
		else begin
			out_sig_rasterize_done_reg <= 1'b0;
			out_sig_rasterize_write_pixel_reg <= 1'b0;
		end
	end
	
	// Final output wire assignments	
	assign out_sig_rasterize_done = out_sig_rasterize_done_reg;
	assign out_sig_rasterize_write_pixel = out_sig_rasterize_write_pixel_reg;
	
	//assign out_pixel_x = out_pixel_x_reg;
	assign out_pixel_x = out_pixel_color_b_reg;
	assign out_pixel_y = out_pixel_y_reg;
	// convert depth value to appropriate 2-bit value (convert from fixed to int and round)
	assign out_pixel_depth = (out_pixel_depth_reg >= 16'b101000000) ? 2'b11 :	// greater than/equal to max, so output max
							// less than max, so round up if necessary
							((out_pixel_depth_reg[6] == 1'b1) ? (out_pixel_depth_reg[8:7] + 1'b1) : (out_pixel_depth_reg[8:7]));
	
	// convert interpolated colors to proper 4-bit RGB components (similar to depth above)
	assign out_pixel_color[15:12] = 4'hF;	// just initialize "alpha" to all 1's
	// red
	assign out_pixel_color[11:8] = (out_pixel_color_r_reg[4] == 1'b1) ? 4'h0 :
									(out_pixel_color_r_reg[3:0]);
	// green
	assign out_pixel_color[7:4] = (out_pixel_color_g_reg[4] == 1'b1) ? 4'h0 :
									(out_pixel_color_g_reg[3:0]);
	// blue
	assign out_pixel_color[3:0] = (out_pixel_color_b_reg[4] == 1'b1) ? 4'h0 :
									(out_pixel_color_b_reg[3:0]);
	
					
endmodule