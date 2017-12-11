`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/13 17:10:06
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [31:0] pc,
    input [5:0] op,
    input [4:0] rt,
    input [4:0] rd,
    input [10:0] aux,
    input [31:0] os,
    input [31:0] ot,
    input [31:0] imm_dpl,
    output [4:0] wreg,
    output [3:0] wren,
    output [31:0] result2
    );
    
    wire [4:0] opr;
    wire [4:0] shift;
    wire [31:0] result1;
    
    function [31:0] alu1;
        input [4:0] opr, shift;
        input [31:0] os, ot;
        case(opr)
            5'd0:alu1 = os + ot;
            5'd2:alu1 = os - ot;
            5'd8:alu1 = os & ot;
            5'd9:alu1 = os | ot;
            5'd10:alu1 = os ^ ot;
            5'd11:alu1 = ~(os | ot);
            5'd16:alu1 = os << shift;
            5'd17:alu1 = os >> shift;
            5'd18:alu1 = os >>> shift;
            default:alu1 = 32'hffffffff;
        endcase
    endfunction
            
    function [31:0] alu2;
        input [5:0] op;
        input [31:0] result1, os, imm_dpl, ot, pc;
        case(op)//decide operation
            6'd0:alu2 = result1;
            6'd1:alu2 = os + imm_dpl;
            6'd3:alu2 = imm_dpl<<16;
            6'd4:alu2 = os & imm_dpl;
            6'd5:alu2 = os | imm_dpl;
            6'd6:alu2 = os ^ imm_dpl;
            6'd24,6'd26,6'd28:alu2 = ot;
            6'd41:alu2 = pc + 32'd1;
            default:alu2 = 32'hffffffff;
        endcase
    endfunction

    function [4:0] wreg_gen;
        input [5:0] op;
        input [4:0] rd, rt;
        case(op)//decide wreg
            6'd0:wreg_gen = rd;
            6'd1,6'd3,6'd4,6'd5,6'd6,6'd16,6'd18,6'd20:wreg_gen = rt;
            6'd41:wreg_gen = 5'd31;
            default:wreg_gen = 5'd0;//jissai ha kakikonde inai
        endcase
    endfunction

    function [3:0] wren_gen;
        input [5:0] op;
        case(op)//decide wren
            6'd24:wren_gen = 4'b0000;
            6'd26:wren_gen = 4'b1100;
            6'd28:wren_gen = 4'b1110;
            default:wren_gen = 4'b1111;
        endcase
    endfunction

    assign result1 = alu1(opr, shift, os, ot);
    assign result2 = alu2(op, result1, os, imm_dpl, ot, pc);
    assign opr = aux[4:0];
    assign shift = aux[10:6];
    assign wreg = wreg_gen(op, rd, rt);
    assign wren = wren_gen(op);
endmodule
