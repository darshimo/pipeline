module stopper(
    input [5:0] op,
    output [1:0] stop
    );

    function [1:0] stop_gen;
        input [5:0] op;
            case(op)
                6'd32,6'd33,6'd34,6'd35,6'd42:stop_gen=2'b11;
                6'd40,6'd41:stop_gen=2'b01;
                6'd16,6'd18,6'd20:stop_gen=2'b10;
                default:stop_gen=2'b00;
            endcase
    endfunction

    assign stop = stop_gen(op);
endmodule
