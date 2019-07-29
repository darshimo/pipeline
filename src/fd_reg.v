module fd_reg(
    input clk,
    input rstd,
    input [1:0] stop_f,
    input [1:0] stop_d,
    input [31:0] pc_in,
    inout [31:0] ins_in,
    output [31:0] pc_out,
    output [31:0] ins_out
    );

    reg finish;
    reg [31:0] pc, ins;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)begin
            finish<=1'b0;
            ins<=32'hdc000000;
        end
        else if(finish);
        else if(clk==1)begin
            if(stop_d[1]|stop_f[1])ins <= 32'hdc000000;
            else if(stop_f[0])begin
                pc <= pc_in;
                ins <= ins_in;
            end
            else begin
                finish <= 1'b1;
                ins <= 32'hdc000000;
            end
        end
    end

    assign pc_out = pc;
    assign ins_out = ins;
endmodule
