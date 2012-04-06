module FE_test(CLOCK_50,Reset,Vertex,StartPrimitive,EndPrimitive,Draw,PrimitiveType,InstructionOut);

input CLOCK_50,Reset;

wire[31:0] instruction;
wire[15:0] Loop_PC,PC;
wire Loop;
output StartPrimitive,EndPrimitive,Draw;
output[31:0] Vertex,InstructionOut;
output[3:0] PrimitiveType;

assign InstructionOut = instruction;

FE fetch(.reset(Reset),.CLOCK_50(CLOCK_50),.id_instr(instruction),.Loop(Loop),.PC_in(Loop_PC),.PC_out(PC));
ID decode(.RESET(Reset),.CLK(CLOCK_50),.Instruction(instruction),.Vertex(Vertex),.StartPrimitive(StartPrimitive),.EndPrimitive(EndPrimitive),.PrimitiveType(PrimitiveType),.Draw(Draw),.Loop(Loop),.PC(PC),.PC_Out(Loop_PC));

endmodule