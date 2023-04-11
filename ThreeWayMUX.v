`timescale 1ns / 1ps

module ThreeWayMUX #(parameter WL = 32) (SEL, Din0, Din1, Din2, Din3, Dout);

input [1:0] SEL;
input [WL-1:0] Din0, Din1, Din2, Din3;
output [WL-1:0] Dout;

assign Dout = SEL[1] ? (SEL[0] ? Din3 : Din2) : (SEL[0] ? Din1 : Din0);

endmodule
