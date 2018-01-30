/////////////////////////////////////
//	输入数据为RGB数据(24bit)
//	输出数据为单极性归零码(Return Zero Code)
/////////////////////////////////////

module RZ_Code(
	input	clk,
	input	rst_n,
	input	[23:0]	RGB,	//按照GRB的顺序排列
	input	done_sig,		//RGB数据更新信号
	output	tx_done,		//一帧(24bit)数据结束标志
	output	RZ_data
);

//-----------------接口信号----------------//
reg 	[31:0]	cnt;
reg 	[4:0]	i;			//计数24bit
reg 	RZ_done;			//一帧数据发送结束
reg 	RGB_reg;			//存储移位寄存器最高位
reg		data_out;			//转换后的单极性归零码

wire 	symbol = (cnt == 32'd62);	//1bit数据结束标志
//----------------------------------------//

//-------------计数一个码元周期-------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		cnt <= 0;
	end
	else if(cnt == 32'd62)	begin		//计数到62.5=1.25us * 50M
		cnt <= 32'd0;
	end
	else	begin
		cnt <= cnt + 1'b1;
	end
end
//---------------------------------------//

//--------------移位寄存器---------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		i <= 0;
		RGB_reg <= 0;
		RZ_done <= 0;
	end
	else	begin
		case (i)
			5'd0,5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16,5'd17,5'd18,5'd19,5'd20,5'd21,5'd22:
				if(symbol)	begin
					i <= i + 1;
					RGB_reg <= RGB[23 - i];
				end
				else	begin
					i <= i;
					RGB_reg <= RGB_reg;
				end
			5'd23:
				if(symbol)	begin
					i <= i + 1;
					RZ_done <= 1;
					RGB_reg <= RGB[23 - i];
				end
				else	begin
					i <= i;
					RZ_done <= 0;
					RGB_reg <= RGB_reg;
				end
			5'd24:
				begin
					i <= 0;
					RZ_done <= 0;
				end
		  	default: i <= 0;
		endcase
	end
end

assign	tx_done = RZ_done;
//---------------------------------------//

//----------------归零码-----------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		data_out <= 0;
	end
	else if(RGB_reg == 0)	begin
		if(cnt <= 32'd20)	begin		//零码，0.4us*50M=20
			data_out <= 1;
		end
		else	begin
			data_out <= 0;
		end
	end
	else if(RGB_reg == 1)	begin
		if(cnt <= 32'd42)	begin		//一码，0.85us*50M=40
			data_out <= 1;
		end
		else	begin
			data_out <= 0;
		end
	end
	else	begin
		data_out <= data_out;
	end
end
//-----------------------------------------//
assign	RZ_data = data_out;

endmodule
