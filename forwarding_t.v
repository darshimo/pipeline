module forwarding_t(
    input clk,
    input [4:0] rt,
    input [31:0] ot_in,
    input [4:0] wreg_b,
    input [31:0] w_data_b,
    output [31:0] ot_out
    );

    reg [4:0] wreg_bb;
    reg [31:0] w_data_bb;

    always @(posedge clk)begin
        wreg_bb <= wreg_b;
        w_data_bb <= w_data_b;
    end

    assign ot_out = (rt==5'd0)?32'h00000000:(rt==wreg_b)?w_data_b:(rt==wreg_bb)?w_data_bb:ot_in;

endmodule
