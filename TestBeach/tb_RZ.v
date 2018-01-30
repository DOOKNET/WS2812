`timescale	1ns/1ps

module	tb_RZ();

reg 	sclk;
reg 	rst_n;
reg 	[23:0]	RGB;
reg 	done_sig;
wire 	symbol;
wire 	RZ_Code;

initial	sclk = 1;
always	#10	sclk = ~sclk;

initial	begin
	rst_n = 0;
	#100
	rst_n = 1;
end

always @(posedge sclk or negedge rst_n) begin
	if(!rst_n)	begin
		
	end
end



RZ_Code			RZ_Code_inst(
	.clk		(sclk),
	.rst_n		(rst_n),
	.RGB		(RGB),
	.done_sig	(done_sig),
	.symbol		(symbol),
	.RZ_data	(RZ_Code)
);



endmodule
