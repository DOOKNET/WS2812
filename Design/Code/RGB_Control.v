module RGB_Control(
	input	clk,
	input	rst_n,
	output	RZ_data	
);

//---------接口信号----------//
reg 	done_sig;
reg 	[1:0]	i;
reg 	[23:0]	RGB_reg	[4:0];
reg 	[23:0]	RGB;

wire 	tx_done;
//--------------------------//

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		i <= 0;
		done_sig <= 0;
		RGB_reg	[0]	<= 24'b11111111_00000000_11111111;
		RGB_reg	[1]	<= 24'b00000000_11111111_00000000;
		RGB_reg	[2]	<= 24'b10101010_01010101_10101010;
		RGB_reg	[3]	<= 24'b10100101_01000011_11010101;
	end
	else if(tx_done)	begin
		i <= i + 1;
		RGB <= RGB_reg[i];
		done_sig <= 1;
	end
	else	begin
		i <= i;
		RGB <= RGB;
		done_sig <= 0;
	end
end


//--------------------------//
RZ_Code				RZ_Code_inst(
	.clk			(clk),
	.rst_n			(rst_n),
	.RGB			(RGB),
	.done_sig		(done_sig),	
	.tx_done		(tx_done),	
	.RZ_data		(RZ_data)
);
//--------------------------//



endmodule
