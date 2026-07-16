module beep #(
    parameter integer FREQ_CLOCK_HZ = 50_000_000
)(
    input  logic        clk,
    input  logic        enable,
    input  logic [19:0] frequencia_hz,
    output logic        onda_saida
);
    logic [31:0] cont_meio_periodo;
    logic [31:0] contador;

    assign cont_meio_periodo = (frequencia_hz == 0) ? 32'd1
                             : (FREQ_CLOCK_HZ / (32'(frequencia_hz) * 2));

    always_ff @(posedge clk) begin
        if (!enable) begin
            contador   <= 32'd0;
            onda_saida <= 1'b0;
        end else if (contador >= cont_meio_periodo) begin
            contador   <= 32'd0;
            onda_saida <= ~onda_saida;
        end else begin
            contador <= contador + 1'b1;
        end
    end

endmodule