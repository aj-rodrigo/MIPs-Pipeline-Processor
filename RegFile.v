`timescale 1ns / 1ps

module RegFile #(parameter AWL = 5, WL = 32, file = "RegFileVals.mem") (CLK, RFWE, RFR1, RFR2, RFWA, RFWD, RFRD1, RFRD2);

input CLK, RFWE;
input [AWL-1:0] RFR1, RFR2, RFWA;
input [WL-1:0] RFWD;
output [WL-1:0] RFRD1, RFRD2;

reg [WL-1:0] RAM [0:2**AWL-1];

initial $readmemb(file, RAM);

always @(posedge CLK) begin
    if(RFWE) RAM[RFWA] <= RFWD;
end

assign RFRD1 = RAM[RFR1];
assign RFRD2 = RAM[RFR2];

endmodule
