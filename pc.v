module pc(
    input clk,
    input rstd,
    input [1:0] jon_d,
    input [25:0] addr_d,//addr_w
    input [5:0] op,//op_w
    input [31:0] os,//os_w
    input [31:0] ot,//ot_w
    input [31:0] imm_dpl,//imm_dpl_w
    input [31:0] pc_in,
    output [31:0] pc_out
    );

    reg [31:0] pc;
    wire [31:0] branch, nonbranch;
    reg [1:0] jump_count;

    function [31:0] npc;
        input [5:0] op;
        input [31:0] os, ot, branch, nonbranch;
            case(op)
                6'd32:npc = (os==ot)?branch:nonbranch;
                6'd33:npc = (os!=ot)?branch:nonbranch;
                6'd34:npc = (os<ot)?branch:nonbranch;
                6'd35:npc = (os<=ot)?branch:nonbranch;
                6'd42:npc = os;
                default:npc = nonbranch;
            endcase
    endfunction

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)begin
            pc<=32'h00000000;
            jump_count <= 2'd0;
        end
        else if(clk==1)begin
            //aboun pc
            if(jon_d==2'b01)pc <= addr_d>>2;
            else if(jump_count==2'd1)pc<=npc(op, os, ot, branch, nonbranch);
            else pc <= pc + 32'd1;
            //about jump_count
            if(jon_d[1]==1'd1)jump_count <= 2'd2;
            else if(jump_count>2'd0)jump_count<=jump_count-2'd1;
            else ;
        end
    end

    assign nonbranch = pc_in + 32'd1;
    assign branch = nonbranch + (imm_dpl>>2);
    assign pc_out = pc;
endmodule
