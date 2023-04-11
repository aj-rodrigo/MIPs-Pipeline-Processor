`timescale 1ns / 1ps

module Top(CLK, RST);

input CLK, RST;

wire [31:0] PCp1F, PCp1D, PCBranchD, PC, PC2, PCF, PCFout, InstrD, SImmD, SImmE;
wire [31:0] RFRD1out, RFRD2out, MUXRFRD1out, MUXRFRD2out;
wire [31:0] RFRD1outE, RFRD2outE, DMOutM, DMOutW;
wire [31:0] ALUIn1E, ALUIn2E, DMdinE, DMdinM, ALUOutE, ALUOutM, ALUOutW, ResultW;
wire [25:0] JumptD;
wire [15:0] ImmD;
wire [5:0] OPcodeD, FuncD;
wire [4:0] rsD, rtD, rdD, shamtD, shamtE;
wire [4:0] rsE, rtE, rdE;
wire [4:0] RFAE, RFAM, RFAW;
wire [3:0] ALUSelD, ALUSelE;
wire Jump2;

wire RFWED, MtoRFSelD, DMWED, BranchD, ALUInSelD, RFDSelD;
wire RFWEE, MtoRFSelE, DMWEE, ALUInSelE, RFDSelE;
wire RFWEM, MtoRFSelM, DMWEM;
wire RFWEW, MtoRFSelW;

wire StallF, StallD, ForwardAD, ForwardBD, Flush;
wire [1:0] ForwardAE, ForwardBE;


//FETCH
MUX #(.WL(32)) MXPC (.SEL((MUXRFRD1out == MUXRFRD2out) & BranchD), .Din0(PCp1F), .Din1(PCBranchD), .Dout(PC));
MUX #(.WL(32)) MXJUMP (.SEL(Jump2), .Din0(PC), .Din1({PCF[31:26], JumptD}), .Dout(PC2));
Reg #(.WL(32)) PC00 (.CLK(CLK), .EN(~StallF), .CLR(0), .RST(RST), .RegIn(PC2), .RegOut(PCF));                                      
Adder #(.WL(32)) ADD0 (.Addin1(PCF), .Addin2(1), .Addout(PCp1F));
InstrMem #(.AWL(8), .WL(32)) IM0 (.IMA(PCF), .IMRD(PCFout));
Reg #(.WL(32)) REGPLF1 (.CLK(CLK), .EN(~StallD), .CLR((MUXRFRD1out == MUXRFRD2out) & BranchD), .RST(RST), .RegIn(PCFout), .RegOut(InstrD));
Reg #(.WL(32)) REGPLF2 (.CLK(CLK), .EN(~StallD), .CLR((MUXRFRD1out == MUXRFRD2out) & BranchD), .RST(RST), .RegIn(PCp1F), .RegOut(PCp1D));


//DECODE
InstrDec #(.WL(32)) ID0 (.Instr(InstrD), .OPcode(OPcodeD), .Func(FuncD), .RS(rsD), .RT(rtD), .RD(rdD), .shamt(shamtD), .Imm(ImmD), .Jumpt(JumptD));
RegFile #(.AWL(5), .WL(32)) RF0 (.CLK(!CLK), .RFWE(RFWEW), .RFR1(rsD), .RFR2(rtD), .RFWA(RFAW), .RFWD(ResultW), .RFRD1(RFRD1out), .RFRD2(RFRD2out));
MUX #(.WL(32)) MXRFRD1 (.SEL(ForwardAD), .Din0(RFRD1out), .Din1(ALUOutM), .Dout(MUXRFRD1out));
MUX #(.WL(32)) MXRFRD2 (.SEL(ForwardBD), .Din0(RFRD2out), .Din1(ALUOutM), .Dout(MUXRFRD2out));
ControlUnit CU0(.Opcode3(OPcodeD), .funct(FuncD), .MtoRFSel(MtoRFSelD), .DMWE2(DMWED), .Branch(BranchD), .ALUInSel(ALUInSelD), .RFDSel(RFDSelD), .RFWE2(RFWED), .Jump(Jump2), .ALUsel2(ALUSelD));
SignExt #(.AWL(16), .WL(32)) SE0 (.Imm2(ImmD), .SImm(SImmD));
Adder #(.WL(32)) ADD1 (.Addin1(SImmD), .Addin2(PCp1D), .Addout(PCBranchD));

Reg #(.WL(1)) REGPLD1 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(RFWED), .RegOut(RFWEE));
Reg #(.WL(1)) REGPLD2 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(MtoRFSelD), .RegOut(MtoRFSelE));
Reg #(.WL(1)) REGPLD3 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(DMWED), .RegOut(DMWEE));
Reg #(.WL(1)) REGPLD4 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(ALUInSelD), .RegOut(ALUInSelE));
Reg #(.WL(1)) REGPLD5 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(RFDSelD), .RegOut(RFDSelE));
Reg #(.WL(4)) REGPLD6 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(ALUSelD), .RegOut(ALUSelE));

Reg #(.WL(32)) REGPLD7 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(RFRD1out), .RegOut(RFRD1outE));
Reg #(.WL(32)) REGPLD8 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(RFRD2out), .RegOut(RFRD2outE));

Reg #(.WL(5)) REGPLD9 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(rsD), .RegOut(rsE));
Reg #(.WL(5)) REGPLD10 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(rtD), .RegOut(rtE));
Reg #(.WL(5)) REGPLD11 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(rdD), .RegOut(rdE));
Reg #(.WL(32)) REGPLD12 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(SImmD), .RegOut(SImmE));
Reg #(.WL(5)) REGPLD13 (.CLK(CLK), .EN(1), .CLR(Flush), .RST(RST), .RegIn(shamtD), .RegOut(shamtE));


//EXECUTE
MUX #(.WL(32)) MXRTRD (.SEL(RFDSelE), .Din0(rtE), .Din1(rdE), .Dout(RFAE));
ThreeWayMUX #(.WL(32)) TWM1 (.SEL(ForwardAE), .Din0(RFRD1outE), .Din1(ResultW), .Din2(ALUOutM), .Din3(0), .Dout(ALUIn1E));
ThreeWayMUX #(.WL(32)) TWM2 (.SEL(ForwardBE), .Din0(RFRD2outE), .Din1(ResultW), .Din2(ALUOutM), .Din3(0), .Dout(DMdinE));
MUX #(.WL(32)) MXALUIN2 (.SEL(ALUInSelE), .Din0(DMdinE), .Din1(SImmE), .Dout(ALUIn2E));
ALU #(.WL(32)) A00 (.ALUsel(ALUSelE), .ALUIn1(ALUIn1E), .ALUIn2(ALUIn2E), .shamt2(shamtE), .ALUOut(ALUOutE));               
                                                                                                                               
Reg #(.WL(1)) REGPLE1 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(RFWEE), .RegOut(RFWEM));
Reg #(.WL(1)) REGPLE2 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(MtoRFSelE), .RegOut(MtoRFSelM));
Reg #(.WL(1)) REGPLE3 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(DMWEE), .RegOut(DMWEM));

Reg #(.WL(32)) REGPLE4 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(ALUOutE), .RegOut(ALUOutM));
Reg #(.WL(32)) REGPLE5 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(DMdinE), .RegOut(DMdinM));
Reg #(.WL(5)) REGPLE6 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(RFAE), .RegOut(RFAM));


//MEMORY
DataMem #(.AWL(9), .WL(32)) DM0(.CLK(CLK), .DMWE(DMWEM), .DMA(ALUOutM), .DMWD(DMdinM), .DMRD(DMOutM));

Reg #(.WL(1)) REGPLM1 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(RFWEM), .RegOut(RFWEW));
Reg #(.WL(1)) REGPLM2 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(MtoRFSelM), .RegOut(MtoRFSelW));

Reg #(.WL(32)) REGPLM3 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(DMOutM), .RegOut(DMOutW));
Reg #(.WL(32)) REGPLM4 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(ALUOutM), .RegOut(ALUOutW));
Reg #(.WL(5)) REGPLM5 (.CLK(CLK), .EN(1), .RST(RST), .RegIn(RFAM), .RegOut(RFAW));



//WRITEBACK
MUX #(.WL(32)) MXWB (.SEL(MtoRFSelW), .Din0(ALUOutW), .Din1(DMOutW), .Dout(ResultW));


//HAZARD UNIT
HazardUnit HU1 (.BranchD(BranchD), .MtoRFSelE(MtoRFSelE), .MtoRFSelM(MtoRFSelM), .RFWEE(RFWEE), .RFWEM(RFWEM), .RFWEW(RFWEW), .rsD(rsD), .rtD(rtD), .rsE(rsE), .rtE(rtE), .RFAE(RFAE), .RFAM(RFAM), .RFAW(RFAW), .StallF(StallF), .StallD(StallD), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD), .Flush(Flush), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE));

endmodule