module stopper(
    input [5:0] op,
    output [1:0] jon
    );

    function [1:0] jon_gen;
        input [5:0] op;
            case(op)
                6'd32,6'd33,6'd34,6'd35:jon_gen=2'b11;
                6'd40,6'd41:jon_gen=2'b01;
                6'd42:jon_gen=2'b10;
                default:jon_gen=2'b00;
            endcase
    endfunction

    assign jon = jon_gen(op);
endmodule
