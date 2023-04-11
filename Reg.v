`timescale 1ns / 1ps

module Reg #(parameter WL = 32) (CLK, EN, CLR, RST, RegIn, RegOut);

input CLK, EN, CLR, RST;
input [WL-1:0] RegIn;
output reg [WL-1:0] RegOut;

initial RegOut <= 0;

always @(posedge CLK) begin
    if(RST || CLR) RegOut <= 0;
    else if(EN) RegOut <= RegIn;
    else RegOut <= RegOut;
    
end

endmodule