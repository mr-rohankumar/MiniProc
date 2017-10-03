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

// Name:   alu.v
// Module: ALU
// Input:  OP1[32]    : First operand
//         OP2[32]    : Second operand
//         FUNCT[6]   : Function code
// Output: RESULT[32] : Result
//
// Notes:  32bit combinatorial ALU; Supports MiniMIPS instruction set.
//

`include "definition.v"

module ALU(OP1, OP2, FUNCT, RESULT);
	// inputs
	input [`DATA_INDEX_LIMIT:0] OP1, OP2;
	input [`ALU_FUNCT_INDEX_LIMIT:0] FUNCT;

	// outputs
	output reg [`DATA_INDEX_LIMIT:0] RESULT;

	always @ (OP1 or OP2 or FUNCT) begin
		case (FUNCT)
			`ALU_FUNCT_WIDTH'h20 : RESULT = OP1 + OP2;    // add
			`ALU_FUNCT_WIDTH'h22 : RESULT = OP1 - OP2;    // subtract
			`ALU_FUNCT_WIDTH'h2c : RESULT = OP1 * OP2;    // multiply
			`ALU_FUNCT_WIDTH'h01 : RESULT = OP1 << OP2;   // shift left logical
			`ALU_FUNCT_WIDTH'h02 : RESULT = OP1 >> OP2;   // shift right logical
			`ALU_FUNCT_WIDTH'h24 : RESULT = OP1 & OP2;    // and
			`ALU_FUNCT_WIDTH'h25 : RESULT = OP1 | OP2;    // or
			`ALU_FUNCT_WIDTH'h27 : RESULT = ~(OP1 | OP2); // nor
			`ALU_FUNCT_WIDTH'h2a : RESULT = OP1 < OP2;	  // less than
			default: RESULT = `DATA_WIDTH'hx;			  // unknown            
		endcase
	end
endmodule