// Tests logic to control z-buffering
module z_buffer_test(CLOCK_50, KEY, SW, LEDG, LEDR, HEX0, HEX1, HEX2, HEX3);

	// standard input/out declarations
	input [0:0] CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	output [7:0] LEDG;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3;
	
	// clock stuff
	wire [0:0] clock = !KEY[0];
	
	// test wires
	wire [0:0] writePixel = SW[8];
	wire [0:0] rastDone = SW[9];
	wire [1:0] pixelDepth;
	
	// test registers
	reg [17:0] test_pixel_addr;
	initial test_pixel_addr <= 18'b1;
	//reg [1:0] pixelDepth;
	//initial pixelDepth <= 2'b00;
	reg [15:0] pixelColor;
	initial pixelColor <= 16'h0F00;
	reg [17:0] oMEM_ADDR;
	initial oMEM_ADDR <= 18'b0;
	reg [0:0] oMEM_WRITE;
	initial oMEM_WRITE <= 1'b0;
	reg [15:0] oGPU_DATA;
	initial oGPU_DATA <= 16'b0;
	reg [0:0] oMEM_READ;
	initial oMEM_READ <= 1'b0;
	reg [15:0] iGPU_DATA;
	initial iGPU_DATA <= 16'hC000;
	
	// Z-BUFFER REGISTERS
	reg [1:0] DEPTH_COUNTER;
	initial DEPTH_COUNTER <= 2'b11;
	reg [17:0] oMEM_ADDR_BUFFER;
	initial oMEM_ADDR_BUFFER <= 18'b0;
	reg [0:0] oMEM_WRITE_BUFFER;
	initial oMEM_WRITE_BUFFER <= 1'b0;
	reg [15:0] oGPU_DATA_BUFFER;
	initial oGPU_DATA_BUFFER <= 16'hC000;
	
	always @(posedge clock) begin
		
		// cycle 1 - buffer while we read
		oMEM_ADDR_BUFFER <= test_pixel_addr;
		oMEM_WRITE_BUFFER <= writePixel;
		oGPU_DATA_BUFFER <= { pixelDepth, pixelColor[13:0] };
		
		// cycle 1 - setup read from memory
		oMEM_ADDR <= test_pixel_addr;
		oMEM_WRITE <= 1'b0;
		oGPU_DATA <= { pixelDepth, pixelColor[13:0] };
		oMEM_READ <= writePixel;
		
		// cycle 2 - check data back from memory & write
		if (oGPU_DATA_BUFFER[15:14] <= iGPU_DATA[15:14]) begin
			oMEM_ADDR <= oMEM_ADDR_BUFFER;
			oMEM_WRITE <= oMEM_WRITE_BUFFER;
			oGPU_DATA <= oGPU_DATA_BUFFER;
			oMEM_READ <= writePixel;
		end
		
		// decrement depth if done rasterizing
		if (rastDone) begin
			DEPTH_COUNTER <= DEPTH_COUNTER - 1'b1;
		end
		
		// test controls for altering test "input" register values
		if (SW[0]) begin
			test_pixel_addr <= test_pixel_addr + 18'b1;
		end
		if (SW[1]) begin
			pixelColor <= pixelColor + 16'b1;
		end
		if (SW[2]) begin
			iGPU_DATA <= iGPU_DATA + 16'b1;
		end

	end	
	
	// test final output assignments
	sevenSegNum display0(.DISP(HEX0), .NUM(oGPU_DATA[3:0]));
	sevenSegNum display1(.DISP(HEX1), .NUM(oGPU_DATA[7:4]));
	sevenSegNum display2(.DISP(HEX2), .NUM(oGPU_DATA[11:8]));
	sevenSegNum display3(.DISP(HEX3), .NUM(oGPU_DATA[15:12]));
	
	// other assignments
	assign pixelDepth = DEPTH_COUNTER;
	
	assign LEDG[1:0] = DEPTH_COUNTER;
	
	assign LEDG[3] = oMEM_WRITE_BUFFER;
	
	assign LEDR[9] = rastDone;
	assign LEDR[8] = writePixel;
	
	assign LEDR[0] = SW[0];
	assign LEDR[1] = SW[1];
	assign LEDR[2] = SW[2];
	
	assign LEDR[5] = oMEM_WRITE;
	assign LEDR[6] = oMEM_READ;

endmodule