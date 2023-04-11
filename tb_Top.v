`timescale 1ns / 1ps

module tb_Top();

reg CLK, RST;

Top DUT (.CLK(CLK), .RST(RST));

initial CLK = 0;
initial RST = 1;
always #10 CLK = ~CLK;

initial begin
    #15 RST = 0;
    #500;
    #10 $finish;
end

endmodule

