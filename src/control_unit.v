// MIT License
// 
// Copyright (c) 2017 Rohan Kumar
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 

// Name:   control_unit.v
// Module: CONTROL_UNIT
// Input:  OPCODE[6]   : Operation code
//		   FUNCT[6]    : Function code in MIPS instructions (R-Format)
//		   DATA_R1[32] : Data read from ADDR_R1 address of register file
//         DATA_R2[32] : Data read from ADDR_R2 address of register file
//		   SHAMT[5]    : Shift amount for shift instructions
//         CLK     	   : Clock signal
//         RST         : Reset signal
// Output: RF_READ     : READ signal for register file
//         RF_WRITE    : WRITE signal for register file
//		   ALU_OP1[32] : First operand for ALU  (DATA_R1)
//         ALU_OP2[32] : Second operand for ALU (DATA_R2 or SHAMT)
//		   ALU_CODE[6] : Function code for ALU  (FUNCT)
//
// Notes:  Control unit that synchronize operations of the processor.
//

`include "definition.v"

module CONTROL_UNIT(OPCODE, FUNCT, SHAMT, DATA_R1, DATA_R2, CLK, RST,
					ALU_OP1, ALU_OP2, ALU_CODE, RF_READ, RF_WRITE);
	// inputs
	input [`ALU_FUNCT_INDEX_LIMIT:0] OPCODE, FUNCT;
	input [4:0] SHAMT;
	input [`DATA_INDEX_LIMIT:0] DATA_R1, DATA_R2;
	input CLK, RST;

	// outputs
	output reg [`DATA_INDEX_LIMIT:0] ALU_OP1, ALU_OP2;
	output reg [`ALU_FUNCT_INDEX_LIMIT:0] ALU_CODE;
	output reg RF_READ, RF_WRITE;

	// global variables
	reg [1:0] state;

	initial begin
		state = `STATE_IDLE;
	end

	always @ (negedge RST or posedge CLK) begin
		// reset
		if (RST === 1'b0) begin
			state = `STATE_FETCH;
		end 
		else begin
			case (state)
				// fetch
				`STATE_FETCH: begin
					if (OPCODE !== `NOP) begin 
						state = `STATE_DECODE;
						RF_READ = 1'b1;
						RF_WRITE = 1'b0;
					end
				end
				// decode
				`STATE_DECODE: begin
					state = `STATE_EXECUTE;
					ALU_OP1 = DATA_R1;
					ALU_OP2 = ((FUNCT === `ALU_FUNCT_WIDTH'h01) || 
							   (FUNCT === `ALU_FUNCT_WIDTH'h02)) ? SHAMT : DATA_R2;
					ALU_CODE = FUNCT;	
				end
				// execute
				`STATE_EXECUTE:	begin
					state = `STATE_IDLE;
					RF_READ = 1'b0;
					RF_WRITE = 1'b1;
				end
				// idle
				default: ; // do nothing
			endcase
		end
	end
endmodule