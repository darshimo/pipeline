module data_mem(
    input [7:0] address,
    input clk,
    input wren,
    input [7:0] w_data,
    output [7:0] r_data,
    output [7:0] dm532
    );

    reg [7:0] d_mem [0:255];

    always @(posedge clk)begin
        if(wren==0)d_mem[address] <= w_data;
    end
    assign r_data = d_mem[address];
    assign dm532 = d_mem[133];

endmodule
