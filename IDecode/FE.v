module FE(CLOCK_50,reset,id_instr);
input CLOCK_50,reset;
output reg [31:0] id_instr;

(* ram_init_file = "FE_test.mif" *)
reg[31:0] mem[0:127];
reg[31:0] mdr;
reg[15:0] pc;
initial begin
	pc <= 0;
end

always @(posedge CLOCK_50 or posedge reset) begin
	if(reset) begin
		pc <= 0;
		mdr <= 0;
		id_instr <= 0;
	end
	else begin
		pc <= pc + 16'd1;
		mdr <= mem[pc];
		id_instr <= mdr;
	end
end

endmodule
