module reg_file(
    input clk,
    input rstd,
    input we,
    input [4:0] r_addr1,
    input [4:0] r_addr2,
    input [4:0] w_addr,
    input [31:0] w_data,
    output [31:0] r_data1,
    output [31:0] r_data2,
    output [31:0] r9
);

    reg [31:0] mem [0:31];

    always @(posedge clk or negedge rstd) begin
        if(rstd==0)mem[0] <= 32'h00000000;
        else if(we) mem[w_addr] <= w_data;
    end

    assign r9 = mem[9]; //sample1 55
    assign r_data1 = mem[r_addr1];
    assign r_data2 = mem[r_addr2];

endmodule
