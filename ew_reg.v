module ew_reg(
    input clk,
    input rstd,
    input [31:0] pc_in,
    input [5:0] op_in,
    input [31:0] os_in,
    input [31:0] ot_in,
    input [25:0] addr_in,
    input [31:0] imm_dpl_in,
    input [4:0] wreg_in,
    input [31:0] alu_result_in,
    output [31:0] pc_out,
    output [5:0] op_out,
    output [31:0] os_out,
    output [31:0] ot_out,
    output [25:0] addr_out,
    output [31:0] imm_dpl_out,
    output [4:0] wreg_out,
    output [31:0] alu_result_out
    );

    reg [31:0] pc, os, ot, imm_dpl, alu_result;
    reg [4:0] wreg;
    reg [5:0] op;
    reg [25:0] addr;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)op<=6'b110111;
        else if(clk==1)begin
            pc <= pc_in;
            op <= op_in;
            os <= os_in;
            ot <= ot_in;
            addr <= addr_in;
            imm_dpl <= imm_dpl_in;
            if(op_in!=55)wreg <= wreg_in;
            else wreg <= 5'd0;
            alu_result <= alu_result_in;
        end
    end

    assign pc_out = pc;
    assign op_out = op;
    assign os_out = os;
    assign ot_out = ot;
    assign addr_out = addr;
    assign imm_dpl_out = imm_dpl;
    assign wreg_out = wreg;
    assign alu_result_out = alu_result;
endmodule
