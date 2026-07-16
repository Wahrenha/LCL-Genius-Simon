module pontuacao (
    input  logic clk,
    input  logic clear,
    input  logic soma10,
    output logic [3:0] digito0,
    output logic [3:0] digito1,
    output logic [3:0] digito2,
    output logic [3:0] digito3
);
    always_ff @(posedge clk) begin
        if (clear) begin
            digito0 <= 4'd0; digito1 <= 4'd0;
            digito2 <= 4'd0; digito3 <= 4'd0;
        end else if (soma10) begin
            if (digito1 == 4'd9) begin
                digito1 <= 4'd0;
                if (digito2 == 4'd9) begin
                    digito2 <= 4'd0;
                    digito3 <= (digito3 == 4'd9) ? 4'd9 : digito3 + 4'd1;
                end else
                    digito2 <= digito2 + 4'd1;
            end else
                digito1 <= digito1 + 4'd1;
        end
    end
endmodule