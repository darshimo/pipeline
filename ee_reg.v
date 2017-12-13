module ee_reg(
    input clk,
    input rstd,
    input [5:0] op_in,
    input [4:0] rd_in,
    input [4:0] rt_in,
    input [31:0] ot_in,
    input [31:0] dm_addr_in,
    input [31:0] alu_result_in,
    output [5:0] op_out,
    output [4:0] rd_out,
    output [4:0] rt_out,
    output [31:0] ot_out,
    output [31:0] dm_addr_out,
    output [31:0] alu_result_out
    );

    reg [31:0] ot, dm_addr, alu_result;
    reg [4:0] rd, rt;
    reg [5:0] op;

    always @(posedge clk or negedge rstd)begin
        if(rstd==0)op<=6'b110111;
        else if(clk==1)begin
            op <= op_in;
            rd <= rd_in;
            rt <= rt_in;
            ot <= ot_in;
            dm_addr <= dm_addr_in;
            alu_result <= alu_result_in;
        end
    end

    assign op_out = op;
    assign rd_out = rd;
    assign rt_out = rt;
    assign ot_out = ot;
    assign dm_addr_out = dm_addr;
    assign alu_result_out = alu_result;
endmodule
