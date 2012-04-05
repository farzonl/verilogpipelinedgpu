// Main test module for testing basic rasterization
// DRIVER PROGRAM FOR EdgeRasterizer.v
module raster_tri_test(CLOCK_50, KEY, SW, LEDG, LEDR, HEX0, HEX1, HEX2, HEX3);

	// standard input/output declarations
	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	
	output [7:0] LEDG;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3;
	
	// clock stuff
	wire [0:0] clock = KEY[0];
	
	// control signal wires
	wire [0:0] sig_start_new_triangle = SW[0];
	wire [0:0] sig_get_boundary_coords = SW[1];
	wire [0:0] sig_form_edges = SW[2];
	wire [0:0] sig_pixel_loop_setup = SW[3];
	wire [0:0] sig_rasterize_pixels = SW[4];
	wire [0:0] sig_rasterize_write_pixel;
	wire [0:0] sig_rasterize_done;
	
	// test input wires for rasterization
	// 3 vertices in screen coordinates
	wire [15:0] v0_screen_x = 16'd100;
	wire [15:0] v0_screen_y = 16'd25;
	wire [15:0] v1_screen_x = 16'd125;
	wire [15:0] v1_screen_y = 16'd75;
	wire [15:0] v2_screen_x = 16'd75;
	wire [15:0] v2_screen_y = 16'd75;
	// 3 vertex depth values
	wire [1:0] v0_depth = 2'b0;
	wire [1:0] v1_depth = 2'b0;
	wire [1:0] v2_depth = 2'b0;
	// color
	wire [15:0] color = 16'hFF00;	// ARGB
	
	// test output wires for rasterization
	wire [15:0] raster_out_pixel_x;
	wire [15:0] raster_out_pixel_y;
	wire [1:0] raster_out_pixel_depth;
	wire [15:0] raster_out_pixel_color;	
	
	EdgeRasterizer edgeRasterizer(.clock(clock),
									.in_sig_start_new_triangle(sig_start_new_triangle),
									.in_sig_get_boundary_coords(sig_get_boundary_coords),
									.in_sig_form_edges(sig_form_edges),
									.in_sig_pixel_loop_setup(sig_pixel_loop_setup),
									.in_sig_rasterize_pixels(sig_rasterize_pixels),
									.in_v0_screen_x(v0_screen_x), 
									.in_v0_screen_y(v0_screen_y),
									.in_v1_screen_x(v1_screen_x),
									.in_v1_screen_y(v1_screen_y),
									.in_v2_screen_x(v2_screen_x),
									.in_v2_screen_y(v2_screen_y),
									.in_v0_depth(v0_depth),
									.in_v1_depth(v1_depth),
									.in_v2_depth(v2_depth),
									.in_color(color),
									.out_sig_rasterize_write_pixel(sig_rasterize_write_pixel), 
									.out_sig_rasterize_done(sig_rasterize_done),
									.out_pixel_x(raster_out_pixel_x),
									.out_pixel_y(raster_out_pixel_y),
									.out_pixel_depth(raster_out_pixel_depth),
									.out_pixel_color(raster_out_pixel_color));
	
	// test final output assignments
	sevenSegNum display0(.DISP(HEX0), .NUM(raster_out_pixel_y[3:0]));
	sevenSegNum display1(.DISP(HEX1), .NUM(raster_out_pixel_y[7:4]));
	sevenSegNum display2(.DISP(HEX2), .NUM(raster_out_pixel_x[3:0]));
	sevenSegNum display3(.DISP(HEX3), .NUM(raster_out_pixel_x[7:4]));
	
	assign LEDG[1:0] = raster_out_pixel_depth;
	
	assign LEDR[0] = sig_start_new_triangle;
	assign LEDR[1] = sig_get_boundary_coords;
	assign LEDR[2] = sig_form_edges;
	assign LEDR[3] = sig_pixel_loop_setup;
	assign LEDR[4] = sig_rasterize_pixels;
	assign LEDR[8] = sig_rasterize_write_pixel;
	assign LEDR[9] = sig_rasterize_done;

endmodule