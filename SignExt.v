`timescale 1ns / 1ps

module SignExt #(parameter AWL = 16, WL = 32) (Imm2, SImm);

input signed [AWL-1:0] Imm2;
output signed [WL-1:0] SImm;

assign SImm = {{(WL-AWL){Imm2[AWL-1]}}, Imm2[AWL-1:0]};

endmodule
