`define RECTANGLE		4'd7

module gpu_testbench(iGPU_DATA, oGPU_DATA, oMEM_ADDR, oMEM_READ, oMEM_WRITE,  
	iVIDEO_ON, iCLK, iRST_N, iVGA_BLANK, oFPS);

// GPU SRAM interface
input 		 [15:0]	iGPU_DATA;
output	reg [15:0]	oGPU_DATA;
output	reg [17:0]	oMEM_ADDR;
output	reg 			oMEM_WRITE;
output	reg			oMEM_READ;
output   reg [15:0]  oFPS;

input	iVIDEO_ON;
input	iCLK;
input iRST_N;
input iVGA_BLANK;

	wire reset, draw, StartPrim, EndPrim, loop, stall;
	reg NewVertex_delayed;//, NewVertex;
	reg [9:0] rowInd, colInd;
	wire [31:0]instruction, vertex;
	wire [3:0]PrimType;
	wire NewVertex;
	wire [15:0] v0x,v0y,v0z,v0w;
	wire [15:0] v1x,v1y,v1z,v1w;
	wire [15:0] v2x,v2y,v2z,v2w;
	//reg [63:0] vert0Vector;
	wire [63:0] vert0Vector;
	
	reg rastCycle1, rastCycle2, rastCycle3, rastCycle4, rastContinue;
	wire rast1, rast2, rast3, rast4, rastCont;
	wire [1:0] v0depth, v1depth, v2depth, pixelDepth;
	wire [15:0] triangleColor, loop_PC, PC;
	wire writePixel, rastDone;
	wire [15:0] pixelXout, pixelYout, pixelColor;
	reg rast_v1_select;
	reg rast_v2_select;
	
	reg [31:0] v_bufferStage1;
	reg [31:0] v_bufferStage2;
	reg [31:0] primitive1_v0_buffer;
	reg [31:0] primitive1_v1_buffer;
	reg [31:0] primitive1_v2_buffer;
   reg [31:0] primitive1_v3_buffer;
	reg [31:0] primitive1_min;
   reg [31:0] primitive1_max;
   reg [3:0] primitive1_type;
   reg primitive1_valid;
 	reg primitive1_drawn;
	reg blanked1;
	
  
 	reg [31:0] primitive2_v0_buffer;
	reg [31:0] primitive2_v1_buffer;
	reg [31:0] primitive2_v2_buffer;
  reg [31:0] primitive2_v3_buffer;
  reg [31:0] primitive2_min;
  reg [31:0] primitive2_max;
  reg [3:0] primitive2_type;
  reg primitive2_valid;
 	reg primitive2_drawn;
	reg primitive2_drawn_half;
 	
 	reg draw_reg;
   reg current_prim;
	wire [31:0] v0_in;
	wire [31:0] v1_in;
	wire [31:0] v2_in;
	reg primType_delayed;
	
	
	wire [31:0] v0t_buffer;
	wire [31:0] v1t_buffer;
	wire [31:0] v2t_buffer;
	
	wire [3:0] sevenSegOut1;
	wire [3:0] sevenSegOut2;
	
	reg [31:0] counter;
	reg [2:0] vertexCount;
	reg [17:0] i;
	reg [15:0] draw_counter;
	reg [1:0] VS_count;
	reg clock;
	
	reg latch, primRead, blankDone;
	wire V_sync_slow;


	assign triangleColor = 16'h0FFF;
	assign v0depth = 0;
	assign v1depth = 0;
	assign v2depth = 0;
	assign reset = !iRST_N;
	
	/*assign rast1 = iVGA_BLANK ? rastCycle1 : 1'b0;
	assign rast2 = iVGA_BLANK ? rastCycle2 : 1'b0;
	assign rast3 = iVGA_BLANK ? rastCycle3 : 1'b0;
	assign rast4 = iVGA_BLANK ? rastCycle4 : 1'b0;
	assign rastCont = iVGA_BLANK ? rastContinue : 1'b0;*/
	
	assign rast1 = rastCycle1;
	assign rast2 = rastCycle2;
	assign rast3 = rastCycle3;
	assign rast4 = rastCycle4;
	assign rastCont = rastContinue;
	
	
	initial primitive1_v0_buffer = 32'd0;
	initial primitive1_v1_buffer = 32'd0;
	initial primitive1_v2_buffer = 32'd0;
  initial primitive1_v3_buffer = 32'd0;
  
 	initial primitive2_v0_buffer = 32'd0;
	initial primitive2_v1_buffer = 32'd0;
	initial primitive2_v2_buffer = 32'd0;
  initial primitive2_v3_buffer = 32'd0;
  
  initial primitive1_drawn = 0;
  initial primitive2_drawn = 0;
  initial primitive1_valid = 0;
  initial primitive2_valid = 0;
  initial primitive1_type = 4'd0;
  initial primitive2_type = 4'd0;
  initial primitive2_drawn_half = 0;
  initial rast_v1_select = 0;
  initial rast_v2_select = 0;
  initial rowInd = 0;
  initial colInd = 0;
  initial blankDone = 1;
  initial VS_count = 0;
  initial draw_counter = 16'd0;
  
	
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
	initial draw_reg = 1'b0;
	
	assign stall = /*!iVGA_BLANK |*/ !blankDone |  rastCycle1 | rastCycle2 | rastCycle3 | rastCycle4 | rastContinue;
	
	assign V_sync_slow = (VS_count==2'b11) ? 1'b1 : 1'b0;
	
	/*always @ (posedge iCLK) begin
		//counter for V-sync
		//gives a V-sync that goes high every 4th v-sync
		clock <= clock + 1'b1;
	end*/
	
				 
	always @ (posedge iCLK or posedge reset) begin
	
	
	//resets frame buffer to all 0's when KEY[0] is pressed
	if(reset)
	begin
		oMEM_ADDR <= 16'h0000;
		oMEM_WRITE <= 1'b1;
		oMEM_READ <= 1'b0;
		oGPU_DATA <= {4'h0, 4'hF, 4'h0, 4'h0};		
	end else begin
	
		//Set drawn and valid flags to 0. This will be reset later in the code if needed.
		if (!iVIDEO_ON) begin 

		//if (iVGA_BLANK) begin

		if(StartPrim==1'b1) begin 
		  primitive2_drawn <= 1'b0;
		  primitive2_drawn_half <= 1'b0;
		  primitive1_drawn <= 1'b0;
		  primitive1_valid <= 1'b0;
		  primitive2_valid <= 1'b0;
		  current_prim <= current_prim + 1'b1;
		  if(current_prim==1'b0) primitive1_type <= PrimType;
		  else primitive2_type <= PrimType;
		end
	  
	  primType_delayed <= PrimType;
	  
	  
		//Only do anything during vblank. Otherwise, screen will tear.
		
		draw_counter <= draw_counter + 1'b1;
		//if(iVGA_BLANK) begin
			if(blankDone==1'b0) begin
				oMEM_ADDR <= rowInd*640 + colInd;
				oMEM_WRITE <= 1'b1;
				oMEM_READ <= 1'b0;
				oGPU_DATA <= {4'hC, 4'h0, 4'h0, 4'h0};
				//if(draw==1'b1) draw_reg <= 1'b1;
			end
			else begin
				oMEM_ADDR <= pixelYout*18'd640 + pixelXout;
				oMEM_WRITE <= writePixel;
				oGPU_DATA <= pixelColor;//16'hFFFF;
				oMEM_READ <= 1'b0;
			end
		//end
	
		if(!blanked1) begin
			if(rowInd==primitive1_max[31:16] && colInd==primitive1_max[15:0]) blanked1 <=1'b1;
			else blanked1 <= 1'b0;
		end else
		if(rowInd==primitive2_max[31:16] && colInd==primitive2_max[15:0]) blankDone <=1'b1;
		else blankDone <= 1'b0;
		
		
		if(draw==1'b1) begin 
			//oFPS <= 32'd25200000/draw_counter;
			draw_reg <=1'b1;
			blankDone <= 1'b0;
			//reset draw counter;
			draw_counter <= 16'd0;
		end else if (((primitive2_drawn & primitive2_valid) | !primitive2_valid) &
					 ((primitive1_drawn & primitive1_valid) | !primitive1_valid)) draw_reg<=0;
					 
					 
		counter <= counter+1;
		
		//delay signal for 1 cycle to allow Converter to do its thing
		NewVertex_delayed <= NewVertex;
		
		//delay draw for 2 cycles on the off chance that the last instruction set a vertex.
		//draw_delayed2 <= draw_delayed1;
		//draw_delayed1 <= draw;
		
		if(NewVertex_delayed) begin
		  
		  if(primitive1_valid==0) begin
		
				if(vertexCount==0) begin
					primitive1_min <= {v0x, v0y};
					primitive1_max <= {v0x, v0y};
					primitive1_v0_buffer <= {v0x, v0y};
					vertexCount <= vertexCount + 1'b1;
				end else
				if(vertexCount==1) begin
					if(v0x<primitive1_min[31:16]) primitive1_min[31:16] <= v0x;
					else if(v0x>primitive1_max[31:16]) primitive1_max[31:16] <= v0x;
					if(v0y<primitive1_min[15:0]) primitive1_min[15:0] <= v0y;
					else if(v0y>primitive1_max[15:0]) primitive1_max[15:0] <= v0y;
					
					primitive1_v1_buffer <= {v0x, v0y};
					vertexCount <= vertexCount + 1'b1;
				end else
				if(vertexCount==2) begin
					if(v0x<primitive1_min[31:16]) primitive1_min[31:16] <= v0x;
					else if(v0x>primitive1_max[31:16]) primitive1_max[31:16] <= v0x;
					if(v0y<primitive1_min[15:0]) primitive1_min[15:0] <= v0y;
					else if(v0y>primitive1_max[15:0]) primitive1_max[15:0] <= v0y;
					
					primitive1_v2_buffer[31:16]<=v0x;
					primitive1_v2_buffer[15:0]<=v0y;
					vertexCount <= vertexCount + 1'b1;
					primitive1_valid <= 1'b1;
				end else if(vertexCount==3)begin 
					if(v0x<primitive1_min[31:16]) primitive1_min[31:16] <= v0x;
					else if(v0x>primitive1_max[31:16]) primitive1_max[31:16] <= v0x;
					if(v0y<primitive1_min[15:0]) primitive1_min[15:0] <= v0y;
					else if(v0y>primitive1_max[15:0]) primitive1_max[15:0] <= v0y;
					
				  if(primitive1_type == `RECTANGLE) begin
					  primitive1_v3_buffer[31:16]<=v0x;
					  primitive1_v3_buffer[15:0]<=v0y;
				  end
				  vertexCount <= 3'd0;
				  primitive1_valid <= 1'b1;
				end
  			
			end else if (primitive2_valid==0) begin

			  
				if(vertexCount==0) begin
					primitive2_min <= {v0x, v0y};
					primitive2_max <= {v0x, v0y};					
					primitive2_v1_buffer[31:16]<=v0x;
					primitive2_v1_buffer[15:0]<=v0y;
					vertexCount <= vertexCount + 1'b1;
				end
				if(vertexCount==1) begin
					if(v0x<primitive2_min[31:16]) primitive2_min[31:16] <= v0x;
					else if(v0x>primitive2_max[31:16]) primitive2_max[31:16] <= v0x;
					if(v0y<primitive2_min[15:0]) primitive2_min[15:0] <= v0y;
					else if(v0y>primitive1_max[15:0]) primitive2_max[15:0] <= v0y;
					
					primitive2_v2_buffer[31:16]<=v0x;
					primitive2_v2_buffer[15:0]<=v0y;
					vertexCount <= vertexCount + 1'b1;
				end
				if(vertexCount==2) begin
					if(v0x<primitive2_min[31:16]) primitive2_min[31:16] <= v0x;
					else if(v0x>primitive2_max[31:16]) primitive2_max[31:16] <= v0x;
					if(v0y<primitive2_min[15:0]) primitive2_min[15:0] <= v0y;
					else if(v0y>primitive1_max[15:0]) primitive2_max[15:0] <= v0y;
					
					primitive2_v0_buffer[31:16]<=v0x;
					primitive2_v0_buffer[15:0]<=v0y;
					vertexCount <= vertexCount + 1'b1;
				end
				if(vertexCount==3)begin 
					if(v0x<primitive2_min[31:16]) primitive2_min[31:16] <= v0x;
					else if(v0x>primitive2_max[31:16]) primitive2_max[31:16] <= v0x;
					if(v0y<primitive2_min[15:0]) primitive2_min[15:0] <= v0y;
					else if(v0y>primitive1_max[15:0]) primitive2_max[15:0] <= v0y;
					
				  if(primitive2_type == `RECTANGLE) begin
					  primitive2_v3_buffer[31:16]<=v0x;
					  primitive2_v3_buffer[15:0]<=v0y;
				  end
				  vertexCount <= 3'd0;
				  primitive2_valid <= 1'b1;
				end
		   end
		end
		
		rastCycle1 <= !stall & draw_reg;
		rastCycle2 <= rastCycle1;
		rastCycle3 <= rastCycle2;
		rastCycle4 <= rastCycle3;
		if(rastCycle4==1'b1) rastContinue <= 1'b1;
		else if(rastContinue==1'b1 && rastDone==1'b0) rastContinue <= 1'b1;
		else rastContinue <=1'b0;
		
		
		
		//if(counter==2) vert0Vector[63:32] <= 32'h00800080;
		//if(counter==1) vert0Vector[63:32] <= 32'h01000080;
		//if(counter==0) vert0Vector[63:32] <= 32'h00800100;
		//if(counter>2) NewVertex <= 1'b0;
		//else NewVertex <=1'b1;
		
		  
		//control signals for muxes. v0 is hardwired into v0 of the rasterizer
		//A value of 1 selects the alternate vertex for drawing the other half of
		// a restangle (v0,v2,v3). 0 selects (v0,v1,v2).
		
		if(primitive2_valid==1'b1 && primitive1_drawn==1'b1 && primitive1_valid==1'b1 && primitive2_drawn==1'b0) current_prim <= 1'b1;
	   else current_prim <= 1'b0;

		//rastDone will be asserted after initial 1/2 of prim1 is drawn.
		if(rastDone==1'b1 && primitive1_drawn==1'b0 && primitive1_valid==1'b1) begin
			 if(primitive1_type==`RECTANGLE) begin
				 //select alternate set of vertices
				 rast_v1_select <= 1'b1;
				 rast_v2_select <= 1'b1;
			 end else begin
				 primitive1_drawn <= 1'b1;
			 end	
	   //This will not automatically draw the 1st half of the triangle, as it happens after primitive 1.
		end else if(rastDone==1'b1 && primitive2_drawn==1'b0 && primitive2_valid==1'b1)
		  if(primitive2_type==`RECTANGLE && primitive2_drawn_half==1'b0) begin
		    //select alternate set of vertices
		    rast_v1_select <= 1'b1;
		    rast_v2_select <= 1'b1;
			 primitive2_drawn_half <= 1'b1;
		  end else begin
			 //If not a rectangle, draw using first 3 vertices.
		    rast_v1_select <= 1'b0;
		    rast_v2_select <= 1'b0; 
		    primitive2_drawn <= 1'b1;
		  end	
		end
		end
	//end
	end
	
	assign v0_in = (current_prim==1'b0) ? primitive1_v0_buffer : primitive2_v0_buffer;
	
	assign v1_in = (current_prim==1'b0) ? ( (rast_v1_select==1'b0) ? primitive1_v1_buffer : primitive1_v2_buffer )
	                        : ( (rast_v1_select==1'b0) ? primitive2_v1_buffer : primitive2_v2_buffer );
	                        
	assign v2_in = (current_prim==1'b0) ? ( (rast_v2_select==1'b0) ? primitive1_v2_buffer : primitive1_v3_buffer )
	                        : ( (rast_v2_select==1'b0) ? primitive2_v2_buffer : primitive2_v3_buffer );
	
	assign v0t_buffer = 32'h00640019;
	assign v1t_buffer = 32'h0067001d;
	assign v2t_buffer = 32'h0061001d;
	
				 
				
	//Multi-cycle unit				
	EdgeRasterizer rasterizer(.clock(iCLK),								// clock - logic here takes multiple cycles
						.in_sig_start_new_triangle(rast1), 			// control signal to indicate starting new triangle
						.in_sig_get_boundary_coords(rast2), 			// control signal to indicate should get bounding box coordinates of triangle
						.in_sig_form_edges(rast3), 						// control signal to indicate should form initial edge function values
						.in_sig_pixel_loop_setup(rast4),				// control signal to indicate should setup for rasterization loop over pixels
						.in_sig_rasterize_pixels(rastCont), 			// control signal to indicate actual rasterization computation should occur
						.in_v0_screen_x(v0_in[31:16]),
						.in_v0_screen_y(v0_in[15:0]),	   // x, y coordinates of vertex 0
						.in_v1_screen_x(v1_in[31:16]), 
						.in_v1_screen_y(v1_in[15:0]),		// x, y coordinates of vertex 1
						.in_v2_screen_x(v2_in[31:16]), 
						.in_v2_screen_y(v2_in[15:0]),		// x, y coordinates of vertex 2
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
	
	
	always@(posedge iCLK or posedge reset)
begin
	if(reset)
	begin
		colInd		<=	blanked1 ? primitive2_min[15:0] : primitive1_min[15:0];
	end
	else if (!iVIDEO_ON && blankDone==1'b0)
	begin
		if( colInd < ( blanked1 ? primitive2_max[15:0] : primitive1_max[15:0] ) )
		colInd	<=	colInd+1;
		else
		colInd	<=	0;
	end
end

always@(posedge iCLK or posedge reset)
begin
	if(reset)
	begin
		rowInd		<=	blanked1 ? primitive2_min[31:16] : primitive1_min[31:16];
	end
	else if (!iVIDEO_ON && blankDone==1'b0)
	begin
		if(colInd==0)
		begin
			if( rowInd < ( blanked1 ? primitive2_max[31:16] : primitive1_max[31:16] ))
			rowInd	<=	rowInd+1;
			else
			rowInd	<=	0;
		end
	end
end


endmodule





