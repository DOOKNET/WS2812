module TOP(
	input	clk,
	input	rst_n,
	output 	RZ_data
);
//-------------------------------//
wire 	tx_en;
wire 	tx_done;
wire 	[23:0]	RGB;
//-------------------------------//

//-------------------------------//
RGB_Control		RGB_Control_inst0(
	.clk		(clk),
	.rst_n		(rst_n),
	.tx_done	(tx_done),
	.tx_en		(tx_en),	
	.RGB		(RGB)
);
//-------------------------------//
RZ_Code			RZ_Code_inst1(
	.clk		(clk),
	.rst_n		(rst_n),
	.RGB		(RGB),
	.tx_en		(tx_en),	
	.tx_done	(tx_done),
	.RZ_data	(RZ_data)
);

endmodule
