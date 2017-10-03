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

// Name:   definition.v
// Module: 
// Input: 
// Output: 
//
// Notes:  Common definitions.
// 

`define DATA_WIDTH 32
`define DATA_INDEX_LIMIT (`DATA_WIDTH - 1)
`define ALU_FUNCT_WIDTH 6
`define ALU_FUNCT_INDEX_LIMIT (`ALU_FUNCT_WIDTH - 1)
`define NUM_OF_REG 32
`define REG_INDEX_LIMIT (`NUM_OF_REG - 1)
`define REG_ADDR_INDEX_LIMIT 4

`timescale 1ns / 10ps

`define SYS_CLK_PERIOD 10
`define SYS_CLK_HALF_PERIOD (`SYS_CLK_PERIOD / 2)
`define CU_CLK_PERIOD (`SYS_CLK_PERIOD * 3)

`define STATE_FETCH 0
`define STATE_DECODE 1
`define STATE_EXECUTE 2
`define STATE_IDLE 3

`define NOP 63