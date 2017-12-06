module fd_reg(
    input clk,
    input rstd,
    input [5:0] op_d,
    input [5:0] op_e,
    input [5:0] op_w,
    input [31:0] pc_in,
    inout [31:0] ins_in,
    output [31:0] pc_out,
    output [31:0] ins_out
    );

    reg [31:0] pc, ins;
    wire [2:0] jon123;

    function jon;//jump or not
        input [5:0] op;
            case(op)
                6'd32,6'd33,6'd34,6'd35,6'd40,6'd41,6'd42:jon=1;
                default:jon=0;
            endcase
    endfunction


    always @(posedge clk or negedge rstd)begin
        if(rstd==0)ins<=32'hdc000000;
        else if(clk==1)begin
            pc <= pc_in;
            if(|jon123)ins <= 32'hdc000000;
            else ins <= ins_in;
        end
    end

    assign jon123[0] = jon(op_d);
    assign jon123[1] = jon(op_e);
    assign jon123[2] = jon(op_w);
    assign pc_out = pc;
    assign ins_out = ins;
endmodule
