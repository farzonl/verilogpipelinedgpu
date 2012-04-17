`define SETVERTEX		3'b000
`define COLOR			3'b001
`define ROTATE			3'b010
`define TRANSLATE		3'b011
`define SCALE			3'b100
`define PUSHMATRIX		3'b101
`define POPMATRIX		3'b110
`define LOADIDENTITY	3'b111

`define IDENTITYMATRIX	255'h0001000000000000000000010000000000000000000100000000000000000001

module vertexops(CLK,vectorIn,Vertex,NewVertex,op);

input CLK;
input[63:0] vectorIn;
output reg[63:0] Vertex;
output reg NewVertex;
input[2:0] op;
reg[255:0] StateMatrix;
reg[255:0] MatrixStack[0:15];
reg[3:0] MatrixStackPointer;
wire[15:0] Cosine_Result, Sine_Result;

cosine_LUT Cosine(.INVAL(vectorIn[15:0]),.OUTVAL(Cosine_Result));
sine_LUT Sine(.INVAL(vectorIn[15:0]),.OUTVAL(Sine_Result));

initial begin
	MatrixStackPointer = 4'b0;
	StateMatrix = `IDENTITYMATRIX;
end

always @(posedge CLK) begin
	if(op == `SETVERTEX) begin
		Vertex <= { vectorIn[63:48],
						StateMatrix[79:64]*vectorIn[31:16] + StateMatrix[95:80]*vectorIn[47:32] + StateMatrix[127:112],
						StateMatrix[15:0]*vectorIn[31:16] + StateMatrix[31:16]*vectorIn[47:32] + StateMatrix[63:48],
						vectorIn[15:0] };
		NewVertex <= 1'b1;
	end
	if(op == `TRANSLATE) begin
		StateMatrix[63:48] <= StateMatrix[63:48] + vectorIn[31:16];
		StateMatrix[127:112] <= StateMatrix[127:112] + vectorIn[47:32];
	end
	
	if(op == `SCALE) begin
		StateMatrix[15:0] <= vectorIn[31:16] * StateMatrix[15:0];
		StateMatrix[31:16] <= vectorIn[31:16] * StateMatrix[31:16];
		StateMatrix[63:48] <= vectorIn[31:16] * StateMatrix[63:48];
		StateMatrix[79:64] <= vectorIn[47:32] * StateMatrix[79:64];
		StateMatrix[95:80] <= vectorIn[47:32] * StateMatrix[95:80];
		StateMatrix[127:112] <= vectorIn[47:32] * StateMatrix[127:112];
	end
	
	if(op == `ROTATE && vectorIn[63:48] == 16'h0080) begin
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
end

endmodule