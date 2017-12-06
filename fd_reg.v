module fd_reg(
    input clk,
    input rstd,
    input [31:0] pc_in,
    inout [31:0] ins_in,
    output [31:0] pc_out,
    output [31:0] ins_out
    );

    reg [31:0] pc, ins;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)ins<=32'hdc000000;
        else if(clk==1)begin
            pc <= pc_in;
            ins <= ins_in;
        end
    end

    assign pc_out = pc;
    assign ins_out = ins;
endmodule
