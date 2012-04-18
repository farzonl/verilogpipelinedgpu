`define NOP					4'b0000
`define SETVERTEX_OP		4'b0001
`define COLOR_OP			4'b0010
`define ROTATE_OP			4'b0011
`define TRANSLATE_OP		4'b0100
`define SCALE_OP			4'b0101
`define PUSHMATRIX_OP	4'b0110
`define POPMATRIX_OP		4'b0111
`define LOADIDENTITY_OP	4'b1000

`define IDENTITYMATRIX	255'sh0080000000000000000000800000000000000000008000000000000000000080

module vertexops(CLK,vectorIn,Vertex,NewVertex,op,stall);

input CLK,stall;
input[63:0] vectorIn;
output reg[63:0] Vertex;
output reg NewVertex;
input[3:0] op;
reg[255:0] StateMatrix;
reg[255:0] MatrixStack[0:15];
reg[3:0] MatrixStackPointer;
wire signed[15:0] Cosine_Result, Sine_Result, X_result, Y_result,X_in,Y_in;
wire signed[15:0] SM11,SM12,SM14,SM21,SM22,SM24;
assign X_in = vectorIn[31:16];
assign Y_in = vectorIn[47:32];
assign SM11 = StateMatrix[15:0];
assign SM12 = StateMatrix[31:16];
assign SM14 = StateMatrix[63:48];
assign SM21 = StateMatrix[79:64];
assign SM22 = StateMatrix[95:80];
assign SM24 = StateMatrix[127:112];

cosine_LUT Cosine(.INVAL(vectorIn[15:0]),.OUTVAL(Cosine_Result));
sine_LUT Sine(.INVAL(vectorIn[15:0]),.OUTVAL(Sine_Result));

initial begin
	MatrixStackPointer = 4'b0;
	StateMatrix = `IDENTITYMATRIX;
	NewVertex = 0;
	Vertex = 0;
end

/*
		Vertex:
		State Matrix =
		[ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ] [ vr1[31:16] ]
		[ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ] [ vr1[47:32] ]
		[ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ] [ 1          ]
		[ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ] [ 1          ]
		*/
assign X_result = ((SM11*X_in + 64) >>> 7) + ((SM12*Y_in + 64) >>> 7) + SM14;
assign Y_result = ((SM21*X_in + 64) >>> 7) + ((SM22*Y_in + 64) >>> 7) + SM24;

always @(posedge CLK) begin
if(~stall) begin
	if(op == `SETVERTEX_OP) begin
		Vertex <= { vectorIn[63:48],
						Y_result,
						X_result,
						vectorIn[15:0] };
		NewVertex <= 1'b1;
	end else NewVertex <= 1'b0;
	
	/*
		Translate:
		[ 1 0 0 sr1[31:16] ] [ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
		[ 0 1 0 sr1[47:32] ] [ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
		[ 0 0 1 0          ] [ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
		[ 0 0 0 1          ] [ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
		*/
	if(op == `TRANSLATE_OP) begin
		//StateMatrix[63:48] <= StateMatrix[63:48] + vectorIn[31:16];
		//StateMatrix[127:112] <= StateMatrix[127:112] + vectorIn[47:32];
		StateMatrix <= {StateMatrix[255:128],SM24 + Y_in,StateMatrix[111:64],SM14 + X_in,StateMatrix[47:0]};
	end
	
	/*
		Scale:
		[ sr1[31:16] 0          0 0 ] [ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
		[ 0          sr1[47:32] 0 0 ] [ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
		[ 0          0          1 0 ] [ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
		[ 0          0          0 1 ] [ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
		*/
	
	if(op == `SCALE_OP) begin
		StateMatrix[15:0] <= (X_in * SM11 + 64) >>> 7;
		StateMatrix[31:16] <= (X_in * SM12 + 64) >>> 7;
		StateMatrix[63:48] <= (X_in * SM14 + 64) >>> 7;
		StateMatrix[79:64] <= (Y_in * SM21 + 64) >>> 7;
		StateMatrix[95:80] <= (Y_in * SM22 + 64) >>> 7;
		StateMatrix[127:112] <= (Y_in * SM24 + 64) >>> 7;
	end
	
	/*
		Rotate:
		[ cos(sr1[15:0]) -sin(sr1[15:0]) 0 0 ] [ SM[15:0]    SM[31:16]   SM[47:32]   SM[63:48]   ]
		[ sin(sr1[15:0]) cos(sr1[15:0])  0 0 ] [ SM[79:64]   SM[95:80]   SM[111:96]  SM[127:112] ]
		[ 0              0               1 0 ] [ SM[143:128] SM[159:144] SM[175:160] SM[191:176] ]
		[ 0              0               0 1 ] [ SM[207:192] SM[223:208] SM[239:224] SM[255:240] ]
		*/
	
	if(op == `ROTATE_OP /*&& vectorIn[63:48] == 16'h0080*/) begin
			/*StateMatrix[15:0] <= ((Cosine_Result * SM11 + 64) >>> 7) - ((Sine_Result * SM21 + 64) >>> 7);
			StateMatrix[31:16] <= ((Cosine_Result * SM12 + 64) >>> 7) - ((Sine_Result * SM22 + 64) >>> 7);
			StateMatrix[63:48] <= ((Cosine_Result * SM14 + 64) >>> 7) - ((Sine_Result * SM24 + 64) >>> 7);
			StateMatrix[79:64] <= ((Sine_Result * SM11 + 64) >>> 7) + ((Cosine_Result * SM21 + 64) >>> 7);
			StateMatrix[95:80] <= ((Sine_Result * SM12 + 64) >>> 7) + ((Cosine_Result * SM22 + 64) >>> 7);
			StateMatrix[127:112] <= ((Sine_Result * SM14 + 64) >>> 7) + ((Cosine_Result * SM24 + 64) >>> 7);*/
		end
		
	if(op == `LOADIDENTITY_OP) StateMatrix <= `IDENTITYMATRIX;
	
	if(op == `PUSHMATRIX_OP) begin
		//MatrixStack[MatrixStackPointer] <= StateMatrix;
		//MatrixStackPointer <= MatrixStackPointer + 1'b1;
	end
	
	if(op == `POPMATRIX_OP) begin
		//StateMatrix <= MatrixStack[MatrixStackPointer - 1'b1];
		//MatrixStackPointer <= MatrixStackPointer - 1'b1;
	end
	end
end

endmodule
