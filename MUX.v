`timescale 1ns / 1ps

module MUX #(parameter WL = 32) (SEL, Din0, Din1, Dout);

input SEL;
input [WL-1:0] Din0, Din1;
output [WL-1:0] Dout;

assign Dout = SEL ? Din1 : Din0;

endmodule
