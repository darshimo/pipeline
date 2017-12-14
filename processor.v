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
    input cpu_resetn,
    input [7:0] sw,
    output [5:0] op_w,//remove in vivado
    output [7:0] led,
    output oled_dc,
    output oled_res,
    output oled_sclk,
    output oled_sdin,
    output oled_vbat,
    output oled_vdd
    );

    //wire [31:0] pc, ins, os, ot, dm_data, alu_result;
    //wire [5:0] op;
    //wire [4:0] rs, rt, rd, wreg;
    //wire [10:0] aux;
    //wire [31:0] imm_dpl;
    //wire [25:0] addr;
    //wire [3:0] wren;
    //wire [31:0] dm_addr;
    
    reg [31:0] count, total_count;
    
    wire [31:0] dm532, dm900, dm576, r9;
    reg [7:0] data_oled;
    wire [7:0] hoge1, hoge2, hoge3, hoge4;

    //fetch
    wire [31:0] pc_f, ins_f;
    wire [1:0] stop_f;

    //decode
    wire [31:0] pc_d, ins_d, imm_dpl_d, os_d1, os_d2, ot_d1, ot_d2;
    wire [5:0] op_d;
    wire [4:0] rs_d, rt_d, rd_d;
    wire [10:0] aux_d;
    wire [25:0] addr_d;
    wire [1:0] stop_d;

    //execute1
    wire [31:0] pc_e1, imm_dpl_e1, os_e1, ot_e1, alu_result_e1, dm_addr_e1;
    wire [5:0] op_e1;
    wire [4:0] rt_e1, rd_e1, wreg_alu;
    wire [10:0] aux_e1;

    //execute2
    wire [31:0] ot_e2, alu_result_e2, dm_data_e2, dm_addr_e2, result_e2;
    wire [5:0] op_e2;
    wire [4:0] rt_e2, rd_e2, wreg_e2;
    wire [3:0] wren_e2;

    //write
    wire [31:0] result_w;
    //wire [5:0] op_w;
    wire [4:0] wreg_w;

    pc pc0(
    .clk(sysclk),
    .rstd(cpu_resetn),
    .op_d(op_d),
    .addr_d(addr_d),
    .op(op_e1),
    .os(os_e1),
    .ot(ot_e1),
    .imm_dpl(imm_dpl_e1),
    .pc_in(pc_e1),
    .stop_f(stop_f),
    .stop_d(stop_d),
    .pc_out(pc_f)
    );

    fetch fetch0(
    .pc(pc_f),
    .ins(ins_f)
    );

    decoder decoder0(
    .ins(ins_d),
    .op(op_d),
    .rs(rs_d),
    .rt(rt_d),
    .rd(rd_d),
    .aux(aux_d),
    .imm_dpl(imm_dpl_d),
    .addr(addr_d)
    );

    alu alu0(
    .pc(pc_e1),
    .op(op_e1),
    .rt(rt_e1),
    .rd(rd_e1),
    .aux(aux_e1),
    .os(os_e1),
    .ot(ot_e1),
    .imm_dpl(imm_dpl_e1),
    .wreg_alu(wreg_alu),
    .result2(alu_result_e1)
    );

    reg_file reg_file0(
    .clk(sysclk),
    .rstd(cpu_resetn),
    .we(|wreg_w),
    .r_addr1(rs_d),
    .r_addr2(rt_d),
    .w_addr(wreg_w),
    .w_data(result_w),
    .r_data1(os_d1),
    .r_data2(ot_d1),
    .r9(r9)
    );

    data_mem data_mem0(
    .address(dm_addr_e2[7:0]),
    .clk(sysclk),
    .wren(wren_e2[0]),
    .w_data(ot_e2[7:0]),
    .r_data(dm_data_e2[7:0]),
    .dm532(dm532[7:0]),
    .dm900(dm900[7:0]),
    .dm576(dm576[7:0])
    );

    data_mem data_mem1(
    .address(dm_addr_e2[7:0]),
    .clk(sysclk),
    .wren(wren_e2[1]),
    .w_data(ot_e2[15:8]),
    .r_data(dm_data_e2[15:8]),
    .dm532(dm532[15:8]),
    .dm900(dm900[15:8]),
    .dm576(dm576[15:8])
    );

    data_mem data_mem2(
    .address(dm_addr_e2[7:0]),
    .clk(sysclk),
    .wren(wren_e2[2]),
    .w_data(ot_e2[23:16]),
    .r_data(dm_data_e2[23:16]),
    .dm532(dm532[23:16]),
    .dm900(dm900[23:16]),
    .dm576(dm576[23:16])
    );

    data_mem data_mem3(
    .address(dm_addr_e2[7:0]),
    .clk(sysclk),
    .wren(wren_e2[3]),
    .w_data(ot_e2[31:24]),
    .r_data(dm_data_e2[31:24]),
    .dm532(dm532[31:24]),
    .dm900(dm900[31:24]),
    .dm576(dm576[31:24])
    );

    fd_reg fd_reg0(
    .clk(sysclk),
    .rstd(cpu_resetn),
    .stop_f(stop_f),
    .stop_d(stop_d),
    .pc_in(pc_f),
    .ins_in(ins_f),
    .pc_out(pc_d),
    .ins_out(ins_d)
    );

    de_reg de_reg0(
    .clk(sysclk),
    .rstd(cpu_resetn),
    .stop_d(stop_d),
    .pc_in(pc_d),
    .op_in(op_d),
    .rt_in(rt_d),
    .rd_in(rd_d),
    .aux_in(aux_d),
    .imm_dpl_in(imm_dpl_d),
    .os_in(os_d2),
    .ot_in(ot_d2),
    .pc_out(pc_e1),
    .op_out(op_e1),
    .rt_out(rt_e1),
    .rd_out(rd_e1),
    .aux_out(aux_e1),
    .imm_dpl_out(imm_dpl_e1),
    .os_out(os_e1),
    .ot_out(ot_e1)
    );

    ee_reg ee_reg0(
    .clk(sysclk),
    .rstd(cpu_resetn),
    .op_in(op_e1),
    .rd_in(rd_e1),
    .rt_in(rt_e1),
    .ot_in(ot_e1),
    .dm_addr_in(dm_addr_e1),
    .alu_result_in(alu_result_e1),
    .op_out(op_e2),
    .rd_out(rd_e2),
    .rt_out(rt_e2),
    .ot_out(ot_e2),
    .dm_addr_out(dm_addr_e2),
    .alu_result_out(alu_result_e2)
    );

    ew_reg ew_reg0(
    .clk(sysclk),
    .rstd(cpu_resetn),
    .op_in(op_e2),
    .wreg_in(wreg_e2),
    .result_in(result_e2),
    .op_out(op_w),
    .wreg_out(wreg_w),
    .result_out(result_w)
    );

    wregn wregn0(
    .op(op_e2),
    .rd(rd_e2),
    .rt(rt_e2),
    .wreg(wreg_e2),
    .wren(wren_e2)
    );

    choice choice0(
    .op(op_e2),
    .alu_result(alu_result_e2),
    .dm_data(dm_data_e2),
    .result(result_e2)
    );

    display_top display_top0(
    .SYSCLK_IP(sysclk),
    .SW_IP(sw),
    .CPU_RESETN_IP(cpu_resetn),
    .LED_OP(led),
    .OLED_DC_OP(oled_dc),     //Data/Command Pin
    .OLED_RES_OP(oled_res),    //OLED RES
    .OLED_SCLK_OP(oled_sclk),   //SPI Clock
    .OLED_SDIN_OP(oled_sdin),   //SPI data out
    .OLED_VBAT_OP(oled_vbat),   //VBAT enable
    .OLED_VDD_OP(oled_vdd),     //VDD enable
    .WE_IP(1'b1),
    .WRITE_ADDR_IP(6'b111111),
    .WRITE_DATA_IP(data_oled)
    );

    assign hoge1 = (r9==32'd55)?8'h2B:8'h2D;
    assign hoge2 = (dm576==32'd987)?8'h2B:8'h2D;
    assign hoge3 = (dm900==32'd97)?8'h2B:8'h2D;
    assign hoge4 = (dm532==32'h00000315)?8'h2B:8'h2D;

    assign dm_addr_e1 = (os_e1+imm_dpl_e1)>>>2;
    assign os_d2 = (rs_d==5'd0)?32'h00000000:(rs_d==wreg_alu)?alu_result_e1:(rs_d==wreg_e2)?result_e2:(rs_d==wreg_w)?result_w:os_d1;
    assign ot_d2 = (rt_d==5'd0)?32'h00000000:(rt_d==wreg_alu)?alu_result_e1:(rt_d==wreg_e2)?result_e2:(rt_d==wreg_w)?result_w:ot_d1;

    always @(posedge sysclk or negedge cpu_resetn)begin
        if(cpu_resetn==0)begin
            data_oled <= 8'h2C;
            count <= 0;
            total_count <= 32'd0;
        end
        else if(op_w==6'b111111)begin
            data_oled <= hoge4;
            total_count <= count + 32'd1;
        end
        else count <= count + 31'd1;
    end

initial $monitor("sysclk = %d, count = %d, pc_e1 = %d, op_e1 = %d, r9(55) = %d, dm576(987) = %d, dm900(97) = %d, dm532(315) = %h, data_oled = %h, total = %d", sysclk, count, pc_e1, op_e1, r9, dm576, dm900, dm532, data_oled, total_count);

endmodule
