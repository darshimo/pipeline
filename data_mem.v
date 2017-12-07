module data_mem(
    input [7:0] address,
    input clk,
    input wren,
    input [7:0] w_data,
    output [7:0] r_data,
    output [7:0] dm532
    );

    reg [7:0] d_mem [0:255];
    wire [7:0] dm576, dm520, dm524, dm528, dm536, dm540, dm544, dm548, dm552, dm556;

    always @(posedge clk)begin
        if(wren==0)d_mem[address] <= w_data;
    end

    assign r_data = d_mem[address];
    assign dm576 = d_mem[144]; //sample2 987
    assign dm520 = d_mem[130]; //sample3 2
    assign dm524 = d_mem[131]; //sample3 3
    assign dm528 = d_mem[132]; //sample3 4
    assign dm532 = d_mem[133]; //sample3 5 & sample4 0x00000315
    assign dm536 = d_mem[134]; //sample3 6
    assign dm540 = d_mem[135]; //sample3 7
    assign dm544 = d_mem[136]; //sample3 8
    assign dm548 = d_mem[137]; //sample3 9
    assign dm552 = d_mem[138]; //sample3 10
    assign dm556 = d_mem[139]; //sample3 11

endmodule
