

module gpu_testbench(iGPU_DATA, oGPU_DATA, oMEM_ADDR, oMEM_READ, oMEM_WRITE,  
	iVIDEO_ON, iCLK, iRST_N);

// GPU SRAM interface
input 		 [15:0]	iGPU_DATA;
output	reg [15:0]	oGPU_DATA;
output	reg [17:0]	oMEM_ADDR;
output	reg 			oMEM_WRITE;
output	reg			oMEM_READ;

input	iVIDEO_ON;
input	iCLK;
input iRST_N;
//assign reset = iRST_N;

	wire reset, draw, StartPrim, EndPrim, loop, stall;
	reg NewVertex_delayed;//, NewVertex;
	wire [31:0]instruction, vertex;
	wire [3:0]PrimType;
	wire NewVertex;
	wire [15:0] v0x,v0y,v0z,v0w;
	wire [15:0] v1x,v1y,v1z,v1w;
	wire [15:0] v2x,v2y,v2z,v2w;
	//reg [63:0] vert0Vector;
	wire [63:0] vert0Vector;
	
	reg rastCycle1, rastCycle2, rastCycle3, rastCycle4, rastContinue;
	wire [1:0] v0depth, v1depth, v2depth, pixelDepth;
	wire [15:0] triangleColor, loop_PC, PC;
	wire writePixel, rastDone;
	wire [15:0] pixelXout, pixelYout, pixelColor;
	
	reg [31:0] v_bufferStage1;
	reg [31:0] v_bufferStage2;
	reg [31:0] v0_buffer;
	reg [31:0] v1_buffer;
	reg [31:0] v2_buffer;
	
	wire [31:0] v0t_buffer;
	wire [31:0] v1t_buffer;
	wire [31:0] v2t_buffer;
	
	wire [3:0] sevenSegOut1;
	wire [3:0] sevenSegOut2;
	
	reg [31:0] counter;
	reg [2:0] vertexCount;
	
	reg latch, primRead;


	assign triangleColor = 16'h0F00;
	assign v0depth = 0;
	assign v1depth = 0;
	assign v2depth = 0;
	
	
	initial v0_buffer = 32'd0;
	initial v1_buffer = 32'd0;
	initial v2_buffer = 32'd0;
	
	initial vertexCount = 3'b000;

	
	FE fetch(.reset(reset),.CLOCK_50(iCLK),
				.Stall(stall),
				.id_instr(instruction),
				.Loop(loop),
				.PC_in(loop_PC),
				.PC_out(PC));
				
				
	ID decode(.RESET(reset),.CLK(iCLK),
				 .Stall(stall),
				 .Instruction(instruction),
				 .Vertex(vert0Vector),
				 .StartPrimitive(StartPrim),
				 .EndPrimitive(EndPrim),
				 .PrimitiveType(PrimType),
				 .Draw(draw),.Loop(loop),
				 .PC(PC),.PC_Out(loop_PC),
				 .NewVertex(NewVertex));
				 
				 	//Single cycle unit					
	VectorComponentExtractor vect0Extract(.in_vector_val(vert0Vector), .clock(iCLK),
								.out_component0(v0w),
								.out_component1(v0z),
								.out_component2(v0y),
								.out_component3(v0x));
				 
	initial rastCycle1 = 1'b0;
	initial rastCycle2 = 1'b0;
	initial rastCycle3 = 1'b0;
	initial rastCycle4 = 1'b0;
	initial rastContinue = 1'b0;
	initial counter = 32'd0;
	initial NewVertex_delayed = 1'b0;
	
	assign stall = rastCycle1 | rastCycle2 | rastCycle3 | rastCycle4 | rastContinue;
				 
	always @ (posedge iCLK) begin
	//if (!iVIDEO_ON) begin
		counter <= counter+1;
		
		//delay signal for 1 cycle to allow Converter to do its thing
		NewVertex_delayed <= NewVertex;
		
		//delay draw for 2 cycles on the off chance that the last instruction set a vertex.
		//draw_delayed2 <= draw_delayed1;
		//draw_delayed1 <= draw;
		
		if(NewVertex_delayed) begin
		
			if(vertexCount==0) begin
				v1_buffer[31:16]<=v0x;
				v1_buffer[15:0]<=v0y;
			end
			if(vertexCount==1) begin
				v2_buffer[31:16]<=v0x;
				v2_buffer[15:0]<=v0y;
			end
			if(vertexCount==2) begin
				v0_buffer[31:16]<=v0x;
				v0_buffer[15:0]<=v0y;
			end
			
			if(vertexCount<2) vertexCount <= vertexCount + 1'b1;
			else vertexCount <= 3'd0;
		
		end
		
		
		
		//if(counter==2) vert0Vector[63:32] <= 32'h00800080;
		//if(counter==1) vert0Vector[63:32] <= 32'h01000080;
		//if(counter==0) vert0Vector[63:32] <= 32'h00800100;
		//if(counter>2) NewVertex <= 1'b0;
		//else NewVertex <=1'b1;
		  
			oMEM_ADDR <= pixelYout*18'd640 + pixelXout;
			oMEM_WRITE <= writePixel;
			oGPU_DATA <= pixelColor;//16'hFFFF;
			oMEM_READ <= 1'b0;
		
		
		rastCycle1 <= (~stall) & draw;
		//if(counter==1)rastCycle1<=1'b1;
		//else 
	  //if(counter==16'd6)rastCycle1<=1'b1;
		//else rastCycle1<=1'b0;
		rastCycle2 <= rastCycle1;
		rastCycle3 <= rastCycle2;
		rastCycle4 <= rastCycle3;
		if(rastCycle4==1'b1) rastContinue <= 1'b1;
		else if(rastContinue==1'b1 && rastDone==1'b0) rastContinue <= 1'b1;
		else rastContinue <=1'b0;
    
	//end
	end
	
	assign v0t_buffer = 32'h00640019;
	assign v1t_buffer = 32'h0067001d;
	assign v2t_buffer = 32'h0061001d;
				 
				
	//Multi-cycle unit				
	EdgeRasterizer rasterizer(.clock(iCLK),								// clock - logic here takes multiple cycles
						.in_sig_start_new_triangle(rastCycle1), 			// control signal to indicate starting new triangle
						.in_sig_get_boundary_coords(rastCycle2), 			// control signal to indicate should get bounding box coordinates of triangle
						.in_sig_form_edges(rastCycle3), 						// control signal to indicate should form initial edge function values
						.in_sig_pixel_loop_setup(rastCycle4),				// control signal to indicate should setup for rasterization loop over pixels
						.in_sig_rasterize_pixels(rastContinue), 			// control signal to indicate actual rasterization computation should occur
						.in_v0_screen_x(v0_buffer[31:16]),
						.in_v0_screen_y(v0_buffer[15:0]),	           	// x, y coordinates of vertex 0
						.in_v1_screen_x(v1_buffer[31:16]), 
						.in_v1_screen_y(v1_buffer[15:0]),		// x, y coordinates of vertex 1
						.in_v2_screen_x(v2_buffer[31:16]), 
						.in_v2_screen_y(v2_buffer[15:0]),		// x, y coordinates of vertex 2
						.in_v0_depth(v0depth),
						.in_v1_depth(v1depth),
						.in_v2_depth(v2depth),									// depth (z-value) for 3 vertices
						.in_color(triangleColor),								// color to use for triangle pixels
						.out_sig_rasterize_write_pixel(writePixel),		// signal to indicate that current output pixel data is a pixel inside triangle that can be written to framebuffer
						.out_sig_rasterize_done(rastDone), 					// signal to indicate rasterization of current triangle is complete
						.out_pixel_x(pixelXout), .out_pixel_y(pixelYout),// x, y coordinates of any output pixels (only pixels inside triangle)
						.out_pixel_depth(pixelDepth),							// depth (z-value) of any output pixels (only pixels inside triangle) - NOT YET IMPLEMENTED
						.out_pixel_color(pixelColor));						// color of any output pixels (only pixels inside triangle));

	//assign HEX0 = pixelYout[3:0];
	//assign HEX1 = pixelYout[7:4];
	//show y-component on hex displays
	/*sevenSegNum sseg2(.NUM(v0_buffer[3:0]),.DISP(HEX0));
	sevenSegNum sseg3(.NUM(v0_buffer[7:4]),.DISP(HEX1));
	sevenSegNum sseg0(.NUM(v0_buffer[11:8]),.DISP(HEX2));
	sevenSegNum sseg1(.NUM(v0_buffer[15:12]),.DISP(HEX3));*/


endmodule




