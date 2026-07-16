module randomizer #(
    parameter integer LARGURA = 8
)(
    input  logic               clk,
    output logic [LARGURA-1:0] valor
);
    logic feedback;
    assign feedback = valor[7] ^ valor[5] ^ valor[4] ^ valor[3];

    initial valor = 8'hA5;

    always_ff @(posedge clk)
        valor <= {valor[LARGURA-2:0], feedback};

endmodule