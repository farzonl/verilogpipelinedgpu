// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE1 Default Code
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 06/04/25  :|      Initial Revision
// --------------------------------------------------------------------

module DE1_Default
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_24,						//	24 MHz
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[9:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[7:0]
		LEDR,							//	LED Red[9:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 22 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N,						//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,						//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	    TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_R,   						//	VGA Red[3:0]
		VGA_G,	 						//	VGA Green[3:0]
		VGA_B,  						//	VGA Blue[3:0]
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,						//	Audio CODEC Chip Clock
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
input	[1:0]	CLOCK_24;				//	24 MHz
input	[1:0]	CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[9:0]	SW;						//	Toggle Switch[9:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
////////////////////////////	LED		////////////////////////////
output	[7:0]	LEDG;					//	LED Green[7:0]
output	[9:0]	LEDR;					//	LED Red[9:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD;				//	UART Transmitter
input			UART_RXD;				//	UART Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output	[21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask 
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	SD Card Interface	////////////////////////
inout			SD_DAT;					//	SD Card Data
inout			SD_DAT3;				//	SD Card Data 3
inout			SD_CMD;					//	SD Card Command Signal
output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 	PS2_DAT;				//	PS2 Data
input			PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					// CPLD -> FPGA (data in)
input  			TCK;					// CPLD -> FPGA (clk)
input  			TCS;					// CPLD -> FPGA (CS)
output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output	[3:0]	VGA_R;   				//	VGA Red[3:0]
output	[3:0]	VGA_G;	 				//	VGA Green[3:0]
output	[3:0]	VGA_B;   				//	VGA Blue[3:0]
////////////////////	Audio CODEC		////////////////////////////
output			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
output			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////////////////////////////////////////////////

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;

//	Audio
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

wire	[15:0]	mSEG7_DIG;
wire 			VIDEO_ON;
wire			VGA_CTRL_CLK;
wire        AUD_CTRL_CLK;

// VGA Connector Wires
wire 	[17:0]	mVGA_ADDR;
wire	[15:0]	mVGA_DATA;
wire	[9:0]		mVGA_X;
wire	[9:0]		mVGA_Y;
wire	[3:0]		mVGA_R;
wire	[3:0]		mVGA_G;
wire	[3:0]		mVGA_B;

reg		[27:0]	Cont;
reg		[9:0]	mLEDR;
reg				ST;

// GPU Connector Wires
wire				mGPU_READ;
wire				mGPU_WRITE;
wire 	[17:0]	mGPU_ADDR;
wire	[15:0]	mGPU_WRITE_DATA;
wire  [15:0]	mGPU_READ_DATA;
wire	[1:0]	mGPU_DEPTH;
wire			mGPU_WRITE_PIXEL;

always@(posedge CLOCK_50)		Cont	<=	Cont+1'b1;

assign	mSEG7_DIG	=	{4'h1, 4'h2, 4'h3, 4'h4};

SEG7_LUT_4 			u0	(	HEX0,HEX1,HEX2,HEX3,mGPU_WRITE_DATA );

VGA_Audio_PLL 		u1	(	.inclk0(CLOCK_27[0]),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK)	);

//assign VGA_CTRL_CLK = KEY[0];

VGA_Controller	u2	(	//	Host Side				
							.oCoord_X(mVGA_X),
							.oCoord_Y(mVGA_Y),
							.iRed(mVGA_R),
							.iGreen(mVGA_G),
							.iBlue(mVGA_B),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(KEY[0])	
);

gpu_testbench u3 (

	.iGPU_DATA(mGPU_READ_DATA), .oGPU_DATA(mGPU_WRITE_DATA), .oMEM_ADDR(mGPU_ADDR), .oMEM_READ(mGPU_READ), .oMEM_WRITE(mGPU_WRITE),  
	.iVIDEO_ON(VIDEO_ON), .iCLK(VGA_CTRL_CLK),.iRST_N(KEY[0]),
	.oMEM_DEPTH(mGPU_DEPTH), .oMEM_WRITE_PIXEL(mGPU_WRITE_PIXEL)
);

// possible stuff related to z-buffering
// no clue if this works - we probably need to have more complex control logic
reg [15:0] pixel_addr, pixel_color;
reg [1:0] pixel_depth;
reg write_pixel;

always @(posedge VGA_CTRL_CLK) begin
	// save output from gpu_testbench
	if (mGPU_WRITE_PIXEL) begin
		pixel_addr <= mGPU_ADDR;
		pixel_color <= mGPU_WRITE_DATA;
		pixel_depth <= mGPU_DEPTH;
		write_pixel <= mGPU_WRITE_PIXEL;
	end
	// check data from framebuffer to make sure depth is less than output depth
	// below comparison assumes using top 2 bits of SRAM value as depth
	if (write_pixel && pixel_depth >= SRAM_DQ[15:14]) begin
		// copy pixel_addr, pixel_color to appropriate SRAM inputs
		// and assert write signal
		write_pixel <= 1'b0;	// for now, just turn off to give this if statement something to do
	end
end

PixelGen u4 (
			.iData(mVGA_DATA),
			.iCoordX(mVGA_X),
			.iCoordY(mVGA_Y),
			// SRAM Address Data
			.oNext_Addr(mVGA_ADDR),
			.oRed(mVGA_R),
			.oGreen(mVGA_G),
			.oBlue(mVGA_B),
			.oVIDEO_ON(VIDEO_ON),
			//	Control Signal
			.iCLK(VGA_CTRL_CLK),
			.iRST_N(KEY[0])
);


Multi_Sram u5 (	
			.iGPU_DEPTH(mGPU_DEPTH), .iGPU_WRITE_PIXEL(mGPU_WRITE_PIXEL), 
			//	VGA Side
			.oVGA_DATA(mVGA_DATA),.iVGA_ADDR(mVGA_ADDR), .iVGA_READ(VIDEO_ON),
			//	GPU Side
			.oGPU_DATA(mGPU_READ_DATA), .iGPU_DATA(mGPU_WRITE_DATA), .iGPU_ADDR(mGPU_ADDR), .iGPU_WRITE(mGPU_WRITE), .iGPU_READ(mGPU_READ), 
			//	SRAM
			.SRAM_DQ(SRAM_DQ),
			.SRAM_ADDR(SRAM_ADDR),
			.SRAM_UB_N(SRAM_UB_N),
			.SRAM_LB_N(SRAM_LB_N),
			.SRAM_WE_N(SRAM_WE_N),
			.SRAM_CE_N(SRAM_CE_N),
			.SRAM_OE_N(SRAM_OE_N)
);

endmodule
