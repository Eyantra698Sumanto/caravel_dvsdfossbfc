
// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,  // User area 1 3.3V supply
    inout vdda2,  // User area 2 3.3V supply
    inout vssa1,  // User area 1 analog ground
    inout vssa2,  // User area 2 analog ground
    inout vccd1,  // User area 1 1.8V supply
    inout vccd2,  // User area 2 1.8v supply
    inout vssd1,  // User area 1 digital ground
    inout vssd2,  // User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

assign io_oeb[15:0]=16'b1111_1111_1111_1111;
assign io_oeb[`MPRJ_IO_PADS-1:16]=0;
assign io_out=1;
assign la_data_out=1;
assign wbs_dat_o=1;
assign user_irq=1;
reg [15:0] counter;
  reg [15:0] bloomFilter;
always @(posedge user_clock2 or posedge io_in[0]) begin
    if (io_in[0]) begin
      counter <= 16'b0000_0000_0000_0000;
      bloomFilter <= 16'b0000_0000_0000_0000;
    end else if (io_in[9]) begin
      if (bloomFilter[io_in[8:1]]) begin
        // Bloom filter indicates that the input data is likely already counted
        counter <= counter;
      end else begin
        // Bloom filter indicates that the input data is likely not counted
        counter <= counter + 1;
        bloomFilter[io_in[8:1]] <= 1;
      end
    end
  end
  assign io_out[31:16]=counter;
endmodule   // user_project_wrapper
`default_nettype wire

