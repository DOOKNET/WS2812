module RGB_Control(
	input	clk,
	input	rst_n,
	input	tx_done,		//一帧(24bit)数据结束标志
	output	tx_en,			//发送数据使能
	output	reg	[23:0]	RGB
);

//-------------接口信号------------//
reg		[31:0]	cnt;
reg 	[23:0]	RGB_reg	[4:0];	//存RGB数据的数组
reg 	[3:0]	k;				
reg 	tx_en_r;
//--------------------------------//
reg 	tx_done_r0;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		tx_done_r0 <= 0;
	end
	else	begin
		tx_done_r0 <= tx_done;
	end
end
//--------------------------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		k <= 0;
		RGB <= 0;
		RGB_reg	[0]	<= 24'b11111111_00000000_11111111;
		RGB_reg	[1]	<= 24'b00000000_11111111_00000000;
		RGB_reg	[2]	<= 24'b10101010_01010101_10101010;
		RGB_reg	[3]	<= 24'b10100101_01000011_11010101;
		RGB_reg	[4]	<= 24'b10100101_01000011_11010101;
	end
	else if(tx_en_r)	begin
		case (k)
			4'd0,4'd1,4'd2,4'd3:
				if(tx_done_r0)	begin
					RGB <= RGB_reg[k];
					k <= k + 1;
				end
			4'd4:
				if(tx_done)	begin
					RGB <= RGB_reg[0];
					k <= 0;
				end
		  	default: k <= 0;
		endcase
	end
	else ;
end
//--------------------------------//

//-------------计数器-------------//
always @(posedge clk or negedge rst_n) begin
	if((!rst_n) || (tx_en_r))	begin
		cnt <= 0;
	end
	else if(cnt == 32'd14999)	begin	//RESET时间(300us*50M=15000)
		cnt <= cnt;
	end
	else	begin
		cnt <= cnt + 1;
	end
end
//--------------------------------//

//--------------------------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		tx_en_r <= 0;
	end
	else if((k == 4'd4) && (tx_done))	begin
		tx_en_r <= 0;			//一组数据发送结束，RESTE
	end
	else if((cnt == 32'd14999) && tx_done)	begin
		tx_en_r <= 1;			//重新开始发送
	end
	else	begin
		tx_en_r <= tx_en_r;
	end
end

assign	tx_en = tx_en_r;
//--------------------------------//

endmodule
