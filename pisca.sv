module pisca#(
    parameter integer FREQ_CLOCK_HZ  = 50_000_000,
    parameter integer TEMPO_PISCA_MS = 200,
    parameter integer NUM_PISCADAS   = 6
)(
    input  logic clk,
    input  logic start,
    output logic leds_acesos,
    output logic ocupado
);
    localparam logic [31:0] MEIO_PERIODO = (FREQ_CLOCK_HZ / 1000) * TEMPO_PISCA_MS;
    localparam integer      TOTAL_ETAPAS = NUM_PISCADAS * 2;

    logic [31:0] contador;
    logic [$clog2(TOTAL_ETAPAS+1)-1:0] cont_etapas;
    logic rodando;

    assign ocupado = rodando;

    always_ff @(posedge clk) begin
        if (start && !rodando) begin
            rodando     <= 1'b1;
            contador    <= 32'd0;
            cont_etapas <= '0;
            leds_acesos <= 1'b1;
        end else if (rodando) begin
            if (contador >= MEIO_PERIODO) begin
                contador    <= 32'd0;
                leds_acesos <= ~leds_acesos;
                if (cont_etapas == TOTAL_ETAPAS - 1) begin
                    rodando     <= 1'b0;
                    leds_acesos <= 1'b0;
                end else
                    cont_etapas <= cont_etapas + 1'b1;
            end else
                contador <= contador + 1'b1;
        end
    end

endmodule