/////////////////////////////////////
//	输入数据为RGB数据
//	输出数据为单极性归零码(Return Zero Code)
/////////////////////////////////////

module RZ_Code(
	input	clk,
	input	rst_n,
	input	[23:0]	RGB,	//按照GRB的顺序排列
	output	RZ_data
);

//-----------------接口信号----------------//
reg 	[31:0]	cnt;
reg		symbol_flag;		//码元周期标志,在每个码元的开始时刻
reg 	[23:0]	RGB_reg;	//移位寄存器

reg		data_out;		//转换后的单极性归零码
//----------------------------------------//

//-----------计数一个码元周期--------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		cnt <= 0;
	end
	else if(cnt == 32'd59)	begin		//计数到60=1.2us * 50M
		cnt <= 32'd0;
		symbol_flag <= 1;
	end
	else	begin
		cnt <= cnt + 1'b1;
		symbol_flag <= 0;
	end
end
//---------------------------------------//

//--------------移位寄存器---------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		RGB_reg <= 0;
	end
	else if(symbol_flag == 1)	begin
		RGB_reg <= (RGB_reg << 1);
	end
	else	begin
		RGB_reg <= RGB_reg;
	end
end
//---------------------------------------//

//----------------归零码-----------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		data_out <= 0;
	end
	else if((symbol_flag == 1) && (RGB_reg[23] == 0))	begin
		if(cnt == 32'd19)	begin		//零码，0.4us*50M=20
			data_out <= 0;
		end
		else	begin
			data_out <= 1;
		end
	end
	else if((symbol_flag == 1) && (RGB_reg[23] == 1))	begin
		if(cnt == 32'd39)	begin		//一码，0.8us*50M=40
			data_out <= 0;
		end
		else	begin
			data_out <= 1;
		end
	end
	else	begin
		data_out <= data_out;
	end
end
//-----------------------------------------//
assign	RZ_data = data_out;

endmodule
