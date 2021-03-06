module de_reg(
    input clk,
    input rstd,
    input [1:0] stop_d,
    input [31:0] pc_in,
    input [5:0] op_in,
    input [4:0] rt_in,
    input [4:0] rd_in,
    input [10:0] aux_in,
    input [31:0] imm_dpl_in,
    input [31:0] os_in,
    input [31:0] ot_in,
    output [31:0] pc_out,
    output [5:0] op_out,
    output [4:0] rt_out,
    output [4:0] rd_out,
    output [10:0] aux_out,
    output [31:0] imm_dpl_out,
    output [31:0] os_out,
    output [31:0] ot_out
    );

    reg [31:0] pc, imm_dpl, os, ot;
    reg [5:0] op;
    reg [4:0] rt, rd;
    reg [10:0] aux;
    reg jump_count;
    reg finish;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)begin
            op<=6'b110111;
            jump_count<=1'b0;
            finish<=1'b0;
        end
        else if(finish);
        else if(clk==1)begin
            if(stop_d[1]==1'b1)begin
                jump_count<=1'b1;
                op <= 6'd55;
            end
            else if(jump_count==1'b1)jump_count<=1'b0;
            else if(stop_d[0]==1'b1)begin
                pc <= pc_in;
                op <= op_in;
                rt <= rt_in;
                rd <= rd_in;
                aux <= aux_in;
                imm_dpl <= imm_dpl_in;
                os <= os_in;
                ot <= ot_in;
            end
            else begin
                finish <= 1'b1;
                op <= 6'd55;
            end
        end
    end

    assign pc_out = pc;
    assign op_out = op;
    assign rt_out = rt;
    assign rd_out = rd;
    assign aux_out = aux;
    assign imm_dpl_out = imm_dpl;
    assign os_out = os;
    assign ot_out = ot;
endmodule
