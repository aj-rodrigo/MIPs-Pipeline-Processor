`timescale 1ns / 1ps

module ALU #(parameter WL = 32) (ALUsel, ALUIn1, ALUIn2, shamt2, Zero, ALUOut);

input [3:0] ALUsel;
input signed [WL-1:0] ALUIn1, ALUIn2;
input [4:0] shamt2;
output reg Zero;
output reg signed [WL-1:0] ALUOut;

always @* begin
    case(ALUsel)
        0: ALUOut = ALUIn1 + ALUIn2;
        1: ALUOut = ALUIn1 - ALUIn2;
        2: ALUOut = ALUIn2 << shamt2;
        3: ALUOut = ALUIn2 >> shamt2;
        4: ALUOut = ALUIn2 << ALUIn1[4:0];
        5: ALUOut = ALUIn2 >> ALUIn1[4:0];
        6: ALUOut = ALUIn2 >>> ALUIn1[4:0];
        7: ALUOut = ALUIn1 & ALUIn2;
        8: ALUOut = ALUIn1 | ALUIn2;
        9: ALUOut = ALUIn1 ^ ALUIn2;
        10: ALUOut = ~(ALUIn1 ^ ALUIn2);
    endcase
    
    Zero = (ALUOut == 0);
end


endmodule
