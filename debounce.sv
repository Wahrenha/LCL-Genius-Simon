module debounce #(
    parameter integer FREQ_CLOCK_HZ = 50_000_000,
    parameter integer TEMPO_DEBOUNCE_MS = 10
)(
    input  logic clk,
    input  logic entrada,
    output logic saida,
    output logic d_pulso
);
    localparam integer CONTAGEM_MAXIMA = (FREQ_CLOCK_HZ / 1000) * TEMPO_DEBOUNCE_MS;
    localparam integer LARGURA_BITS = $clog2(CONTAGEM_MAXIMA + 1);

    logic [LARGURA_BITS-1:0] contador;
    logic                    saida_anterior;

    always_ff @(posedge clk) begin
        if (entrada != saida) begin
            if (contador >= CONTAGEM_MAXIMA[LARGURA_BITS-1:0]) begin
                saida    <= entrada;
                contador <= '0;
            end else begin
                contador <= contador + 1'b1;
            end
        end else begin
            contador <= '0;
        end
    end

    always_ff @(posedge clk) begin
        saida_anterior <= saida;
        d_pulso        <= saida & ~saida_anterior;
    end

endmodule