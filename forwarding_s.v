module forwarding_s(
    input clk,
    input [4:0] rs,
    input [31:0] os_in,
    input [4:0] wreg_b,
    input [31:0] w_data_b,
    output [31:0] os_out
    );

    reg [4:0] wreg_bb;
    reg [31:0] w_data_bb;

    always @(posedge clk)begin
        wreg_bb <= wreg_b;
        w_data_bb <= w_data_b;
    end

    assign os_out = (rs==5'd0)?32'h00000000:(rs==wreg_b)?w_data_b:(rs==wreg_bb)?w_data_bb:os_in;

endmodule
