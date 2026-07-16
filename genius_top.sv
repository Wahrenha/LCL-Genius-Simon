module genius_top #(
    parameter integer FREQ_CLOCK_HZ      = 50_000_000,
    parameter integer TEMPO_MOSTRA_MS    = 500,
    parameter integer TEMPO_INTERVALO_MS = 200,
    parameter integer TEMPO_RESPOSTA_MS  = 300,
    parameter integer TEMPO_BIPE_MS      = 150,
    parameter integer TEMPO_LIMITE_S     = 5,
    parameter integer TEMPO_PISCA_MS     = 200,
    parameter integer NUM_PISCADAS       = 6
)(
    input  logic        CLOCK_50,
    input  logic [17:0] SW,
    input  logic [3:0]  KEY,          

    output logic [17:0] LEDR,
    output logic [8:0]  LEDG,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3,
    output logic [6:0]  HEX4, HEX5, HEX6, HEX7,

    output logic [4:0]  GPIO_1
);

    logic ligado, inicio_jogo, pulso_reset;

    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_power (
        .clk(CLOCK_50), .entrada(SW[17]),
        .saida(ligado), .d_pulso()
    );
    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_reset (
        .clk(CLOCK_50), .entrada(SW[16]),
        .saida(), .d_pulso(pulso_reset)
    );
    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_start (
        .clk(CLOCK_50), .entrada(SW[15]),
        .saida(inicio_jogo), .d_pulso()
    );

    logic [3:0] pulso_botao;

    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_verde (
        .clk(CLOCK_50), .entrada(~KEY[3]),
        .saida(), .d_pulso(pulso_botao[3])
    );
    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_vermelho (
        .clk(CLOCK_50), .entrada(~KEY[2]),
        .saida(), .d_pulso(pulso_botao[2])
    );
    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_azul (
        .clk(CLOCK_50), .entrada(~KEY[1]),
        .saida(), .d_pulso(pulso_botao[1])
    );
    debounce #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_db_amarelo (
        .clk(CLOCK_50), .entrada(~KEY[0]),
        .saida(), .d_pulso(pulso_botao[0])
    );

    logic [7:0] valor_lfsr;
    randomizer u_lfsr (.clk(CLOCK_50), .valor(valor_lfsr));

    logic [3:0] cor_led;
    logic       toca_som, som_derrota;
    logic       pontuacao_soma10, pontuacao_zera_fsm;
    logic       leds_derrota_acesos, pulso_derrota;

    genius_fsm #(
        .FREQ_CLOCK_HZ      (FREQ_CLOCK_HZ),
        .TEMPO_MOSTRA_MS    (TEMPO_MOSTRA_MS),
        .TEMPO_INTERVALO_MS (TEMPO_INTERVALO_MS),
        .TEMPO_RESPOSTA_MS  (TEMPO_RESPOSTA_MS),
        .TEMPO_BIPE_MS      (TEMPO_BIPE_MS),
        .TEMPO_LIMITE_S     (TEMPO_LIMITE_S),
        .TEMPO_PISCA_MS     (TEMPO_PISCA_MS),
        .NUM_PISCADAS       (NUM_PISCADAS)
    ) u_fsm (
        .clk                 (CLOCK_50),
        .ligado              (ligado),
        .pulso_reset         (pulso_reset),
        .inicio_jogo         (inicio_jogo),
        .pulso_botao         (pulso_botao),
        .bits_aleatorios     (valor_lfsr[1:0]),
        .cor_led             (cor_led),
        .toca_som            (toca_som),
        .som_derrota         (som_derrota),
        .pontuacao_soma10    (pontuacao_soma10),
        .pontuacao_zera      (pontuacao_zera_fsm),
        .leds_derrota_acesos (leds_derrota_acesos),
        .pulso_derrota       (pulso_derrota)
    );

    generate
        genvar i;
        for (i = 0; i < 4; i++) begin : g_leds
            assign GPIO_1[i] = ligado ? (cor_led[i] | leds_derrota_acesos) : 1'b0;
        end
    endgenerate

    assign LEDG = {9{ligado & leds_derrota_acesos}};
    assign LEDR = {18{ligado & leds_derrota_acesos}};

    logic [19:0] frequencia_som;
    assign frequencia_som = som_derrota ? 20'd220 : 20'd880;

    beep #(.FREQ_CLOCK_HZ(FREQ_CLOCK_HZ)) u_buzzer (
        .clk           (CLOCK_50),
        .enable        (toca_som & ligado),
        .frequencia_hz (frequencia_som),
        .onda_saida    (GPIO_1[4])
    );

    logic pontuacao_zera_top;
    assign pontuacao_zera_top = !ligado | pulso_reset | pontuacao_zera_fsm;

    logic [3:0] atual_d0, atual_d1, atual_d2, atual_d3;
    pontuacao u_score_cur (
        .clk(CLOCK_50), .clear(pontuacao_zera_top), .soma10(pontuacao_soma10),
        .digito0(atual_d0), .digito1(atual_d1), .digito2(atual_d2), .digito3(atual_d3)
    );

    logic [3:0] max_d0, max_d1, max_d2, max_d3;

    function automatic logic bcd_maior(
        input logic [3:0] a3, a2, a1, a0,
        input logic [3:0] b3, b2, b1, b0
    );
        if (a3 != b3) return (a3 > b3);
        if (a2 != b2) return (a2 > b2);
        if (a1 != b1) return (a1 > b1);
        return (a0 > b0);
    endfunction

    logic atualiza_max;
    assign atualiza_max = pulso_derrota &
                          bcd_maior(atual_d3, atual_d2, atual_d1, atual_d0,
                                    max_d3, max_d2, max_d1, max_d0);

    recorde u_score_max (
        .clk(CLOCK_50), .ligado(ligado), .atualiza(atualiza_max),
        .novo_digito0(atual_d0), .novo_digito1(atual_d1),
        .novo_digito2(atual_d2), .novo_digito3(atual_d3),
        .digito0(max_d0), .digito1(max_d1), .digito2(max_d2), .digito3(max_d3)
    );

    localparam logic [6:0] SEG_DESLIGADO = 7'b1111111;

    logic [6:0] sm3, sm2, sm1, sm0, sc3, sc2, sc1, sc0;

    decoder7 d_m3(.bcd(max_d3), .seg(sm3));
    decoder7 d_m2(.bcd(max_d2), .seg(sm2));
    decoder7 d_m1(.bcd(max_d1), .seg(sm1));
    decoder7 d_m0(.bcd(max_d0), .seg(sm0));
    decoder7 d_c3(.bcd(atual_d3), .seg(sc3));
    decoder7 d_c2(.bcd(atual_d2), .seg(sc2));
    decoder7 d_c1(.bcd(atual_d1), .seg(sc1));
    decoder7 d_c0(.bcd(atual_d0), .seg(sc0));

    assign HEX7 = ligado ? sm3 : SEG_DESLIGADO;
    assign HEX6 = ligado ? sm2 : SEG_DESLIGADO;
    assign HEX5 = ligado ? sm1 : SEG_DESLIGADO;
    assign HEX4 = ligado ? sm0 : SEG_DESLIGADO;
    assign HEX3 = ligado ? sc3 : SEG_DESLIGADO;
    assign HEX2 = ligado ? sc2 : SEG_DESLIGADO;
    assign HEX1 = ligado ? sc1 : SEG_DESLIGADO;
    assign HEX0 = ligado ? sc0 : SEG_DESLIGADO;

endmodule