`timescale 1ns / 1ps

module Adder #(parameter WL = 32) (Addin1, Addin2, Addout);

input signed [WL-1:0] Addin1, Addin2;
output signed [WL-1:0] Addout;

assign Addout = Addin1 + Addin2;

endmodule
