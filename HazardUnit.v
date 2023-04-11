`timescale 1ns / 1ps

module HazardUnit(BranchD, MtoRFSelE, MtoRFSelM, RFWEE, RFWEM, RFWEW, rsD, rtD, rsE, rtE, RFAE, RFAM, RFAW, StallF, StallD, ForwardAD, ForwardBD, Flush, ForwardAE, ForwardBE);

input BranchD, MtoRFSelE, MtoRFSelM, RFWEE, RFWEM, RFWEW;
input [4:0] rsD, rtD, rsE, rtE, RFAE, RFAM, RFAW;
output reg StallF, StallD, ForwardAD, ForwardBD, Flush;
output reg [1:0] ForwardAE, ForwardBE;

reg LWStall, BRStall;

always @* begin

    ForwardAD = (rsD!=0) && (rsD == RFAM) && RFWEM;
    ForwardBD = (rtD!=0) && (rtD == RFAM) && RFWEM;
    
    if((rsE!=0) && RFWEM && (rsE==RFAM)) ForwardAE = 2'b10;
    else if((rsE!=0) && RFWEW && (rsE==RFAW)) ForwardAE = 2'b01;
    else ForwardAE = 2'b00;
    
    if((rtE!=0) && RFWEM && (rtE==RFAM)) ForwardBE = 2'b10;
    else if((rtE!=0) && RFWEW && (rtE==RFAW)) ForwardBE = 2'b01;
    else ForwardBE = 2'b00;
    
    LWStall = MtoRFSelE && ((rtE==rsD)||(rtE==rtD));
    BRStall = ((rsD==RFAE || rtD==RFAE) && BranchD && RFWEE) || ((rsD==RFAM || rtD==RFAM) && BranchD && MtoRFSelM);
    
    StallF = LWStall || BRStall;
    StallD = StallF;
    Flush = StallD;
    
end

endmodule
