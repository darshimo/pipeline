module decoder(
    input [31:0] ins,
    output [5:0] op,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [10:0] aux,
    output [31:0] imm_dpl,
    output [25:0] addr
    );

    assign op = ins[31:26];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign aux = ins[10:0];
    assign imm_dpl = ins[15:0];
    assign addr = ins[25:0];
endmodule
