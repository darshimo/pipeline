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
    reg [31:0] count;
    wire [7:0] led; // output �� wire
    wire [5:0] op;

//    wire [3:0] operand1, operand2;
//    wire [7:0] hoge;
    
    processor processor0( // simulation ��������� instance ��
    .sysclk(clk),
    .rstd(rstd),
    .sw(sw),
    .count(count),
    .op(op),
    .led(led)
    );

//    assign operand1 = sw[7:4];
//    assign operand2 = sw[3:0];
//    assign hoge = led[7:0];

    initial begin
        count = 0;
        clk <= 1'b0;
        sw <= 8'b0;
    end

    always #5 begin
        clk <= ~clk;
    end

    always @(posedge clk)
        count = count + 1;

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
        $dumpfile("test4.vcd");
        $dumpvars;
            rstd=1;
        #1  rstd=0;
        #2  rstd=1;

        wait_posedge_clk(1);

        while(~&op)begin
            wait_posedge_clk(1);
        end

        $finish;
    end
    
endmodule
