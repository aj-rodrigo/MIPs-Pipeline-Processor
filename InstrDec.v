`timescale 1ns / 1ps

module InstrDec #(parameter WL = 32) (Instr, OPcode, Func, RS, RT, RD, shamt, Imm, Jumpt);

input [WL-1:0] Instr;
output reg [5:0] OPcode, Func;
output reg [4:0] RS, RT, RD, shamt;
output reg [15:0] Imm;
output reg [25:0] Jumpt;

always @* begin  
    OPcode = Instr[31:26];
    Func = Instr[5:0];
    RS = Instr[25:21];
    RT = Instr[20:16];
    RD = Instr[15:11];
    shamt = Instr[10:6];
    Imm = Instr[15:0];
    Jumpt = Instr[25:0];
end

endmodule
