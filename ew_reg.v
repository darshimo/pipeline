module ew_reg(
    input clk,
    input rstd,
    input [5:0] op_in,
    input [4:0] wreg_in,
    input [31:0] result_in,
    output [5:0] op_out,
    output [4:0] wreg_out,
    output [31:0] result_out
    );

    reg [5:0] op;
    reg [31:0] result;
    reg [4:0] wreg;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)op<=6'b110111;
        else if(clk==1)begin
            op <= op_in;
            if(op_in!=55)wreg <= wreg_in;
            else wreg <= 5'd0;
            result <= result_in;
        end
    end

    assign op_out = op;
    assign wreg_out = wreg;
    assign result_out = result;
endmodule
