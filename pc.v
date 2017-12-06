module pc(
    input clk,
    input rstd,
    input [5:0] op,
    input [31:0] os,
    input [31:0] ot,
    input [25:0] addr,
    input [31:0] imm_dpl,
    input [31:0] pc_in,
    output [31:0] pc_out
    );

    reg [31:0] pc, counter;
    wire [31:0] branch, nonbranch;

    function [31:0] npc;
        input [5:0] op;
        input [31:0] os, ot, branch, nonbranch, addr;
            case(op)
                6'd32:npc = (os==ot)?branch:nonbranch;
                6'd33:npc = (os!=ot)?branch:nonbranch;
                6'd34:npc = (os<ot)?branch:nonbranch;
                6'd35:npc = (os<=ot)?branch:nonbranch;
                6'd40,6'd41:npc = addr>>2;
                6'd42:npc = os;
                default:npc = nonbranch;
            endcase
    endfunction

    assign nonbranch = pc_in + 32'd1;
    assign branch = nonbranch + (imm_dpl>>2);

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)begin
            pc<=32'h00000000;
            counter<=32'h00000000;
        end
        else if(clk==1)if(pc_in==pc_out)begin
            pc <= npc(op, os, ot, branch, nonbranch, addr);
            counter<=counter+32'h00000001;
        end
    end

    assign pc_out = pc;
endmodule
