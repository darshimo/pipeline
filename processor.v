`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2016/09/13 16:33:03
// Design Name:
// Module Name: top_module
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


module processor(
    input sysclk,
    input rstd,
    input [7:0] sw,
    input [31:0] count,
    output [5:0] op,
    output [7:0] led
    );

    wire [31:0] pc, ins, os, ot, dm_data, alu_result;
//    wire [5:0] op;
    wire [4:0] rs, rt, rd, wreg;
    wire [10:0] aux;
    wire [31:0] imm_dpl;
    wire [25:0] addr;
    wire [3:0] wren;
    wire [31:0] dm_addr;
    wire [31:0] dm532;

    pc pc0(
    .clk(sysclk),
    .rstd(rstd),
    .op(op),
    .os(os),
    .ot(ot),
    .addr(addr),
    .imm_dpl(imm_dpl),
    .pc(pc)
    );

    fetch fetch0(
    .pc(pc),
    .ins(ins)
    );

    decoder decoder0(
    .ins(ins),
    .op(op),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .aux(aux),
    .imm_dpl(imm_dpl),
    .addr(addr)
    );

    alu alu0(
    .pc(pc),
    .op(op),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .aux(aux),
    .os(os),
    .ot(ot),
    .imm_dpl(imm_dpl),
    .dm_data(dm_data),
    .wreg(wreg),
    .wren(wren),
    .dm_addr(dm_addr),
    .result2(alu_result)
    );

    reg_file reg_fire0(
    .clk(sysclk),
    .rstd(rstd),
    .we(|wreg),
    .r_addr1(rs),
    .r_addr2(rt),
    .r_data1(os),
    .r_data2(ot),
    .w_addr(wreg),
    .w_data(alu_result)
    );

    data_mem data_mem0(
    .address(dm_addr[7:0]),
    .clk(sysclk),
    .wren(wren[0]),
    .w_data(alu_result[7:0]),
    .r_data(dm_data[7:0]),
    .dm532(dm532[7:0])
    );

    data_mem data_mem1(
    .address(dm_addr[7:0]),
    .clk(sysclk),
    .wren(wren[1]),
    .w_data(alu_result[15:8]),
    .r_data(dm_data[15:8]),
    .dm532(dm532[15:8])
    );

    data_mem data_mem2(
    .address(dm_addr[7:0]),
    .clk(sysclk),
    .wren(wren[2]),
    .w_data(alu_result[23:16]),
    .r_data(dm_data[23:16]),
    .dm532(dm532[23:16])
    );

    data_mem data_mem3(
    .address(dm_addr[7:0]),
    .clk(sysclk),
    .wren(wren[3]),
    .w_data(alu_result[31:24]),
    .r_data(dm_data[31:24]),
    .dm532(dm532[31:24])
    );

initial $monitor("sysclk = %d, count = %d, pc = %d, ins = %b, op = %d, opr = %d, os = %d, ot = %d, alu_result = %d, dm532 = %h", sysclk, count, pc, ins, op, aux[4:0], os, ot, alu_result, dm532);

endmodule
