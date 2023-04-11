`timescale 1ns / 1ps

module InstrMem #(parameter AWL = 8, WL = 32, file = "InstrMemValues.mem") (IMA, IMRD); 

input [WL-1:0] IMA;
output reg [WL-1:0] IMRD;

reg [WL-1:0] IMem [0:2**AWL-1];

initial $readmemb(file, IMem);

always @* begin
    IMRD = IMem[IMA];
end

endmodule
