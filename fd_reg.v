module fd_reg(
    input clk,
    input rstd,
    input [1:0] jon_d,
    input [31:0] pc_in,
    inout [31:0] ins_in,
    output [31:0] pc_out,
    output [31:0] ins_out
    );

    reg [31:0] pc, ins;
    reg [1:0] jump_count;
    wire  stop;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)begin
            ins<=32'hdc000000;
            jump_count <= 2'd0;
        end
        else if(clk==1)begin
            if(stop)ins <= 32'hdc000000;
            else begin
                pc <= pc_in;
                ins <= ins_in;
            end
            if(jon_d[1]==1'd1)jump_count <= 2'd2;
            else if(jump_count>2'd0)jump_count<=jump_count-2'd1;
            else ;
        end
    end

    assign stop = ((jon_d!=2'b00)|(jump_count>0))?1'b1:1'b0;
    assign pc_out = pc;
    assign ins_out = ins;
endmodule
