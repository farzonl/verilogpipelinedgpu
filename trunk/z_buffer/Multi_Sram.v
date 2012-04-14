module Multi_Sram(
	oVGA_DATA, iVGA_ADDR, iVGA_READ,
	oGPU_DATA, iGPU_DATA, iGPU_ADDR, iGPU_READ, iGPU_WRITE, iGPU_DEPTH, iGPU_WRITE_PIXEL, 
	//	SRAM
	SRAM_DQ,
	SRAM_ADDR,
	SRAM_UB_N,
	SRAM_LB_N,
	SRAM_WE_N,
	SRAM_CE_N,
	SRAM_OE_N
);

//	VGA Side
input 				iVGA_READ;
input		[17:0]	iVGA_ADDR;
output	[15:0]	oVGA_DATA;

//	GPU Side
input		[17:0]	iGPU_ADDR;
input		[15:0]	iGPU_DATA;
output	[15:0]	oGPU_DATA;
input					iGPU_READ;
input					iGPU_WRITE;
input	[1:0]	iGPU_DEPTH;
input			iGPU_WRITE_PIXEL;

	
//	SRAM Side
inout		[15:0]	SRAM_DQ;
output	[17:0]	SRAM_ADDR;
output				SRAM_UB_N,
						SRAM_LB_N,
						SRAM_WE_N,
						SRAM_CE_N,
						SRAM_OE_N;
						
assign	SRAM_DQ 	=	SRAM_WE_N 	 ?	16'hzzzz  : (iGPU_WRITE ? iGPU_DATA : 16'hzzzz);

assign SRAM_ADDR = iVGA_READ ? iVGA_ADDR : 
								((iGPU_READ | iGPU_WRITE) ? iGPU_ADDR : 0);

assign	SRAM_WE_N = iVGA_READ ? 1'b1 : (iGPU_WRITE ? 1'b0: 1'b1);								
assign	SRAM_CE_N	=	1'b0;
assign	SRAM_UB_N	=	1'b0;
assign	SRAM_LB_N	=	1'b0;
assign	SRAM_OE_N   =  iGPU_WRITE ? 1'bx : 1'b0;

assign oVGA_DATA = iVGA_READ ? SRAM_DQ : 16'h0000;
assign oGPU_DATA = iGPU_READ ? SRAM_DQ : 16'h0000;

endmodule

