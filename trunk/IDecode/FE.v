


module FE(CLOCK_50,reset,Stall,id_instr,Loop,PC_in,PC_out);
input CLOCK_50,reset,Loop,Stall;
input[15:0] PC_in;
output reg [31:0] id_instr;
output reg [15:0] PC_out;

(* ram_init_file = "FE_test.mif" *)
reg[31:0] mem[0:127];
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
	else begin
		pc<=pc;
		mdr<=mdr;
		id_instr<=id_instr;
		PC_out<=pc;
	end
end

endmodule

