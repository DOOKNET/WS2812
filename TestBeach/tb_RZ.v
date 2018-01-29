`timescale	1ns/1ps

module	tb_RZ();

reg 	sclk;
reg 	rst_n;
reg 	[23:0]	RGB;
reg 	done_sig;
wire 	RZ_Code;

initial	sclk = 1;
always	#10	sclk = ~sclk;

initial	begin
	rst_n = 0;
	RGB = 0;
	done_sig = 0;
	#100
	rst_n = 1;
	done_sig = 1;
	RGB = 23'b10111001_11100100_00001110;
	#20
	done_sig = 0;
	#100000
	done_sig = 1;
	RGB = 23'b00001110_10111001_11100100;
	#20
	done_sig = 0;
end

RZ_Code			RZ_Code_inst(
	.clk		(sclk),
	.rst_n		(rst_n),
	.RGB		(RGB),
	.done_sig	(done_sig),
	.RZ_data	(RZ_Code)
);



endmodule
