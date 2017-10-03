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

// Name:   register_file.v
// Module: REGISTER_FILE_32x32
// Input:  ADDR_R1[5]  : Address of the memory location for DATA_R1
//         ADDR_R2[5]  : Address of the memory location for DATA_R2
//		   ADDR_W[5]   : Address of the memory location for DATA_W
//		   DATA_W[5]   : Data written to ADDR_W address
//         READ        : Read signal
//         WRITE       : Write signal
//         CLK         : Clock signal
//         RST         : Reset signal
// Output: DATA_R1[32] : Data read from ADDR_R1 address
//         DATA_R2[32] : Data read from ADDR_R2 address
//
// Notes:  - An array of 32 registers capable of storing 32-bit words with dual read functionality.
//         - Reset operation is done at -ve edge of the RST signal.
//         - Read and write operations are done at the +ve edge of the CLK signal.
//         - Read operation is done if READ=1 and WRITE=0.
//         - Write operation is done if READ=0 and WRITE=1.
//         - If both READ and WRITE are 0 or 1, then DATA_R* = x.
//

`include "definition.v"

module REGISTER_FILE_32x32(ADDR_R1, ADDR_R2, ADDR_W, DATA_W, READ, WRITE, 
						   CLK, RST, DATA_R1, DATA_R2);
	// inputs
	input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
	input [`DATA_INDEX_LIMIT:0] DATA_W;
	input READ, WRITE, CLK, RST;

	// outputs
	output reg [`DATA_INDEX_LIMIT:0] DATA_R1, DATA_R2;

	// global variables
	reg [`DATA_INDEX_LIMIT:0] reg32x32 [0:`REG_INDEX_LIMIT];
	integer i;

	always @ (negedge RST or posedge CLK) begin
		// reset
		if (RST === 1'b0) begin
			for (i = 0; i < `NUM_OF_REG; i = i + 1) begin
				reg32x32[i] = i; // for testing purposes
			end
		end
		else begin 
			// write
			if ((READ === 1'b0) && (WRITE === 1'b1)) begin
				reg32x32[ADDR_W] = DATA_W;
			end
			// read
			else if ((READ === 1'b1) && (WRITE === 1'b0)) begin
				DATA_R1 = reg32x32[ADDR_R1];
				DATA_R2 = reg32x32[ADDR_R2];
			end
			// unknown
			else begin 
				DATA_R1 = { `DATA_WIDTH{1'bx} };
				DATA_R2 = { `DATA_WIDTH{1'bx} };
			end
		end
	end
endmodule