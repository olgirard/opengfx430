//----------------------------------------------------------------------------
// Copyright (C) 2018 Authors
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
// License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
//----------------------------------------------------------------------------
//
// *File Name: tb_openGFX430.v
//
// *Module Description:
//                      openGFX430 testbench
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 205 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2015-07-15 22:59:52 +0200 (Wed, 15 Jul 2015) $
//----------------------------------------------------------------------------
`include "timescale.v"
`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_defines.v"
`endif

module  tb_openGFX430;

//
// Wire & Register definition
//------------------------------

`define  CLK_PERIOD  50   // 20 MHz


// LT24 Interface
wire        [15:0] lt24_din;
wire               lt24_cs_n;
wire               lt24_rd_n;
wire               lt24_wr_n;
wire               lt24_rs;
wire        [15:0] lt24_dout;
wire               lt24_d_en;
wire               lt24_reset_n;
wire               lt24_on;

// Generic screen interface
wire               screen_refresh_active;
wire               screen_refresh_data_request;
wire               screen_refresh_data_ready;
wire        [15:0] screen_refresh_data;
wire [`LPIX_MSB:0] screen_display_width;
wire [`LPIX_MSB:0] screen_display_height;
wire [`SPIX_MSB:0] screen_display_size;

// Video Memory interface
wire [`VRAM_MSB:0] vid_ram_addr;
wire               vid_ram_wen;
wire               vid_ram_cen;
wire        [15:0] vid_ram_din;
wire        [15:0] vid_ram_dout;

// LUT Memory interface
`ifdef WITH_PROGRAMMABLE_LUT
wire [`LRAM_MSB:0] lut_ram_addr;
wire               lut_ram_wen;
wire               lut_ram_cen;
wire        [15:0] lut_ram_din;
wire        [15:0] lut_ram_dout;
`endif

// Peripherals interface
reg         [15:0] per_addr;
reg         [15:0] per_din;
reg          [1:0] per_we;
reg                per_en;
wire        [15:0] per_dout_lt24;
wire        [15:0] per_dout_gfx;
wire        [15:0] per_dout;

// Clock / Reset
reg                mclk;
reg                puc_rst;

// Others
wire               dbg_freeze;
wire               irq_gfx;

// Testbench variables
integer            tb_idx;
reg     [8*32-1:0] tb_string;
integer            error;
reg                stimulus_done;


//
// Include files
//------------------------------

// Peripheral interface tasks
`include "peripheral_tasks.v"

// Registers & Fields definitions
`include "register_def_openGFX430.v"
`include "register_def_if_lt24.v"

// Verilog stimulus
`include "stimulus.v"


//
// Initialize Memories
//------------------------------
initial
  begin
     for (tb_idx=0; tb_idx < (1<<`VRAM_MSB); tb_idx=tb_idx+1)
       vid_ram_0.mem[tb_idx] = 16'h0000;

     for (tb_idx=0; tb_idx < (1<<`LRAM_MSB); tb_idx=tb_idx+1)
       lut_ram_0.mem[tb_idx] = 16'h0000;
  end


//
// Generate Clock & Reset
//------------------------------
initial
  begin
     mclk          = 1'b0;
     forever
       begin
          #(`CLK_PERIOD/2);
          mclk     = ~mclk;
       end
  end

initial
  begin
     puc_rst       = 1'b0;
     #93;
     puc_rst       = 1'b1;
     #593;
     puc_rst       = 1'b0;
  end

initial
  begin
     error         = 0;
     stimulus_done = 0;
     tb_string     = "";

     per_addr      = 14'h0000;
     per_din       = 16'h0000;
     per_we        =  2'h0;
     per_en        =  1'h0;
  end


//
// Video Memory
//----------------------------------

ram #(`VRAM_MSB, (1<<(`VRAM_AWIDTH+1))) vid_ram_0 (

// OUTPUTs
    .ram_dout                      ( vid_ram_dout                ),  // Video Memory data output

// INPUTs
    .ram_addr                      ( vid_ram_addr                ),  // Video Memory address
    .ram_cen                       ( vid_ram_cen                 ),  // Video Memory chip enable (low active)
    .ram_clk                       ( mclk                        ),  // Video Memory clock
    .ram_din                       ( vid_ram_din                 ),  // Video Memory data input
    .ram_wen                       ( {2{vid_ram_wen}}            )   // Video Memory write enable (low active)
);


//
// LUT Memory
//----------------------------------
`ifdef WITH_PROGRAMMABLE_LUT

ram #(`LRAM_MSB, (1<<(`LRAM_AWIDTH+1))) lut_ram_0 (

// OUTPUTs
    .ram_dout                      ( lut_ram_dout                ),  // LUT Memory data output

// INPUTs
    .ram_addr                      ( lut_ram_addr                ),  // LUT Memory address
    .ram_cen                       ( lut_ram_cen                 ),  // LUT Memory chip enable (low active)
    .ram_clk                       ( mclk                        ),  // LUT Memory clock
    .ram_din                       ( lut_ram_din                 ),  // LUT Memory data input
    .ram_wen                       ( {2{lut_ram_wen}}            )   // LUT Memory write enable (low active)
);

`endif


//
// LT24 Model
//----------------------------------

lt24Model lt24Model_inst (

// OUTPUTs
    .lt24_d_o                      ( lt24_din                    ),  // LT24 Data input

// INPUTs
    .lt24_cs_n_i                   ( lt24_cs_n                   ),  // LT24 Chip select (Active low)
    .lt24_rd_n_i                   ( lt24_rd_n                   ),  // LT24 Read strobe (Active low)
    .lt24_wr_n_i                   ( lt24_wr_n                   ),  // LT24 Write strobe (Active low)
    .lt24_rs_i                     ( lt24_rs                     ),  // LT24 Command/Param selection (Cmd=0/Param=1)
    .lt24_d_i                      ( lt24_dout                   ),  // LT24 Data output
    .lt24_d_en_i                   ( lt24_d_en                   ),  // LT24 Data output enable
    .lt24_reset_n_i                ( lt24_reset_n                ),  // LT24 Reset (Active Low)
    .lt24_on_i                     ( lt24_on                     )   // LT24 on/off
);


//
// LT24 Interface
//----------------------------------

ogfx_if_lt24 dut_if_lt24 (

// Clock & Reset
    .mclk                          ( mclk                        ),  // Main system clock
    .puc_rst                       ( puc_rst                     ),  // Main system reset

// Peripheral Interface
    .per_addr_i                    ( per_addr[13:0]              ),  // Peripheral address
    .per_en_i                      ( per_en                      ),  // Peripheral enable (high active)
    .per_we_i                      ( per_we                      ),  // Peripheral write enable (high active)
    .per_din_i                     ( per_din                     ),  // Peripheral data input
    .per_dout_o                    ( per_dout_lt24               ),  // Peripheral data output

    .irq_lt24_o                    ( irq_lt24                    ),  // LT24 interface interrupt

// LT24 Interface
    .lt24_d_i                      ( lt24_din                    ),  // LT24 Data input
    .lt24_cs_n_o                   ( lt24_cs_n                   ),  // LT24 Chip select (Active low)
    .lt24_rd_n_o                   ( lt24_rd_n                   ),  // LT24 Read strobe (Active low)
    .lt24_wr_n_o                   ( lt24_wr_n                   ),  // LT24 Write strobe (Active low)
    .lt24_rs_o                     ( lt24_rs                     ),  // LT24 Command/Param selection (Cmd=0/Param=1)
    .lt24_d_o                      ( lt24_dout                   ),  // LT24 Data output
    .lt24_d_en_o                   ( lt24_d_en                   ),  // LT24 Data output enable
    .lt24_reset_n_o                ( lt24_reset_n                ),  // LT24 Reset (Active Low)
    .lt24_on_o                     ( lt24_on                     ),  // LT24 on/off

// openGFX430 Interface
    .screen_display_size_i         ( screen_display_size         ),  // Display size configuration (number of pixels)
    .screen_refresh_data_i         ( screen_refresh_data         ),  // Display refresh data
    .screen_refresh_data_ready_i   ( screen_refresh_data_ready   ),  // Display refresh new data is ready
    .screen_refresh_data_request_o ( screen_refresh_data_request ),  // Display refresh new data request
    .screen_refresh_active_o       ( screen_refresh_active       )   // Display refresh on going
);


//
// openGFX430 Instance
//----------------------------------

openGFX430 dut (

// Clock & Reset
    .mclk                          ( mclk                        ),  // Main system clock
    .puc_rst                       ( puc_rst                     ),  // Main system reset

// Peripheral Interface
    .per_addr_i                    ( per_addr[13:0]              ),  // Peripheral address
    .per_en_i                      ( per_en                      ),  // Peripheral enable (high active)
    .per_we_i                      ( per_we                      ),  // Peripheral write enable (high active)
    .per_din_i                     ( per_din                     ),  // Peripheral data input
    .per_dout_o                    ( per_dout_gfx                ),  // Peripheral data output

    .dbg_freeze_i                  ( dbg_freeze                  ),  // Freeze address auto-incr on read
    .irq_gfx_o                     ( irq_gfx                     ),  // Graphic Controller interrupt

// LUT SRAM Interface
`ifdef WITH_PROGRAMMABLE_LUT
    .lut_ram_dout_i                ( lut_ram_dout                ),  // LUT-RAM data output
    .lut_ram_addr_o                ( lut_ram_addr                ),  // LUT-RAM address
    .lut_ram_wen_o                 ( lut_ram_wen                 ),  // LUT-RAM write enable (active low)
    .lut_ram_cen_o                 ( lut_ram_cen                 ),  // LUT-RAM enable (active low)
    .lut_ram_din_o                 ( lut_ram_din                 ),  // LUT-RAM data input
`endif

// VIDEO SRAM Interface
    .vid_ram_dout_i                ( vid_ram_dout                ),  // Video-RAM data output
    .vid_ram_addr_o                ( vid_ram_addr                ),  // Video-RAM address
    .vid_ram_wen_o                 ( vid_ram_wen                 ),  // Video-RAM write enable (active low)
    .vid_ram_cen_o                 ( vid_ram_cen                 ),  // Video-RAM enable (active low)
    .vid_ram_din_o                 ( vid_ram_din                 ),  // Video-RAM data input

// Generic Screen Interface
    .screen_refresh_active_i       ( screen_refresh_active       ),  // Display refresh on going
    .screen_refresh_data_request_i ( screen_refresh_data_request ),  // Display refresh new data request
    .screen_refresh_data_ready_o   ( screen_refresh_data_ready   ),  // Display refresh new data is ready
    .screen_refresh_data_o         ( screen_refresh_data         ),  // Display refresh data
    .screen_display_width_o        ( screen_display_width        ),  // Display width configuration (number of pixels)
    .screen_display_height_o       ( screen_display_height       ),  // Display height configuration (number of pixels)
    .screen_display_size_o         ( screen_display_size         )   // Display size configuration (number of pixels)
);

assign  per_dout = per_dout_lt24 | per_dout_gfx;


//
// Generate Waveform
//----------------------------------------
initial
  begin
   `ifdef NODUMP
   `else
     `ifdef VPD_FILE
        $vcdplusfile("tb_openGFX430.vpd");
        $vcdpluson();
     `else
       `ifdef TRN_FILE
          $recordfile ("tb_openGFX430.trn");
          $recordvars;
       `else
          $dumpfile("tb_openGFX430.vcd");
          $dumpvars(0, tb_openGFX430);
       `endif
     `endif
   `endif
  end

//
// End of simulation
//----------------------------------------

initial // Timeout
  begin
   `ifdef NO_TIMEOUT
   `else
     `ifdef VERY_LONG_TIMEOUT
       #(1000ms);
     `else
     `ifdef LONG_TIMEOUT
       #(100ms);
     `else
       #(10ms);
     `endif
     `endif
       $display(" ===============================================");
       $display("|               SIMULATION FAILED               |");
       $display("|              (simulation Timeout)             |");
       $display(" ===============================================");
       $display("");
       $finish;
   `endif
  end

initial // Normal end of test
  begin
     @(posedge stimulus_done);

     $display(" ===============================================");
     if (error!=0)
       begin
          $display("|               SIMULATION FAILED               |");
          $display("|     (some verilog stimulus checks failed)     |");
       end
     else
       begin
          $display("|               SIMULATION PASSED               |");
       end
     $display(" ===============================================");
     $display("");
     $finish;
  end


//
// Tasks Definition
//------------------------------

   task tb_error;
      input [65*8:0] error_string;
      begin
         $display("ERROR: %s %t", error_string, $time);
         error = error+1;
      end
   endtask

   task tb_skip_finish;
      input [65*8-1:0] skip_string;
      begin
         $display(" ===============================================");
         $display("|               SIMULATION SKIPPED              |");
         $display("%s", skip_string);
         $display(" ===============================================");
         $display("");
         $finish;
      end
   endtask

endmodule
