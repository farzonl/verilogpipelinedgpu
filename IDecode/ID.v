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
`define POPMATRIX		5'b10101`
`define STARTPRIMITIVE	5'b10110
`define ENDPRIMITIVE	5'b10111
`define LOADIDENTITY	5'b11000
`define DRAW			5'b11001
`define STARTLOOP		5'b11010
`define ENDLOOP			5'b11011
`define LOOPCOUNT		5'b11100
`define INVALID			5'b11101

module ID(CLK,Instruction,RESET,Vertex,StartPrimitive,PrimitiveType,EndPrimitive,Draw);
input CLK,RESET;
input[31:0] Instruction;
output[31:0] Vertex; //Assuming X=Vertex[15:0], Y=Vertex[31:16]
output StartPrimitive,EndPrimitive,Draw;
output[3:0] PrimitiveType;

wire Vec_WEnable,Int_WEnable,VComp_WEnable;
wire[1:0] idx;
wire[4:0] op;
wire[63:0] Vec_DR_Val, Vec_SR1_Val;
wire[5:0] Vec_DR_Num, Vec_SR1_Num;
wire[15:0] Int_DR_Val, Int_SR1_Val, Int_SR2_Val, VComp_Val;
wire[3:0] Int_DR_Num, Int_SR1_Num, Int_SR2_Num;
wire[15:0] Immediate;

vector_regfile #(.REG_WIDTH(64),.REG_COUNT(64),.REG_NUM_WIDTH(6)) vector_regs(.CLK(CLK),.DR_NUM(Vec_DR_Num),.DR_VAL(Vec_DR_Val),.SRC1_NUM(Vec_SR1_Num),.SRC1_VAL(Vec_SR1_Val),.RESET(RESET),.WENABLE(Vec_WEnable),.COMP_WENABLE(VComp_WEnable),.IDX(idx),.COMP_VAL(VComp_Val));
regfile #(.REG_WIDTH(16),.REG_COUNT(8),.REG_NUM_WIDTH(4)) int_regs(.CLK(CLK),.DR_NUM(Int_DR_Num),.DR_VAL(Int_DR_Val),.SRC1_NUM(Int_SR1_Num),.SRC1_VAL(Int_SR1_Val),.SRC2_NUM(Int_SR2_Num),.SRC2_VAL(Int_SR2_Val),.RESET(RESET),.WENABLE(Int_WEnable));

assign Vec_DR_Num = Instruction[21:16];
assign Vec_SR1_Num = Instruction[11:8];

assign Int_DR_Num = Instruction[23:20];
assign Int_SR1_Num = Instruction[19:16];
assign Int_SR2_Num = Instruction[11:8];

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

//for these I was not sure why you were not using the instruction bit ranges for dest and src?
//thats how I had it but I changed it up to fit how it looks like you are doing it
assign Int_DR_Val = (op == `ADD_D || op ==`ADD_F) ? Int_SR1_Val+Int_SR2_Val : 
					(op == `SUB_D || op ==`SUB_F) ? Int_SR1_Val-Int_SR2_Val : 
					(op == `ADDI_D || op ==`ADDI_F) ? Int_SR1_Val+Immediate :
					(op == `SUBI_D || op ==`SUBI_F) ? Int_SR1_Val-Immediate :
					(op == `MOV) ? Vec_SR1_Val : 
					(op == `MOVI || op ==`MOVI_F) ? Immediate :
					32'hXXXXXXXX;	
			
assign Vec_WEnable = (op == `VMOV || op ==`VMOVI) ? 1'b1 : 1'b0;

assign Vec_DR_Val = (op == `VMOV) ? Vec_SR1_Val : 
					(op == `VMOVI) ? {Immediate, Immediate, Immediate, Immediate} :
					64'hXXXXXXXXXXXXXXXX;

assign VComp_WEnable = (op == `VCOMPMOV || op == `VCOMPMOVI) ? 1'b1 : 1'b0;

assign VComp_Val = (op == `VCOMPMOV) ? Int_SR1_Val : 
				   (op == `VCOMPMOVI) ? Immediate :
				   16'hXXXX;

assign Vertex = (op == `SETVERTEX) ? Vec_SR1_Val[47:16] : 32'hXXXXXXXX;

assign StartPrimitive = (op == `STARTPRIMITIVE) ? 1'b1: 1'b0;
assign PrimitiveType = (op == `STARTPRIMITIVE) ? Instruction[19:16] : 4'hX;
assign EndPrimitive = (op == `ENDPRIMITIVE) ? 1'b1 : 1'b0;
assign Draw = (op == `DRAW) ? 1'b1 : 1'b0;

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