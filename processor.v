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
    input [31:0] count,
    output [5:0] op_w,
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
    
    wire rstd;
    reg [31:0] total_count;
    assign rstd = cpu_resetn;
    
    wire [31:0] dm532, dm900, dm576, r9;
    reg [7:0] data_oled;
    wire [7:0] hoge1, hoge2, hoge3, hoge4;

    //fetch
    wire [31:0] pc_f, ins_f;
    wire [5:0] op_f;

    //decode
    wire [31:0] pc_d, ins_d, imm_dpl_d, os_d, ot_d;
    wire [5:0] op_d;
    wire [4:0] rs_d, rt_d, rd_d;
    wire [10:0] aux_d;
    wire [25:0] addr_d;

    //execute
    wire [31:0] pc_e, imm_dpl_e, os_e1, ot_e1, os_e2, ot_e2, alu_result_e, dm_data_e, dm_addr_e;
    wire [5:0] op_e;
    wire [4:0] rs_e, rt_e, rd_e, wreg_e;
    wire [10:0] aux_e;
    wire [25:0] addr_e;
    wire [3:0] wren_e;

    //write
    wire [31:0] pc_w, imm_dpl_w, os_w, ot_w, alu_result_w;
    //wire [5:0] op_w;
    wire [25:0] addr_w;
    wire [4:0] wreg_w;

    wire [1:0] jon_d;
    
    pc pc0(
    .clk(sysclk),
    .rstd(rstd),
    .jon_d(jon_d),
    .addr_d(addr_d),
    .op(op_w),
    .os(os_w),
    .ot(ot_w),
    .imm_dpl(imm_dpl_w),
    .pc_in(pc_w),
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
    .pc(pc_e),
    .op(op_e),
    .rt(rt_e),
    .rd(rd_e),
    .aux(aux_e),
    .os(os_e2),
    .ot(ot_e2),
    .imm_dpl(imm_dpl_e),
    .dm_data(dm_data_e),
    .wreg(wreg_e),
    .wren(wren_e),
    .dm_addr(dm_addr_e),
    .result2(alu_result_e)
    );

    reg_file reg_file0(
    .clk(sysclk),
    .rstd(rstd),
    .we(|wreg_w),
    .r_addr1(rs_d),
    .r_addr2(rt_d),
    .w_addr(wreg_w),
    .w_data(alu_result_w),
    .r_data1(os_d),
    .r_data2(ot_d),
    .r9(r9)
    );

    data_mem data_mem0(
    .address(dm_addr_e[7:0]),
    .clk(sysclk),
    .wren(wren_e[0]),
    .w_data(alu_result_e[7:0]),
    .r_data(dm_data_e[7:0]),
    .dm532(dm532[7:0]),
    .dm900(dm900[7:0]),
    .dm576(dm576[7:0])
    );

    data_mem data_mem1(
    .address(dm_addr_e[7:0]),
    .clk(sysclk),
    .wren(wren_e[1]),
    .w_data(alu_result_e[15:8]),
    .r_data(dm_data_e[15:8]),
    .dm532(dm532[15:8]),
    .dm900(dm900[15:8]),
    .dm576(dm576[15:8])
    );

    data_mem data_mem2(
    .address(dm_addr_e[7:0]),
    .clk(sysclk),
    .wren(wren_e[2]),
    .w_data(alu_result_e[23:16]),
    .r_data(dm_data_e[23:16]),
    .dm532(dm532[23:16]),
    .dm900(dm900[23:16]),
    .dm576(dm576[23:16])
    );

    data_mem data_mem3(
    .address(dm_addr_e[7:0]),
    .clk(sysclk),
    .wren(wren_e[3]),
    .w_data(alu_result_e[31:24]),
    .r_data(dm_data_e[31:24]),
    .dm532(dm532[31:24]),
    .dm900(dm900[31:24]),
    .dm576(dm576[31:24])
    );

    fd_reg fd_reg0(
    .clk(sysclk),
    .rstd(rstd),
    .jon_d(jon_d),
    .pc_in(pc_f),
    .ins_in(ins_f),
    .pc_out(pc_d),
    .ins_out(ins_d)
    );

    de_reg de_reg0(
    .clk(sysclk),
    .rstd(rstd),
    .wreg_e(wreg_e),
    .wreg_w(wreg_w),
    .pc_in(pc_d),
    .op_in(op_d),
    .rs_in(rs_d),
    .rt_in(rt_d),
    .rd_in(rd_d),
    .aux_in(aux_d),
    .imm_dpl_in(imm_dpl_d),
    .addr_in(addr_d),
    .os_in(os_d),
    .ot_in(ot_d),
    .pc_out(pc_e),
    .op_out(op_e),
    .rs_out(rs_e),
    .rt_out(rt_e),
    .rd_out(rd_e),
    .aux_out(aux_e),
    .imm_dpl_out(imm_dpl_e),
    .addr_out(addr_e),
    .os_out(os_e1),
    .ot_out(ot_e1)
    );

    ew_reg ew_reg0(
    .clk(sysclk),
    .rstd(rstd),
    .pc_in(pc_e),
    .op_in(op_e),
    .os_in(os_e2),
    .ot_in(ot_e2),
    .addr_in(addr_e),
    .imm_dpl_in(imm_dpl_e),
    .wreg_in(wreg_e),
    .alu_result_in(alu_result_e),
    .pc_out(pc_w),
    .op_out(op_w),
    .os_out(os_w),
    .ot_out(ot_w),
    .addr_out(addr_w),
    .imm_dpl_out(imm_dpl_w),
    .wreg_out(wreg_w),
    .alu_result_out(alu_result_w)
    );

    forwarding_s forwarding_s0(
    .clk(sysclk),
    .rs(rs_e),
    .os_in(os_e1),
    .wreg_b(wreg_w),
    .w_data_b(alu_result_w),
    .os_out(os_e2)
    );

    forwarding_t forwarding_t0(
    .clk(sysclk),
    .rt(rt_e),
    .ot_in(ot_e1),
    .wreg_b(wreg_w),
    .w_data_b(alu_result_w),
    .ot_out(ot_e2)
    );

    stopper stopper0(
    .op(op_d),
    .jon(jon_d)
    );
    
    display_top display_top0(
    .SYSCLK_IP(sysclk),
    .SW_IP(sw),
    .CPU_RESETN_IP(rstd),
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

    assign op_f = ins_f[31:26];
    
    assign hoge1 = (r9==32'd55)?8'h2B:8'h2D;
    assign hoge2 = (dm576==32'd987)?8'h2B:8'h2D;
    assign hoge3 = (dm900==32'd97)?8'h2B:8'h2D;
    assign hoge4 = (dm532==32'h00000315)?8'h2B:8'h2D;
    
    always @(posedge sysclk or negedge rstd)begin
        if(rstd==0)begin
            data_oled <= 8'h2C;
            total_count <= 32'd0;
        end
        else if(op_w==6'b111111)begin
            data_oled <= hoge4;
            total_count <= count + 32'd1;
        end
    end

initial $monitor("sysclk = %d, count = %d, pc_f = %d, op_d = %d, r9(55) = %d, dm576(987) = %d, dm900(97) = %d, dm532(315) = %h, data_oled = %h, total = %d", sysclk, count, pc_f, op_d, r9, dm576, dm900, dm532, data_oled, total_count);

endmodule
