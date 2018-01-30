`timescale	1ns/1ps

module	tb_uart();

reg 	sclk;
reg 	rst_n;
wire 	tx_done_sig;
wire 	tx;

//---------------------------//
initial	sclk = 1;
always	#10	sclk = ~sclk;

initial	begin
	rst_n = 0;
	#100
	rst_n = 1;
end
//---------------------------//
TOP					TOP_inst(
	.clk			(sclk),
	.rst_n			(rst_n),
	.tx_done_sig	(tx_done_sig),
	.tx				(tx)
);



endmodule
