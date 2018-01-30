/////////////////////////////////////
//	输入数据为RGB数据(24bit)
//	输出数据为单极性归零码(Return Zero Code)
/////////////////////////////////////

module RZ_Code(
	input	clk,
	input	rst_n,
	input	[23:0]	RGB,	//按照GRB的顺序排列
	input	done_sig,		//RGB数据更新信号
	output	reg	symbol,		//一帧(24bit)数据结束标志位
	output	RZ_data
);

//-----------------接口信号----------------//
reg 	[31:0]	cnt;
reg		symbol,				//1bit数据结束标志
reg 	[23:0]	RGB_shift;	//移位寄存器
reg 	RGB_reg;			//存储移位寄存器最高位
reg		data_out;			//转换后的单极性归零码
//----------------------------------------//

//-------------计数一个码元周期-------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		cnt <= 0;
		symbol <= 0;
	end
	else if(cnt == 32'd58)	begin		//1bit数据结束标志位，在59时置1
		symbol <= 1;	
	end
	else if(cnt == 32'd59)	begin		//计数到60=1.2us * 50M
		cnt <= 32'd0;
	end
	else	begin
		cnt <= cnt + 1'b1;
		symbol <= 0;
	end
end
//---------------------------------------//

//--------------移位寄存器---------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		RGB_shift <= 0;
		RGB_reg <= 0;
	end
	else if(done_sig == 1)	begin
		RGB_shift <= RGB;
	end
	else if(cnt == 32'd59)	begin	
		RGB_reg <= RGB_shift[23];
		RGB_shift <= {RGB_shift[22:0],RGB_shift[23]};
	end
	else	begin
		RGB_shift <= RGB_shift;
		RGB_reg <= RGB_reg;
	end
end
//---------------------------------------//

//----------------归零码-----------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		data_out <= 0;
	end
	else if(RGB_reg == 0)	begin
		if(cnt <= 32'd19)	begin		//零码，0.4us*50M=20
			data_out <= 1;
		end
		else	begin
			data_out <= 0;
		end
	end
	else if(RGB_reg == 1)	begin
		if(cnt <= 32'd39)	begin		//一码，0.8us*50M=40
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
