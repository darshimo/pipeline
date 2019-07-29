module fetch(
    input [31:0] pc,
    output [31:0] ins
    );

    reg [31:0] ins_mem [0:255];

    initial $readmemb("bin/sample2.bin",ins_mem);

    assign ins = ins_mem[pc[7:0]];

endmodule
