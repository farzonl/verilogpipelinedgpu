

module gpu_de1(	iGPU_DATA, oGPU_DATA, oMEM_ADDR, oMEM_READ, oMEM_WRITE,  
	iVIDEO_ON, iCLK, iRST_N
);


// GPU SRAM interface
input 		 [15:0]	iGPU_DATA;
output	reg [15:0]	oGPU_DATA;
output	reg [17:0]	oMEM_ADDR;
output	reg 			oMEM_WRITE;
output	reg			oMEM_READ;

input	iVIDEO_ON;
input	iCLK;
input iRST_N;



	wire clock, reset, draw, StartPrim, EndPrim;
	wire [31:0]instruction, vertex;
	wire [3:0]PrimType;
	
	wire [15:0] v0x,v0y,v0z,v0w;
	wire [15:0] v1x,v1y,v1z,v1w;
	wire [15:0] v2x,v2y,v2z,v2w;
	wire [63:0] vert0Vector, vert1Vector, vert2Vector;
	
	reg rastCycle1, rastCycle2, rastCycle3, rastCycle4, rastContinue;
	wire [1:0] v0depth, v1depth, v2depth, pixelDepth;
	wire [15:0] triangleColor;
	wire writePixel, rastDone;
	wire [15:0] pixelXout, pixelYout, pixelColor;
	
	reg [31:0] v_bufferStage1;
	reg [31:0] v_bufferStage2;
	reg [31:0] v0_buffer;
	reg [31:0] v1_buffer;
	reg [31:0] v2_buffer;
	reg [15:0] counter;
	
	wire [3:0] sevenSegOut1;
	wire [3:0] sevenSegOut2;
	
	reg latch, primRead;

	
	assign vert0Vector[31:0] = 32'd0;
	
	initial v0_buffer = 32'd0;
	initial v1_buffer = 32'd0;
	initial v2_buffer = 32'd0;

	
	FE fetch(.reset(reset),.CLOCK_50(clock),
				.id_instr(instruction),
				.Loop(loop),
				.PC_in(loop_PC),
				.PC_out(PC));
				
				
	ID decode(.RESET(reset),.CLK(CLOCK_50),
				 .Instruction(instruction),
				 .Vertex(vert0Vector[63:32]),
				 .StartPrimitive(StartPrim),
				 .EndPrimitive(EndPrim),
				 .PrimitiveType(PrimType),
				 .Draw(draw),.Loop(Loop),
				 .PC(PC),.PC_Out(Loop_PC));
				 
	always @ (posedge iCLK) begin
	if (!iVIDEO_ON) begin
	  //For now, hard code Z and W to be 0
		if(StartPrim) begin
			primRead <=1'b1;
		end else 		
		if(EndPrim) begin
			primRead <= 1'b0;
		end else begin
			primRead <= primRead;
		end
		
		oMEM_ADDR <= pixelYout*640 + pixelXout;
		oMEM_WRITE <= writePixel;
		oGPU_DATA <= pixelColor;
    
    
	 /*if(primRead)begin
		  v_bufferStage1[15:0] <= v0y;
		  v_bufferStage1[31:16] <= v0x;
		  v_bufferStage2 <= v_bufferStage1;
		  v2_buffer <= v_bufferStage2;
		  
		  //For second, buffer for 1 cycle
		  v1_buffer <= v_bufferStage1;
		  
		  v0_buffer[15:0] <= v0y;
		  v0_buffer[31:16] <= v0x;
		end else begin
		  v0_buffer <= v0_buffer;
		  v1_buffer <= v1_buffer;
		  v2_buffer <= v2_buffer;
		end*/
		
		v0_buffer <= 32'h00000000;
	   v1_buffer <= 32'h003276800;
	   v2_buffer <= 32'h003277000;
		
		rastCycle1 <= draw;
		rastCycle2 <= rastCycle1;
		rastCycle3 <= rastCycle2;
		rastCycle4 <= rastCycle3;
		rastContinue <= (~rastDone) | rastCycle4;
    
	end
	end
				 
	//Single cycle unit					
	VectorComponentExtractor vect0Extract(.in_vector_val(vert0Vector), .clock(clock),
								.out_component0(v0w),
								.out_component1(v0z),
								.out_component2(v0y),
								.out_component3(v0x));
				
	//Multi-cycle unit				
	EdgeRasterizer rasterizer(.clock(clock),								// clock - logic here takes multiple cycles
						.in_sig_start_new_triangle(rastCycle1), 			// control signal to indicate starting new triangle
						.in_sig_get_boundary_coords(rastCycle2), 			// control signal to indicate should get bounding box coordinates of triangle
						.in_sig_form_edges(rastCycle3), 						// control signal to indicate should form initial edge function values
						.in_sig_pixel_loop_setup(rastCycle4),				// control signal to indicate should setup for rasterization loop over pixels
						.in_sig_rasterize_pixels(rastContinue), 			// control signal to indicate actual rasterization computation should occur
						.in_v0_screen_x(v1_buffer[31:16]),
						.in_v0_screen_y(v1_buffer[15:0]),	           	// x, y coordinates of vertex 0
						.in_v1_screen_x(v2_buffer[31:16]), 
						.in_v1_screen_y(v2_buffer[15:0]),		// x, y coordinates of vertex 1
						.in_v2_screen_x(v0x), 
						.in_v2_screen_y(v0y),		// x, y coordinates of vertex 2
						.in_v0_depth(v0depth), .in_v1_depth(v1depth),
						.in_v2_depth(v2depth),									// depth (z-value) for 3 vertices
						.in_color(triangleColor),													// color to use for triangle pixels
						.out_sig_rasterize_write_pixel(writePixel),						// signal to indicate that current output pixel data is a pixel inside triangle that can be written to framebuffer
						.out_sig_rasterize_done(rastDone), 								// signal to indicate rasterization of current triangle is complete
						.out_pixel_x(pixelXout), .out_pixel_y(pixelYout),// x, y coordinates of any output pixels (only pixels inside triangle)
						.out_pixel_depth(pixelDepth),							// depth (z-value) of any output pixels (only pixels inside triangle) - NOT YET IMPLEMENTED
						.out_pixel_color(pixelColor));						// color of any output pixels (only pixels inside triangle));

	//assign HEX0 = pixelYout[3:0];
	//assign HEX1 = pixelYout[7:4];
	//show y-component on hex displays
	sevenSegNum sseg2(.NUM(v0_buffer[3:0]),.DISP(HEX0));
	sevenSegNum sseg3(.NUM(v0_buffer[7:4]),.DISP(HEX1));
	sevenSegNum sseg0(.NUM(v0_buffer[11:8]),.DISP(HEX2));
	sevenSegNum sseg1(.NUM(v0_buffer[15:12]),.DISP(HEX3));


endmodule




