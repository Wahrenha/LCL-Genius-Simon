module timer_5s #(
    parameter integer FREQ_CLOCK_HZ = 50_000_000,
    parameter integer TEMPO_LIMITE_S = 5
)(
    input  logic clk,
    input  logic enable,
    input  logic reinicia,
    output logic timeout
);
    localparam logic [31:0] CONTAGEM_MAXIMA = FREQ_CLOCK_HZ * TEMPO_LIMITE_S;

    logic [31:0] contador;

    always_ff @(posedge clk) begin
        if (reinicia) begin
            contador <= 32'd0;
            timeout  <= 1'b0;
        end else if (enable) begin
            if (contador >= CONTAGEM_MAXIMA)
                timeout <= 1'b1;
            else
                contador <= contador + 1'b1;
        end else begin
            contador <= 32'd0;
            timeout  <= 1'b0;
        end
    end

endmodule