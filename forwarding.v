module forwarding(
    input clk,
    input [4:0] reg_in,
    input [31:0] operand_in,
    input [4:0] wreg_b,
    input [31:0] w_data_b,
    output [31:0] operand_out
    );

    reg [4:0] wreg_bb;
    reg [31:0] w_data_bb;

    always @(posedge clk)begin
        wreg_bb <= wreg_b;
        w_data_bb <= w_data_b;
    end

    assign operand_out = (reg_in==5'd0)?32'h00000000:(reg_in==wreg_b)?w_data_b:(reg_in==wreg_bb)?w_data_bb:operand_in;

endmodule
