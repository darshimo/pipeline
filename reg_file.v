module reg_file(clk, rstd, we, r_addr1, r_addr2, r_data1, r_data2, w_addr, w_data);
input clk, we, rstd;
input [4:0] r_addr1, r_addr2, w_addr;
input [31:0] w_data;
output [31:0] r_data1, r_data2;
reg [31:0] mem [0:31];
always @(posedge clk or negedge rstd) begin
    if(rstd==0)mem[0] <= 32'h00000000;
    else if(we) mem[w_addr] <= w_data;
end
assign r_data1 = mem[r_addr1];
assign r_data2 = mem[r_addr2];
endmodule
