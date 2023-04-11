`timescale 1ns / 1ps

module ControlUnit(Opcode3, funct, MtoRFSel, DMWE2, Branch, ALUInSel, RFDSel, RFWE2, Jump, ALUsel2);

input [5:0] Opcode3, funct;
output reg MtoRFSel, DMWE2, Branch, ALUInSel, RFDSel, RFWE2, Jump; 
output reg [3:0] ALUsel2;
reg [1:0] ALUOp;

always @* begin
    case(Opcode3) 
        0: begin
            RFWE2 = 1; RFDSel = 1; ALUInSel = 0; Branch = 0; DMWE2 = 0; MtoRFSel = 0; ALUOp = 2; Jump = 0;
        end
        35: begin
            RFWE2 = 1; RFDSel = 0; ALUInSel = 1; Branch = 0; DMWE2 = 0; MtoRFSel = 1; ALUOp = 0; Jump = 0;
        end
        43: begin
            RFWE2 = 0; RFDSel = 1'bx; ALUInSel = 1; Branch = 0; DMWE2 = 1; MtoRFSel = 1'bx; ALUOp = 0; Jump = 0;
        end
        4: begin
            RFWE2 = 0; RFDSel = 1'bx; ALUInSel = 0; Branch = 1; DMWE2 = 0; MtoRFSel = 1'bx; ALUOp = 1; Jump = 0;
        end
        8: begin
            RFWE2 = 1; RFDSel = 0; ALUInSel = 1; Branch = 0; DMWE2 = 0; MtoRFSel = 0; ALUOp = 0; Jump = 0;
        end
        2: begin
            RFWE2 = 0; RFDSel = 1'bx; ALUInSel = 1'bx; Branch = 1'bx; DMWE2 = 0; MtoRFSel = 1'bx; ALUOp = 2'bxx; Jump = 1;
        end
        default: begin
            RFWE2 = 0; RFDSel = 0; ALUInSel = 0; Branch = 0; DMWE2 = 0; MtoRFSel = 0; ALUOp = 0; Jump = 0;
        end
    endcase
    
    case(ALUOp)
        0: ALUsel2 = 0;
        1: ALUsel2 = 1;
        2: begin
            case(funct)
                6'b000000: ALUsel2 = 2;
                6'b000100: ALUsel2 = 4;
                6'b000111: ALUsel2 = 6;
                6'b100000: ALUsel2 = 0;
                6'b100010: ALUsel2 = 1;
                6'b100100: ALUsel2 = 7;
                6'b100101: ALUsel2 = 8;
            endcase
        end
        default: ALUsel2 = 4'bxxxx;
    endcase
end

endmodule
