module FE(CLOCK_50,reset,Stall,id_instr,Loop,PC_in,PC_out);
input CLOCK_50,reset,Loop,Stall;
input[15:0] PC_in;
output reg [31:0] id_instr;
output reg [15:0] PC_out;

//(* ram_init_file = "gpu_testbench.mif" *)
wire[31:0] mem[0:127];


assign mem[0] = 32'h15040000;
assign mem[1] =   32'hD100000A;
assign mem[2] =   32'hC0000000;
assign mem[3] =   32'h80000000;
assign mem[4] =   32'hA0000000;
assign mem[5] =   32'h234180C0;
assign mem[6] =   32'h23810000;
assign mem[7] =   32'h5A010000;
assign mem[8] =   32'h22000400;
assign mem[9] =   32'h23400000;
assign mem[10] =   32'h23800000;
assign mem[11] =   32'h23C00080;
assign mem[12] =   32'h52000000;
assign mem[13] =   32'h91040000;
assign mem[14] =   32'h230200FF;
assign mem[15] =   32'h234200FF;
assign mem[16] =   32'h238200FF;
assign mem[17] =   32'h4A020000;
assign mem[18] =   32'h23438080;
assign mem[19] =   32'h23830080;
assign mem[20] =   32'h23C30080;
assign mem[21] =   32'h42030000;
assign mem[22] =   32'h23430080;
assign mem[23] =   32'h23830080;
assign mem[24] =   32'h23C30080;
assign mem[25] =   32'h42030000;
assign mem[26] =   32'h23430000;
assign mem[27] =   32'h23838080;
assign mem[28] =   32'h23C30080;
assign mem[29] =   32'h42030000;
assign mem[30] =   32'h98000000;
assign mem[31] =   32'h05440A00;
assign mem[32] =   32'h88000000;
assign mem[33] =   32'hB8000000;
assign mem[34] =   32'hC8000000;


reg[31:0] mdr;
reg[15:0] pc;
initial begin
	pc <= 0;
	PC_out <= 0;
end

always @(posedge CLOCK_50 or posedge reset) begin
	if(reset) begin
		pc <= 0;
		mdr <= 0;
		id_instr <= 0;
		PC_out <= 0;
	end
	else if(~Stall) begin
	
		if(Loop) pc <= PC_in;
		else pc <= pc + 16'd1;
		
		if(Loop) mdr <= mem[PC_in];
		else mdr <= mem[pc];
		
		id_instr <= mdr;
		
		if(Loop) PC_out <= PC_in;
		else PC_out <= pc;
	
	end
end

endmodule