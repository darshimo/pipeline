module wregn(
    input [5:0] op,
    input [4:0] rd,
    input [4:0] rt,
    output [4:0] wreg,
    output [3:0] wren
    );

    function [4:0] wreg_gen;
        input [5:0] op;
        input [4:0] rd, rt;
        case(op)
            6'd0:wreg_gen = rd;
            6'd1,6'd3,6'd4,6'd5,6'd6,6'd16,6'd18,6'd20:wreg_gen = rt;
            6'd41:wreg_gen = 5'd31;
            default:wreg_gen = 5'd0;
        endcase
    endfunction

    function [3:0] wren_gen;
        input [5:0] op;
        case(op)
            6'd24:wren_gen = 4'b0000;
            6'd26:wren_gen = 4'b1100;
            6'd28:wren_gen = 4'b1110;
            default:wren_gen = 4'b1111;
        endcase
    endfunction

    assign wreg = wreg_gen(op, rd, rt);
    assign wren = wren_gen(op);
endmodule
