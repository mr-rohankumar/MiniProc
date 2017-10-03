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

// Name:   miniproc_tb.v
// Module: MINIPROC_TB
// Input: 
// Output: 
//
// Notes:  MiniProc test bench composed of control unit, register file, and ALU.
//

`include "definition.v"

module MINIPROC_TB;
	// inputs are reg type
	reg [`ALU_FUNCT_INDEX_LIMIT:0] CU_OPCODE, CU_FUNCT;
	reg [4:0] CU_SHAMT;
	reg [`REG_ADDR_INDEX_LIMIT:0] RF_ADDR_R1, RF_ADDR_R2, RF_ADDR_W;
	reg CU_RST, RF_RST;

	// outputs are wire type
	wire [`DATA_INDEX_LIMIT:0] ALU_RESULT;

	// internal connections are wire type
	wire [`DATA_INDEX_LIMIT:0] alu_op1, alu_op2;
	wire [`ALU_FUNCT_INDEX_LIMIT:0] alu_code;
	wire [`DATA_INDEX_LIMIT:0] rf_data_r1, rf_data_r2;
	wire SYS_CLK, rf_read, rf_write;

	// instantiate the clock generator
	CLK_GENERATOR cg_inst(.CLK(SYS_CLK));

	// instantiate the control unit
	CONTROL_UNIT cu_inst(.OPCODE(CU_OPCODE), .FUNCT(CU_FUNCT), .SHAMT(CU_SHAMT), .DATA_R1(rf_data_r1), .DATA_R2(rf_data_r2), .CLK(SYS_CLK), .RST(CU_RST),
						 .ALU_OP1(alu_op1), .ALU_OP2(alu_op2), .ALU_CODE(alu_code), .RF_READ(rf_read), .RF_WRITE(rf_write));

	// instantiate the register file
	REGISTER_FILE_32x32 rf_inst(.ADDR_R1(RF_ADDR_R1), .ADDR_R2(RF_ADDR_R2), .ADDR_W(RF_ADDR_W), .DATA_W(ALU_RESULT), .READ(rf_read), .WRITE(rf_write), 
								.CLK(SYS_CLK), .RST(RF_RST), .DATA_R1(rf_data_r1), .DATA_R2(rf_data_r2));

	// instantiate the ALU
	ALU alu_inst(.OP1(alu_op1), .OP2(alu_op2), .FUNCT(alu_code), .RESULT(ALU_RESULT));

	// global variables
	integer test = 0, pass = 0, status;

	initial begin
		// dump waveform
		$dumpfile("miniproc_dump.vcd");
		$dumpvars(0);

		// toggle CU_RST and RF_RST signals to initalize control unit and register file
		CU_RST = 1'b0;
		RF_RST = 1'b0; 
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;
		RF_RST = 1'b1;

		$display("---------------------------------------------------------------",);
		$display("|          if (EXPECTED === ACTUAL) pass; else fail.          |",);
		$display("---------------------------------------------------------------",);

		// REG[18] + REG[3] ==> 18 + 3, result written in REG[31] = 21
		CU_OPCODE = 0;
		RF_ADDR_W = 31;
		RF_ADDR_R1 = 18;
		RF_ADDR_R2 = 3;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h20;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[15] - REG[5] ==> 15 - 5, result written in REG[30] = 10
		CU_OPCODE = 0;
		RF_ADDR_W = 30;
		RF_ADDR_R1 = 15;
		RF_ADDR_R2 = 5;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h22;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[12] * REG[7] ==> 12 * 7, result written in REG[29] = 84
		CU_OPCODE = 0;
		RF_ADDR_W = 29;
		RF_ADDR_R1 = 12;
		RF_ADDR_R2 = 7;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h2c;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[9] << 2 ==> 9 << 2, result written in REG[28] = 36
		CU_OPCODE = 0;
		RF_ADDR_W = 28;
		RF_ADDR_R1 = 9;
		RF_ADDR_R2 = 0;
		CU_SHAMT = 2;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h01;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[29] >> 1 ==> 84 >> 1, result written in REG[27] = 42
		CU_OPCODE = 0;
		RF_ADDR_W = 27;
		RF_ADDR_R1 = 29;
		RF_ADDR_R2 = 0;
		CU_SHAMT = 1;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h02;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[31] & REG[6] ==> 21 & 6, result written in REG[26] = 4
		CU_OPCODE = 0;
		RF_ADDR_W = 26;
		RF_ADDR_R1 = 31;
		RF_ADDR_R2 = 6;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h24;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[30] | REG[4] ==> 10 | 4, result written in REG[25] = 14
		CU_OPCODE = 0;
		RF_ADDR_W = 25;
		RF_ADDR_R1 = 30;
		RF_ADDR_R2 = 4;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h25;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[28] ~| REG[27] ==> 36 ~| 42, result written in REG[24] = 4294967249
		CU_OPCODE = 0;
		RF_ADDR_W = 24;
		RF_ADDR_R1 = 28;
		RF_ADDR_R2 = 27;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h27;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[26] < REG[25] ==> 4 < 14, result written in REG[23] = 1
		CU_OPCODE = 0;
		RF_ADDR_W = 23;
		RF_ADDR_R1 = 26;
		RF_ADDR_R2 = 25;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h2a;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		// toggle CU_RST to reset control unit
		CU_RST = 1'b0;
		#`SYS_CLK_PERIOD;
		CU_RST = 1'b1;

		// REG[24] < REG[8] ==> 4294967249 < 8, result written in REG[22] = 0
		CU_OPCODE = 0;
		RF_ADDR_W = 22;
		RF_ADDR_R1 = 24;
		RF_ADDR_R2 = 8;
		CU_SHAMT = 0;
		CU_FUNCT = `ALU_FUNCT_WIDTH'h2a;
		#`CU_CLK_PERIOD; 
		status = test_result(alu_op1, alu_op2, alu_code, ALU_RESULT);
		test_counter(test, pass, status);

		$display("---------------------------------------------------------------",);
		$display("|                    [RESULT] %2d out of %2d.                   |", pass, test);
		$display("---------------------------------------------------------------",);

		$finish;
	end

	//-----------------------------------------------------------------------------
	// TASK: 	   test_counter
	// 
	// PARAMETERS: test, pass, status
	//
	// NOTES: 	   Keeps track of the number of test and pass cases.
	//-----------------------------------------------------------------------------
	task test_counter;
		// parameters
		inout test, pass, status;

		// local variables
		integer test, pass;

		begin
			test = test + 1;
			if (status) begin
				pass = pass + 1;
			end
		end
	endtask

	//-----------------------------------------------------------------------------
	// FUNCTION:   test_result
	// 
	// PARAMETERS: op1, op2, funct, actual
	// RETURN: 	   If (expected === actual) return 1; else return 0. 
	//
	// NOTES:      Tests the expected result against the actual result.
	//-----------------------------------------------------------------------------
	function test_result;
		// parameters
		input [`DATA_INDEX_LIMIT:0] op1, op2;
		input [`ALU_FUNCT_INDEX_LIMIT:0] funct;
		input [`DATA_INDEX_LIMIT:0] actual;

		// local variables
		reg [`DATA_INDEX_LIMIT:0] exp;
		reg [2*8:0] opr;

		begin
			case (funct)
				`ALU_FUNCT_WIDTH'h20 : begin opr = "+"; exp = op1 + op2; end     // add
				`ALU_FUNCT_WIDTH'h22 : begin opr = "-"; exp = op1 - op2; end     // subract
				`ALU_FUNCT_WIDTH'h2c : begin opr = "*"; exp = op1 * op2; end     // multiply
				`ALU_FUNCT_WIDTH'h01 : begin opr = "<<"; exp = op1 << op2; end   // shift left logical
				`ALU_FUNCT_WIDTH'h02 : begin opr = ">>"; exp = op1 >> op2; end   // shift right logical
				`ALU_FUNCT_WIDTH'h24 : begin opr = "&"; exp = op1 & op2; end     // and
				`ALU_FUNCT_WIDTH'h25 : begin opr = "|"; exp = op1 | op2; end     // or
				`ALU_FUNCT_WIDTH'h27 : begin opr = "~|"; exp = ~(op1 | op2); end // nor
				`ALU_FUNCT_WIDTH'h2a : begin opr = "<"; exp = op1 < op2; end     // less than
				default: begin opr = "?"; exp = `DATA_WIDTH'hx; end 			 // unknown
			endcase

			if (exp === actual) begin
				$write(" [PASS] ");
				test_result = 1'b1;
			end
			else begin
				$write(" [FAIL] ");
				test_result = 1'b0;
			end
			$display("%d %2s %-d    EXPECTED = %2d, ACTUAL = %2d", op1, opr, op2, exp, actual);
		end
	endfunction
endmodule