`define ADD_D			5'b00000
`define ADDI_D			5'b00001
`define ADD_F			5'b00010
`define ADDI_F			5'b00011
`define SUB_D			5'b00100
`define SUBI_D			5'b00101
`define SUB_F			5'b00110
`define SUBI_F			5'b00111
`define MOV				5'b01000
`define MOVI			5'b01001
`define MOVI_F			5'b01010
`define VMOV			5'b01011
`define VMOVI			5'b01100
`define VCOMPMOV		5'b01101
`define VCOMPMOVI		5'b01110
`define SETVERTEX		5'b01111
`define COLOR			5'b10000
`define ROTATE			5'b10001
`define TRANSLATE		5'b10010
`define SCALE			5'b10011
`define PUSHMATRIX		5'b10100
`define POPMATRIX		5'b10101
`define STARTPRIMITIVE	5'b10110
`define ENDPRIMITIVE	5'b10111
`define LOADIDENTITY	5'b11000
`define DRAW			5'b11001
`define STARTLOOP		5'b11010
`define ENDLOOP			5'b11011
`define LOOPCOUNT		5'b11100
`define INVALID			5'b11101

`define IDENTITYMATRIX	255'h0001000000000000000000010000000000000000000100000000000000000001

module ID(CLK,Instruction,RESET,Stall,Vertex,StartPrimitive,PrimitiveType,EndPrimitive,Draw,PC, PC_Out, Loop, NewVertex,NewColor);
input CLK,RESET,Stall;
input[15:0] PC;
output[15:0] PC_Out;
output Loop;
input[31:0] Instruction;
output reg[63:0] Vertex; //Assuming X=Vertex[15:0], Y=Vertex[31:16]
output reg StartPrimitive,EndPrimitive,Draw,NewVertex,NewColor;
output reg[3:0] PrimitiveType;

/*
State Matrix =
[ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
[ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
[ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
[ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
*/
reg[255:0] StateMatrix;
reg[255:0] MatrixStack[0:15];
reg[3:0] MatrixStackPointer;

initial begin
	MatrixStackPointer = 4'b0;
	StateMatrix = `IDENTITYMATRIX;
end

wire Vec_WEnable,Int_WEnable,VComp_WEnable,FP_WEnable, LP_WEnable;
wire[1:0] idx;
wire[4:0] op;
wire[63:0] Vec_DR_Val, Vec_SR1_Val;
wire[5:0] Vec_DR_Num, Vec_SR1_Num;
wire[15:0] Int_DR_Val, Int_SR1_Val, Int_SR2_Val, VComp_Val, FP_DR_Val, FP_SR1_Val, FP_SR2_Val, LP_STR_Val;
wire[3:0] Int_DR_Num, Int_SR1_Num, Int_SR2_Num, FP_DR_Num, FP_SR1_Num, FP_SR2_Num;
wire[15:0] Immediate;
wire[15:0] Cosine_Result, Sine_Result;

assign Vec_DR_Num = Instruction[21:16];
assign Vec_SR1_Num = (op == `SETVERTEX || op == `COLOR || op == `ROTATE || op == `TRANSLATE || op == `SCALE) ? Instruction[21:16] : Instruction[11:8];

assign Int_DR_Num = (op == `MOV) ? Int_SR1_Num : Instruction[23:20];
assign Int_SR1_Num = Instruction[19:16];
assign Int_SR2_Num = Instruction[11:8];

assign FP_DR_Num = Instruction[23:20];
assign FP_SR1_Num = Int_SR1_Num;
assign FP_SR2_Num = Int_SR2_Num;

reg [15:0] LP_Count, LP_Start;


vector_regfile #(.REG_WIDTH(64),.REG_COUNT(64),.REG_NUM_WIDTH(6)) vector_regs(.CLK(CLK),.DR_NUM(Vec_DR_Num),.DR_VAL(Vec_DR_Val),.SRC1_NUM(Vec_SR1_Num),.SRC1_VAL(Vec_SR1_Val),.RESET(RESET),.WENABLE(Vec_WEnable),.COMP_WENABLE(VComp_WEnable),.IDX(idx),.COMP_VAL(VComp_Val));
regfile #(.REG_WIDTH(16),.REG_COUNT(8),.REG_NUM_WIDTH(4)) int_regs(.CLK(CLK),.DR_NUM(Int_DR_Num),.DR_VAL(Int_DR_Val),.SRC1_NUM(Int_SR1_Num),.SRC1_VAL(Int_SR1_Val),.SRC2_NUM(Int_SR2_Num),.SRC2_VAL(Int_SR2_Val),.RESET(RESET),.WENABLE(Int_WEnable));
regfile #(.REG_WIDTH(16),.REG_COUNT(8),.REG_NUM_WIDTH(4)) fp_regs(.CLK(CLK),.DR_NUM(FP_DR_Num),.DR_VAL(FP_DR_Val),.SRC1_NUM(FP_SR1_Num),.SRC1_VAL(FP_SR1_Val),.SRC2_NUM(FP_SR2_Num),.SRC2_VAL(FP_SR2_Val),.RESET(RESET),.WENABLE(FP_WEnable));

cosine_LUT Cosine(.INVAL(Vec_SR1_Val[15:0]),.OUTVAL(Cosine_Result));
sine_LUT Sine(.INVAL(Vec_SR1_Val[15:0]),.OUTVAL(Sine_Result));

assign Immediate = Instruction[15:0];

assign idx = Instruction[23:22];

assign op = (Instruction[31:24] == 8'b00000000) ? `ADD_D :
			(Instruction[31:24] == 8'b00000001) ? `ADDI_D :
			(Instruction[31:24] == 8'b00000100) ? `ADD_F :
			(Instruction[31:24] == 8'b00000101) ? `ADDI_F :
			(Instruction[31:24] == 8'b00001000) ? `SUB_D :
			(Instruction[31:24] == 8'b00001001) ? `SUBI_D :
			(Instruction[31:24] == 8'b00001100) ? `SUB_F :
			(Instruction[31:24] == 8'b00001101) ? `SUBI_F :
			(Instruction[31:24] == 8'b00010000) ? `MOV :
			(Instruction[31:24] == 8'b00010001) ? `MOVI :
			(Instruction[31:24] == 8'b00010101) ? `MOVI_F :
			(Instruction[31:24] == 8'b00010010) ? `VMOV :
			(Instruction[31:24] == 8'b00010011) ? `VMOVI :
			(Instruction[31:24] == 8'b00100010) ? `VCOMPMOV :
			(Instruction[31:24] == 8'b00100011) ? `VCOMPMOVI :
			(Instruction[31:24] == 8'b01000010) ? `SETVERTEX :
			(Instruction[31:24] == 8'b01001010) ? `COLOR :
			(Instruction[31:24] == 8'b01010010) ? `ROTATE :
			(Instruction[31:24] == 8'b01011010) ? `TRANSLATE :
			(Instruction[31:24] == 8'b01100010) ? `SCALE :
			(Instruction[31:24] == 8'b10000000) ? `PUSHMATRIX :
			(Instruction[31:24] == 8'b10001000) ? `POPMATRIX :
			(Instruction[31:24] == 8'b10010001) ? `STARTPRIMITIVE :
			(Instruction[31:24] == 8'b10011000) ? `ENDPRIMITIVE :
			(Instruction[31:24] == 8'b10100000) ? `LOADIDENTITY :
			(Instruction[31:24] == 8'b10111000) ? `DRAW :
			(Instruction[31:24] == 8'b11000000) ? `STARTLOOP :
			(Instruction[31:24] == 8'b11001000) ? `ENDLOOP :
			(Instruction[31:24] == 8'b11010001) ? `LOOPCOUNT :
			`INVALID;

assign Int_DR_Val = (op == `ADD_D) ? Int_SR1_Val + Int_SR2_Val :
					(op == `SUB_D) ? Int_SR1_Val - Int_SR2_Val :
					(op == `ADDI_D) ? Int_SR1_Val + Immediate :
					(op == `SUBI_D) ? Int_SR1_Val - Immediate :
					(op == `MOV) ? Int_SR2_Val :
					(op == `MOVI) ? Immediate :
					16'hXXXX;

assign Int_WEnable = (op == `ADD_D || op == `SUB_D || op == `ADDI_D || op == `SUBI_D || op == `MOV || op == `MOVI) ? 1'b1 : 1'b0;

assign FP_DR_Val = (op ==`ADD_F) ? FP_SR1_Val + FP_SR2_Val :
				   (op ==`SUB_F) ? FP_SR1_Val - FP_SR2_Val :
				   (op ==`ADDI_F) ? FP_SR1_Val + Immediate :
				   (op ==`SUBI_F) ? FP_SR1_Val - Immediate :
				   (op ==`MOVI_F) ? Immediate :
				   16'hXXXX;

assign FP_WEnable = (op == `ADD_F || op == `SUB_F || op == `ADDI_F || op == `SUBI_F || op == `MOVI_F) ? 1'b1 : 1'b0;
			
assign Vec_WEnable = (op == `VMOV || op ==`VMOVI) ? 1'b1 : 1'b0;

assign Vec_DR_Val = (op == `VMOV) ? Vec_SR1_Val : 
					(op == `VMOVI) ? {Immediate, Immediate, Immediate, Immediate} :
					64'hXXXXXXXXXXXXXXXX;

assign VComp_WEnable = (op == `VCOMPMOV || op == `VCOMPMOVI) ? 1'b1 : 1'b0;

assign VComp_Val = (op == `VCOMPMOV) ? Int_SR1_Val : 
				   (op == `VCOMPMOVI) ? Immediate :
				   16'hXXXX;
				   
assign PC_Out = (op == `STARTLOOP) ? LP_Start : 16'hXXXX;
assign Loop = (op == `ENDLOOP) ? 1'b1 : 1'b0;

always @(posedge CLK or posedge RESET) begin
	if(RESET) begin
		Vertex <= 64'h0;
		StartPrimitive <= 1'b0;
		PrimitiveType <= 4'hX;
		EndPrimitive <= 1'b0;
		Draw <= 1'b0;
	end
	else if(~Stall)begin
		if(op == `SETVERTEX) begin
		/*
		Vertex:
		State Matrix =
		[ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ] [ vr1[31:16] ]
		[ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ] [ vr1[47:32] ]
		[ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ] [ 1          ]
		[ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ] [ 1          ]
		*/
			Vertex <= { Vec_SR1_Val[63:48],
						StateMatrix[79:64]*Vec_SR1_Val[31:16] + StateMatrix[95:80]*Vec_SR1_Val[47:32] + StateMatrix[127:112],
						StateMatrix[15:0]*Vec_SR1_Val[31:16] + StateMatrix[31:16]*Vec_SR1_Val[47:32] + StateMatrix[63:48],
						Vec_SR1_Val[15:0] };
			NewVertex <= 1'b1;
		end
		else begin
      Vertex <= 64'hXXXXXXXXXXXXXXXX;
      NewVertex <= 1'b0;
		end
		
		/*
		Translate:
		[ 1 0 0 sr1[31:16] ] [ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
		[ 0 1 0 sr1[47:32] ] [ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
		[ 0 0 1 0          ] [ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
		[ 0 0 0 1          ] [ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
		*/
		
		if(op == `TRANSLATE) begin
			StateMatrix[63:48] <= StateMatrix[63:48] + Vec_SR1_Val[31:16];
			StateMatrix[127:112] <= StateMatrix[127:112] + Vec_SR1_Val[47:32];
		end
		
		/*
		Scale:
		[ sr1[31:16] 0          0 0 ] [ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
		[ 0          sr1[47:32] 0 0 ] [ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
		[ 0          0          1 0 ] [ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
		[ 0          0          0 1 ] [ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
		*/
		
		if(op == `SCALE) begin
			StateMatrix[15:0] <= Vec_SR1_Val[31:16] * StateMatrix[15:0];
			StateMatrix[31:16] <= Vec_SR1_Val[31:16] * StateMatrix[31:16];
			StateMatrix[63:48] <= Vec_SR1_Val[31:16] * StateMatrix[63:48];
			StateMatrix[79:64] <= Vec_SR1_Val[47:32] * StateMatrix[79:64];
			StateMatrix[95:80] <= Vec_SR1_Val[47:32] * StateMatrix[95:80];
			StateMatrix[127:112] <= Vec_SR1_Val[47:32] * StateMatrix[127:112];
		end
		
		/*
		Rotate:
		[ cos(sr1[15:0]) -sin(sr1[15:0]) 0 0 ] [ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
		[ sin(sr1[15:0]) cos(sr1[15:0])  0 0 ] [ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
		[ 0              0               1 0 ] [ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
		[ 0              0               0 1 ] [ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
		*/
		
		if(op == `ROTATE && Vec_SR1_Val[63:48] == 16'h0080) begin
			StateMatrix[15:0] <= Cosine_Result * StateMatrix[15:0] - Sine_Result * StateMatrix[79:64];
			StateMatrix[31:16] <= Cosine_Result * StateMatrix[31:16] - Sine_Result * StateMatrix[95:80];
			StateMatrix[63:48] <= Cosine_Result * StateMatrix[63:48] - Sine_Result * StateMatrix[127:112];
			StateMatrix[79:64] <= Sine_Result * StateMatrix[15:0] + Cosine_Result * StateMatrix[79:64];
			StateMatrix[95:80] <= Sine_Result * StateMatrix[31:16] + Cosine_Result * StateMatrix[95:80];
			StateMatrix[127:112] <= Sine_Result * StateMatrix[63:48] + Cosine_Result * StateMatrix[127:112];
		end
		
		if(op == `LOADIDENTITY) StateMatrix <= `IDENTITYMATRIX;
		
		if(op == `PUSHMATRIX) begin
			MatrixStack[MatrixStackPointer] <= StateMatrix;
			MatrixStackPointer <= MatrixStackPointer + 1'b1;
		end
		
		if(op == `POPMATRIX) begin
			StateMatrix <= MatrixStack[MatrixStackPointer - 1'b1];
			MatrixStackPointer <= MatrixStackPointer - 1'b1;
		end
		
		if(op == `STARTPRIMITIVE) StartPrimitive <=  1'b1;
		else StartPrimitive <= 1'b0;
		
		if(op == `STARTPRIMITIVE) PrimitiveType <= Instruction[19:16];
		else PrimitiveType <= 4'hX;
		
		if(op == `ENDPRIMITIVE) EndPrimitive <= 1'b1;
		else EndPrimitive <= 1'b0;
		
		if(op == `DRAW) Draw <= 1'b1;
		else Draw <= 1'b0;
		
		if(op == `LOOPCOUNT) LP_Count <= Immediate;
		else if(op == `STARTLOOP && LP_Count[15]!=1) LP_Count <= LP_Count - 16'd1;
		
		if(op == `STARTLOOP) LP_Start <= PC;

	end
end

endmodule

module vector_regfile(DR_NUM,DR_VAL,SRC1_NUM,SRC1_VAL,CLK,WENABLE,RESET,COMP_WENABLE,IDX,COMP_VAL);
	parameter REG_WIDTH;
	parameter REG_COUNT;
	parameter REG_NUM_WIDTH;
	input[(REG_NUM_WIDTH-1):0] DR_NUM,SRC1_NUM;
	input[(REG_WIDTH-1):0] DR_VAL;
	input[15:0] COMP_VAL;
	input[1:0] IDX;
	input CLK,WENABLE,RESET,COMP_WENABLE;
	output[(REG_WIDTH-1):0] SRC1_VAL;
	reg[(REG_WIDTH-1):0] register_file[(REG_COUNT-1):0];
	
	assign SRC1_VAL = register_file[SRC1_NUM];
	integer i;
	always @(negedge CLK or posedge RESET) begin
		if(RESET) begin
			for(i=0; i<REG_COUNT; i=i+1) begin
				register_file[i] = 0;
			end
		end
		else if(WENABLE) register_file[DR_NUM] <= DR_VAL;
		else if(COMP_WENABLE) begin
			case(IDX)
				2'b00: register_file[DR_NUM][15:0] <= COMP_VAL;
				2'b01: register_file[DR_NUM][31:16] <= COMP_VAL;
				2'b10: register_file[DR_NUM][47:32] <= COMP_VAL;
				2'b11: register_file[DR_NUM][63:48] <= COMP_VAL;
			endcase
		end
	end
endmodule

module regfile(DR_NUM,DR_VAL,SRC1_NUM,SRC1_VAL,SRC2_NUM,SRC2_VAL,CLK,WENABLE,RESET);
	parameter REG_WIDTH;
	parameter REG_COUNT;
	parameter REG_NUM_WIDTH;
	input[(REG_NUM_WIDTH-1):0] DR_NUM,SRC1_NUM,SRC2_NUM;
	input[(REG_WIDTH-1):0] DR_VAL;
	input CLK,WENABLE,RESET;
	output[(REG_WIDTH-1):0] SRC1_VAL,SRC2_VAL;
	reg[(REG_WIDTH-1):0] register_file[(REG_COUNT-1):0];
	
	assign SRC1_VAL = register_file[SRC1_NUM];
	assign SRC2_VAL = register_file[SRC2_NUM];
	integer i;
	always @(negedge CLK or posedge RESET) begin
		if(RESET) begin
			for(i=0; i<REG_COUNT; i=i+1) begin
				register_file[i] = 0;
			end
		end
		else if(WENABLE) register_file[DR_NUM] <= DR_VAL;
	end
endmodule