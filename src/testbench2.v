`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/13 17:14:20
// Design Name: 
// Module Name: testbench
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
module testbench();
    reg clk; // input �� reg
    reg rstd;
    reg [7:0] sw;
    wire [7:0] led; // output �� wire
    wire [5:0] op;
    wire oled_dc, oled_res, oled_sclk, oled_sdin, oled_vbat, oled_vdd;

//    wire [3:0] operand1, operand2;
//    wire [7:0] hoge;
    
    processor processor0( // simulation ��������� instance ��
    .sysclk(clk),
    .cpu_resetn(rstd),
    .sw(sw),
    .op_w(op),
    .led(led),
    .oled_dc(oled_dc),
    .oled_res(oled_res),
    .oled_sclk(oled_sclk),
    .oled_sdin(oled_sdin),
    .oled_vbat(oled_vbat),
    .oled_vdd(oled_vdd)
    );

//    assign operand1 = sw[7:4];
//    assign operand2 = sw[3:0];
//    assign hoge = led[7:0];

    initial begin
        $dumpfile("sim2_pipe.vcd");
        $dumpvars;
        clk <= 1'b0;
    end

    always #5 begin
        clk <= ~clk;
    end

    task wait_posedge_clk;
        input   n;
        integer n;

        begin
            for(n=n; n>0; n=n-1) begin
                @(posedge clk)
                    ;
            end
        end
    endtask

    initial begin
            rstd=1;
        #1  rstd=0;
        #2  rstd=1;

        wait_posedge_clk(1);

        while(~&op)begin
            wait_posedge_clk(1);
        end
        
        wait_posedge_clk(3);

        $finish;
    end
    
endmodule
