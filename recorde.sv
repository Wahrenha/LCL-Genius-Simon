module recorde (
    input  logic clk,
    input  logic ligado,
    input  logic atualiza,
    input  logic [3:0] novo_digito0, novo_digito1, novo_digito2, novo_digito3,
    output logic [3:0] digito0, digito1, digito2, digito3
);
    always_ff @(posedge clk) begin
        if (!ligado) begin
            digito0 <= 4'd0; digito1 <= 4'd0;
            digito2 <= 4'd0; digito3 <= 4'd0;
        end else if (atualiza) begin
            digito0 <= novo_digito0; digito1 <= novo_digito1;
            digito2 <= novo_digito2; digito3 <= novo_digito3;
        end
    end
endmodule