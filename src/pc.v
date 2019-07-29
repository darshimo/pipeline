module pc(
    input clk,
    input rstd,
    input [5:0] op_d,
    input [25:0] addr_d,//addr_d
    input [5:0] op,//op_e1
    input [31:0] os,//os_e1
    input [31:0] ot,//ot_e1
    input [31:0] imm_dpl,//imm_dpl_e1
    input [31:0] pc_in,//pc_e1
    output [1:0] stop_f,
    output [1:0] stop_d,
    output [31:0] pc_out
    );

    reg finish;
    reg [31:0] pc;
    wire [31:0] branch, nonbranch;

    function [31:0] npc;
        input [1:0] stop_d;
        input [31:0] os, branch, nonbranch;
            case(stop_d)
                2'b11:npc = branch;
                2'b10:npc = os;
                default:npc = nonbranch;
            endcase
    endfunction

    function [1:0] stop_f_gen;
        input [5:0] op;
            case(op)
                6'd40,6'd41:stop_f_gen=2'b11;
                6'd16,6'd18,6'd20:stop_f_gen=2'b10;
                default:stop_f_gen=2'b01;
            endcase
    endfunction

    function [1:0] stop_d_gen;
        input [5:0] op;
        input [31:0] os, ot;
            case(op)
                6'd32:stop_d_gen = (os==ot)?2'b11:2'b01;
                6'd33:stop_d_gen = (os!=ot)?2'b11:2'b01;
                6'd34:stop_d_gen = (os<ot)?2'b11:2'b01;
                6'd35:stop_d_gen = (os<=ot)?2'b11:2'b01;
                6'd42:stop_d_gen = 2'b10;
                6'd63:stop_d_gen = 2'b00;
                default:stop_d_gen = 2'b01;
            endcase
    endfunction

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)begin
            finish <= 1'b0;
            pc<=32'h00000000;
        end
        else if(finish);
        else if(clk==1)begin
            if(op==6'd63)begin
                finish<=1'b1;
                pc<=31'd0;
            end
            else if(stop_d[1]==1'b1)pc<=npc(stop_d, os, branch, nonbranch);
            else if(stop_f==2'b11)pc <= addr_d>>2;
            else if(stop_f==2'b10);
            else pc <= nonbranch;
        end
    end

    assign nonbranch = pc + 32'd1;
    assign branch = pc_in + 32'd1 + (imm_dpl>>2);
    assign pc_out = pc;
    assign stop_f = (op==6'd63)?2'b00:stop_f_gen(op_d);
    assign stop_d = stop_d_gen(op, os, ot);
endmodule
