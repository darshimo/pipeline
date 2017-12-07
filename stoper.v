module stoper(
    input [5:0] op_d,
    input [5:0] op_e,
    input [5:0] op_w,
    output [2:0] jon
    );

    function jon_gen;
        input [5:0] op;
            case(op)
                6'd32,6'd33,6'd34,6'd35,6'd40,6'd41,6'd42:jon_gen=1;
                default:jon_gen=0;
            endcase
    endfunction

    assign jon[0] = jon_gen(op_d);
    assign jon[1] = jon_gen(op_e);
    assign jon[2] = jon_gen(op_w);
endmodule
