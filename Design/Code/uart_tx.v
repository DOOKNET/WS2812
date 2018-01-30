module uart_tx
#(
    parameter BPS_CNT = 10'd434
)
(
    input clk,
    input rst_n,
    input [7:0]tx_data,
    input tx_en,//mai_chong_shi_neng
    output reg tx_done_sig=0,
    output tx
    );

wire rst;
assign rst = ~ rst_n;

reg tx_state=0;
always @(posedge clk) begin
    if(rst)
        tx_state<=0;
    else if(tx_en)
        tx_state<=1;
    else if(tx_done_sig)
        tx_state<=0;
    else 
        tx_state<=tx_state;
end

//set the 115200 bps 50M
reg [9:0]cnt_bps=0;
wire bps_clk=(cnt_bps == BPS_CNT-2);
always @(posedge clk) begin
    if(rst) begin
        cnt_bps<=0;
    end
    else if(cnt_bps == BPS_CNT-1) 
        cnt_bps<=0;
    else if(tx_state)
        cnt_bps<=cnt_bps+1;
    else
        cnt_bps<=0;
end

reg [3:0]i=0;
reg tx_r=1;
always @(posedge clk) begin
    if(rst) begin
        i<=4'd0;
        tx_r<=1'b1;
    end
    else if(tx_state)
        case(i)
            4'b0:
                if(bps_clk) begin//发送起始位
                    i<=i+1;
                    tx_r<=1'b0;
                end
            4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8 :
                if(bps_clk) begin //发送数据位
                    i <= i + 1'b1; 
                    tx_r <= tx_data[ i - 1 ]; 
                end
            4'd9:
                if(bps_clk) begin//校验位
                    i<=i+1;
                    tx_r<=1'b1;
                end
            4'd10:
                if(bps_clk) begin//停止位
                    i<=i+1;
                    tx_r<=1'b1;
                end
            4'd11:
                if(bps_clk) begin//一帧数据结束标志
                    i<=i+1;
                    tx_done_sig<=1'b1;
                end
            4'd12: begin 
                    i<=0;
                    tx_done_sig<=1'b0;
                end
        endcase
		else
			i<=0;
end

assign tx=tx_r;

endmodule

