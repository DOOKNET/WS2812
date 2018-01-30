module tx_control(
	input clk,
	input rst_n,
	output [7:0]tx_data,
	output tx_en
);

reg [31:0]cnt=0;
always @(posedge clk) begin
    if(~rst_n)
        cnt<=0;
    else if(cnt == 32'd49999)
        cnt<=0;
    else    
        cnt<=cnt+1;
end
assign tx_en=(cnt == 32'd49999);

reg [7:0]tx_data_r=0;
always @(posedge clk) begin
	if(~rst_n)
		tx_data_r=0;
   else if(tx_en)
        tx_data_r<=tx_data_r+1;
end

assign tx_data=tx_data_r;

endmodule