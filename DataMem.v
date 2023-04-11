`timescale 1ns / 1ps

module DataMem #(parameter AWL = 9, WL = 32, file = "DataMemVals.mem") (CLK, DMWE, DMA, DMWD, DMRD);

input CLK, DMWE;
input [WL-1:0] DMA;
input [WL-1:0] DMWD;
output [WL-1:0] DMRD;

reg [WL-1:0] DMem [0:2**AWL-1];

initial $readmemb(file, DMem);

always @(posedge CLK) begin
    if(DMWE) DMem[DMA] <= DMWD;
end

assign DMRD = DMem[DMA];

endmodule
