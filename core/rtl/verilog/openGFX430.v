//----------------------------------------------------------------------------
// Copyright (C) 2016 Authors
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
// *File Name: openGFX430.v
//
// *Module Description:
//                      This is a basic video controller for the openMSP430.
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev$
// $LastChangedBy$
// $LastChangedDate$
//----------------------------------------------------------------------------
`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_defines.v"
`endif

module  openGFX430 (

// Clock & Reset
    mclk,                                           // Main system clock
    puc_rst,                                        // Main system reset

// Peripheral Interface
    per_addr_i,                                     // Peripheral address
    per_en_i,                                       // Peripheral enable (high active)
    per_we_i,                                       // Peripheral write enable (high active)
    per_din_i,                                      // Peripheral data input
    per_dout_o,                                     // Peripheral data output

    dbg_freeze_i,                                   // Freeze address auto-incr on read
    irq_gfx_o,                                      // Graphic Controller interrupt

// LUT SRAM Interface
`ifdef WITH_PROGRAMMABLE_LUT
    lut_ram_dout_i,                                 // LUT-RAM data output
    lut_ram_addr_o,                                 // LUT-RAM address
    lut_ram_wen_o,                                  // LUT-RAM write enable (active low)
    lut_ram_cen_o,                                  // LUT-RAM enable (active low)
    lut_ram_din_o,                                  // LUT-RAM data input
`endif

// VIDEO SRAM Interface
    vid_ram_dout_i,                                 // Video-RAM data output
    vid_ram_addr_o,                                 // Video-RAM address
    vid_ram_wen_o,                                  // Video-RAM write enable (active low)
    vid_ram_cen_o,                                  // Video-RAM enable (active low)
    vid_ram_din_o,                                  // Video-RAM data input

// Generic Screen Interface
    screen_refresh_active_i,                        // Display refresh on going
    screen_refresh_data_request_i,                  // Display refresh new data request
    screen_refresh_data_ready_o,                    // Display refresh new data is ready
    screen_refresh_data_o,                          // Display refresh data
    screen_display_width_o,                         // Display width configuration (number of pixels)
    screen_display_height_o,                        // Display height configuration (number of pixels)
    screen_display_size_o                           // Display size configuration (number of pixels)
);

// PARAMETERs
//============

parameter     [14:0] BASE_ADDR = 15'h0200;          // Register base address
                                                    //  - 7 LSBs must stay cleared: 0x0080, 0x0100,
                                                    //                              0x0180, 0x0200,
                                                    //                              0x0280, ...
// PORTs
//=========

// Clock & Reset
input                mclk;                          // Main system clock
input                puc_rst;                       // Main system reset

// Peripheral Interface
input         [13:0] per_addr_i;                    // Peripheral address
input                per_en_i;                      // Peripheral enable (high active)
input          [1:0] per_we_i;                      // Peripheral write enable (high active)
input         [15:0] per_din_i;                     // Peripheral data input
output        [15:0] per_dout_o;                    // Peripheral data output

input                dbg_freeze_i;                  // Freeze address auto-incr on read
output               irq_gfx_o;                     // Graphic Controller interrupt

// LUT SRAM Interface
`ifdef WITH_PROGRAMMABLE_LUT
input         [15:0] lut_ram_dout_i;                // LUT-RAM data output
output [`LRAM_MSB:0] lut_ram_addr_o;                // LUT-RAM address
output               lut_ram_wen_o;                 // LUT-RAM write enable (active low)
output               lut_ram_cen_o;                 // LUT-RAM enable (active low)
output        [15:0] lut_ram_din_o;                 // LUT-RAM data input
`endif

// VIDEO SRAM Interface
input         [15:0] vid_ram_dout_i;                // Video-RAM data output
output [`VRAM_MSB:0] vid_ram_addr_o;                // Video-RAM address
output               vid_ram_wen_o;                 // Video-RAM write enable (active low)
output               vid_ram_cen_o;                 // Video-RAM enable (active low)
output        [15:0] vid_ram_din_o;                 // Video-RAM data input

// Generic Screen Interface
input                screen_refresh_active_i;       // Display refresh on going
input                screen_refresh_data_request_i; // Display refresh new data request
output               screen_refresh_data_ready_o;   // Display refresh new data is ready
output        [15:0] screen_refresh_data_o;         // Display refresh data
output [`LPIX_MSB:0] screen_display_width_o;        // Display width configuration (number of pixels)
output [`LPIX_MSB:0] screen_display_height_o;       // Display height configuration (number of pixels)
output [`SPIX_MSB:0] screen_display_size_o;         // Display size configuration (number of pixels)


//=============================================================================
// 1)  WIRE & PARAMETER DECLARATION
//=============================================================================

wire                 display_y_swap;
wire                 display_x_swap;
wire                 display_cl_swap;
wire           [2:0] gfx_mode;

`ifdef WITH_PROGRAMMABLE_LUT
wire   [`LRAM_MSB:0] lut_ram_sw_addr;
wire          [15:0] lut_ram_sw_din;
wire                 lut_ram_sw_wen;
wire                 lut_ram_sw_cen;
wire          [15:0] lut_ram_sw_dout;
wire   [`LRAM_MSB:0] lut_ram_refr_addr;
wire                 lut_ram_refr_cen;
wire          [15:0] lut_ram_refr_dout;
wire                 lut_ram_refr_dout_rdy_nxt;
`endif

wire   [`VRAM_MSB:0] vid_ram_sw_addr;
wire          [15:0] vid_ram_sw_din;
wire                 vid_ram_sw_wen;
wire                 vid_ram_sw_cen;
wire          [15:0] vid_ram_sw_dout;
wire   [`VRAM_MSB:0] vid_ram_gpu_addr;
wire          [15:0] vid_ram_gpu_din;
wire                 vid_ram_gpu_wen;
wire                 vid_ram_gpu_cen;
wire          [15:0] vid_ram_gpu_dout;
wire                 vid_ram_gpu_dout_rdy_nxt;
wire   [`VRAM_MSB:0] vid_ram_refr_addr;
wire                 vid_ram_refr_cen;
wire          [15:0] vid_ram_refr_dout;
wire                 vid_ram_refr_dout_rdy_nxt;

wire   [`APIX_MSB:0] refresh_frame_addr;
wire           [2:0] hw_lut_palette_sel;
wire           [3:0] hw_lut_bgcolor;
wire           [3:0] hw_lut_fgcolor;
wire                 sw_lut_enable;
wire                 sw_lut_bank_select;

wire                 gpu_cmd_done_evt;
wire                 gpu_cmd_error_evt;
wire                 gpu_dma_busy;
wire                 gpu_get_data;
wire          [15:0] gpu_data;
wire                 gpu_data_avail;
wire                 gpu_enable;


//============================================================================
// 2)  REGISTERS
//============================================================================

ogfx_reg  #(.BASE_ADDR(BASE_ADDR)) ogfx_reg_inst (

// OUTPUTs
    .irq_gfx_o                     ( irq_gfx_o                     ),    // Graphic Controller interrupt

    .gpu_data_o                    ( gpu_data                      ),    // GPU data
    .gpu_data_avail_o              ( gpu_data_avail                ),    // GPU data available
    .gpu_enable_o                  ( gpu_enable                    ),    // GPU enable

    .display_width_o               ( screen_display_width_o        ),    // Display width
    .display_height_o              ( screen_display_height_o       ),    // Display height
    .display_size_o                ( screen_display_size_o         ),    // Display size (number of pixels)
    .display_y_swap_o              ( display_y_swap                ),    // Display configuration: swap Y axis (horizontal symmetry)
    .display_x_swap_o              ( display_x_swap                ),    // Display configuration: swap X axis (vertical symmetry)
    .display_cl_swap_o             ( display_cl_swap               ),    // Display configuration: swap column/lines

    .gfx_mode_o                    ( gfx_mode                      ),    // Video mode (1xx:16bpp / 011:8bpp / 010:4bpp / 001:2bpp / 000:1bpp)

    .per_dout_o                    ( per_dout_o                    ),    // Peripheral data output

    .refresh_frame_addr_o          ( refresh_frame_addr            ),    // Refresh frame base address

    .hw_lut_palette_sel_o          ( hw_lut_palette_sel            ),    // Hardware LUT palette configuration
    .hw_lut_bgcolor_o              ( hw_lut_bgcolor                ),    // Hardware LUT background-color selection
    .hw_lut_fgcolor_o              ( hw_lut_fgcolor                ),    // Hardware LUT foreground-color selection
    .sw_lut_enable_o               ( sw_lut_enable                 ),    // Refresh LUT-RAM enable
    .sw_lut_bank_select_o          ( sw_lut_bank_select            ),    // Refresh LUT-RAM bank selection

`ifdef WITH_PROGRAMMABLE_LUT
    .lut_ram_addr_o                ( lut_ram_sw_addr               ),    // LUT-RAM address
    .lut_ram_din_o                 ( lut_ram_sw_din                ),    // LUT-RAM data
    .lut_ram_wen_o                 ( lut_ram_sw_wen                ),    // LUT-RAM write strobe (active low)
    .lut_ram_cen_o                 ( lut_ram_sw_cen                ),    // LUT-RAM chip enable (active low)
`endif

    .vid_ram_addr_o                ( vid_ram_sw_addr               ),    // Video-RAM address
    .vid_ram_din_o                 ( vid_ram_sw_din                ),    // Video-RAM data
    .vid_ram_wen_o                 ( vid_ram_sw_wen                ),    // Video-RAM write strobe (active low)
    .vid_ram_cen_o                 ( vid_ram_sw_cen                ),    // Video-RAM chip enable (active low)

// INPUTs
    .dbg_freeze_i                  ( dbg_freeze_i                  ),    // Freeze address auto-incr on read
    .gpu_cmd_done_evt_i            ( gpu_cmd_done_evt              ),    // GPU command done event
    .gpu_cmd_error_evt_i           ( gpu_cmd_error_evt             ),    // GPU command error event
    .gpu_dma_busy_i                ( gpu_dma_busy                  ),    // GPU DMA execution on going
    .gpu_get_data_i                ( gpu_get_data                  ),    // GPU get next data
    .mclk                          ( mclk                          ),    // Main system clock
    .per_addr_i                    ( per_addr_i                    ),    // Peripheral address
    .per_din_i                     ( per_din_i                     ),    // Peripheral data input
    .per_en_i                      ( per_en_i                      ),    // Peripheral enable (high active)
    .per_we_i                      ( per_we_i                      ),    // Peripheral write enable (high active)
    .puc_rst                       ( puc_rst                       ),    // Main system reset

`ifdef WITH_PROGRAMMABLE_LUT
    .lut_ram_dout_i                ( lut_ram_sw_dout               ),    // LUT-RAM data input
`endif
    .vid_ram_dout_i                ( vid_ram_sw_dout               )     // Video-RAM data input
);


//============================================================================
// 3)  GPU
//============================================================================

ogfx_gpu  ogfx_gpu_inst (

// OUTPUTs
    .gpu_cmd_done_evt_o            ( gpu_cmd_done_evt              ),    // GPU command done event
    .gpu_cmd_error_evt_o           ( gpu_cmd_error_evt             ),    // GPU command error event
    .gpu_dma_busy_o                ( gpu_dma_busy                  ),    // GPU DMA execution on going
    .gpu_get_data_o                ( gpu_get_data                  ),    // GPU get next data

    .vid_ram_addr_o                ( vid_ram_gpu_addr              ),    // Video-RAM address
    .vid_ram_din_o                 ( vid_ram_gpu_din               ),    // Video-RAM data
    .vid_ram_wen_o                 ( vid_ram_gpu_wen               ),    // Video-RAM write strobe (active low)
    .vid_ram_cen_o                 ( vid_ram_gpu_cen               ),    // Video-RAM chip enable (active low)

// INPUTs
    .mclk                          ( mclk                          ),    // Main system clock
    .puc_rst                       ( puc_rst                       ),    // Main system reset

    .display_width_i               ( screen_display_width_o        ),    // Display width

    .gfx_mode_i                    ( gfx_mode                      ),    // Video mode (1xx:16bpp / 011:8bpp / 010:4bpp / 001:2bpp / 000:1bpp)

    .gpu_data_i                    ( gpu_data                      ),    // GPU data
    .gpu_data_avail_i              ( gpu_data_avail                ),    // GPU data available
    .gpu_enable_i                  ( gpu_enable                    ),    // GPU enable

    .vid_ram_dout_i                ( vid_ram_gpu_dout              ),    // Video-RAM data input
    .vid_ram_dout_rdy_nxt_i        ( vid_ram_gpu_dout_rdy_nxt      )     // Video-RAM data output ready during next cycle
);


//============================================================================
// 4) VIDEO BACKEND
//============================================================================

ogfx_backend  ogfx_backend_inst (

// OUTPUTs
    .refresh_data_o                ( screen_refresh_data_o         ),    // Display refresh data
    .refresh_data_ready_o          ( screen_refresh_data_ready_o   ),    // Display refresh new data is ready

    .vid_ram_addr_o                ( vid_ram_refr_addr             ),    // Video-RAM address
    .vid_ram_cen_o                 ( vid_ram_refr_cen              ),    // Video-RAM enable (active low)

`ifdef WITH_PROGRAMMABLE_LUT
    .lut_ram_addr_o                ( lut_ram_refr_addr             ),    // LUT-RAM address
    .lut_ram_cen_o                 ( lut_ram_refr_cen              ),    // LUT-RAM enable (active low)
`endif

// INPUTs
    .mclk                          ( mclk                          ),    // Main system clock
    .puc_rst                       ( puc_rst                       ),    // Main system reset

    .display_width_i               ( screen_display_width_o        ),    // Display width
    .display_height_i              ( screen_display_height_o       ),    // Display height
    .display_size_i                ( screen_display_size_o         ),    // Display size (number of pixels)
    .display_y_swap_i              ( display_y_swap                ),    // Display configuration: swap Y axis (horizontal symmetry)
    .display_x_swap_i              ( display_x_swap                ),    // Display configuration: swap X axis (vertical symmetry)
    .display_cl_swap_i             ( display_cl_swap               ),    // Display configuration: swap column/lines

    .gfx_mode_i                    ( gfx_mode                      ),    // Video mode (1xx:16bpp / 011:8bpp / 010:4bpp / 001:2bpp / 000:1bpp)

`ifdef WITH_PROGRAMMABLE_LUT
    .lut_ram_dout_i                ( lut_ram_refr_dout             ),    // LUT-RAM data output
    .lut_ram_dout_rdy_nxt_i        ( lut_ram_refr_dout_rdy_nxt     ),    // LUT-RAM data output ready during next cycle
`endif

    .vid_ram_dout_i                ( vid_ram_refr_dout             ),    // Video-RAM data output
    .vid_ram_dout_rdy_nxt_i        ( vid_ram_refr_dout_rdy_nxt     ),    // Video-RAM data output ready during next cycle

    .refresh_active_i              ( screen_refresh_active_i       ),    // Display refresh on going
    .refresh_data_request_i        ( screen_refresh_data_request_i ),    // Display refresh new data request
    .refresh_frame_base_addr_i     ( refresh_frame_addr            ),    // Refresh frame base address

    .hw_lut_palette_sel_i          ( hw_lut_palette_sel            ),    // Hardware LUT palette configuration
    .hw_lut_bgcolor_i              ( hw_lut_bgcolor                ),    // Hardware LUT background-color selection
    .hw_lut_fgcolor_i              ( hw_lut_fgcolor                ),    // Hardware LUT foreground-color selection
    .sw_lut_enable_i               ( sw_lut_enable                 ),    // Refresh LUT-RAM enable
    .sw_lut_bank_select_i          ( sw_lut_bank_select            )     // Refresh LUT-RAM bank selection
);


//============================================================================
// 5) ARBITER FOR VIDEO AND LUT MEMORIES
//============================================================================

ogfx_ram_arbiter  ogfx_ram_arbiter_inst (

    .mclk                          ( mclk                          ),    // Main system clock
    .puc_rst                       ( puc_rst                       ),    // Main system reset

   //------------------------------------------------------------

   // SW interface, fixed highest priority
    .lut_ram_sw_addr_i             ( lut_ram_sw_addr               ),    // LUT-RAM Software address
    .lut_ram_sw_din_i              ( lut_ram_sw_din                ),    // LUT-RAM Software data
    .lut_ram_sw_wen_i              ( lut_ram_sw_wen                ),    // LUT-RAM Software write strobe (active low)
    .lut_ram_sw_cen_i              ( lut_ram_sw_cen                ),    // LUT-RAM Software chip enable (active low)
    .lut_ram_sw_dout_o             ( lut_ram_sw_dout               ),    // LUT-RAM Software data input

   // Refresh-backend, fixed lowest priority
    .lut_ram_refr_addr_i           ( lut_ram_refr_addr             ),    // LUT-RAM Refresh address
    .lut_ram_refr_din_i            ( 16'h0000                      ),    // LUT-RAM Refresh data
    .lut_ram_refr_wen_i            ( 1'h1                          ),    // LUT-RAM Refresh write strobe (active low)
    .lut_ram_refr_cen_i            ( lut_ram_refr_cen              ),    // LUT-RAM Refresh enable (active low)
    .lut_ram_refr_dout_o           ( lut_ram_refr_dout             ),    // LUT-RAM Refresh data output
    .lut_ram_refr_dout_rdy_nxt_o   ( lut_ram_refr_dout_rdy_nxt     ),    // LUT-RAM Refresh data output ready during next cycle

   // LUT Memory interface
    .lut_ram_addr_o                ( lut_ram_addr_o                ),    // LUT-RAM address
    .lut_ram_din_o                 ( lut_ram_din_o                 ),    // LUT-RAM data
    .lut_ram_wen_o                 ( lut_ram_wen_o                 ),    // LUT-RAM write strobe (active low)
    .lut_ram_cen_o                 ( lut_ram_cen_o                 ),    // LUT-RAM chip enable (active low)
    .lut_ram_dout_i                ( lut_ram_dout_i                ),    // LUT-RAM data input

   //------------------------------------------------------------

   // SW interface, fixed highest priority
    .vid_ram_sw_addr_i             ( vid_ram_sw_addr               ),    // Video-RAM Software address
    .vid_ram_sw_din_i              ( vid_ram_sw_din                ),    // Video-RAM Software data
    .vid_ram_sw_wen_i              ( vid_ram_sw_wen                ),    // Video-RAM Software write strobe (active low)
    .vid_ram_sw_cen_i              ( vid_ram_sw_cen                ),    // Video-RAM Software chip enable (active low)
    .vid_ram_sw_dout_o             ( vid_ram_sw_dout               ),    // Video-RAM Software data input

   // GPU interface (round-robin with refresh-backend)
    .vid_ram_gpu_addr_i            ( vid_ram_gpu_addr              ),    // Video-RAM GPU address
    .vid_ram_gpu_din_i             ( vid_ram_gpu_din               ),    // Video-RAM GPU data
    .vid_ram_gpu_wen_i             ( vid_ram_gpu_wen               ),    // Video-RAM GPU write strobe (active low)
    .vid_ram_gpu_cen_i             ( vid_ram_gpu_cen               ),    // Video-RAM GPU chip enable (active low)
    .vid_ram_gpu_dout_o            ( vid_ram_gpu_dout              ),    // Video-RAM GPU data input
    .vid_ram_gpu_dout_rdy_nxt_o    ( vid_ram_gpu_dout_rdy_nxt      ),    // Video-RAM GPU data output ready during next cycle

   // Refresh-backend (round-robin with GPU interface)
    .vid_ram_refr_addr_i           ( vid_ram_refr_addr             ),    // Video-RAM Refresh address
    .vid_ram_refr_din_i            ( 16'h0000                      ),    // Video-RAM Refresh data
    .vid_ram_refr_wen_i            ( 1'h1                          ),    // Video-RAM Refresh write strobe (active low)
    .vid_ram_refr_cen_i            ( vid_ram_refr_cen              ),    // Video-RAM Refresh enable (active low)
    .vid_ram_refr_dout_o           ( vid_ram_refr_dout             ),    // Video-RAM Refresh data output
    .vid_ram_refr_dout_rdy_nxt_o   ( vid_ram_refr_dout_rdy_nxt     ),    // Video-RAM Refresh data output ready during next cycle

   // Video Memory interface
    .vid_ram_addr_o                ( vid_ram_addr_o                ),    // Video-RAM address
    .vid_ram_din_o                 ( vid_ram_din_o                 ),    // Video-RAM data
    .vid_ram_wen_o                 ( vid_ram_wen_o                 ),    // Video-RAM write strobe (active low)
    .vid_ram_cen_o                 ( vid_ram_cen_o                 ),    // Video-RAM chip enable (active low)
    .vid_ram_dout_i                ( vid_ram_dout_i                )     // Video-RAM data input

   //------------------------------------------------------------
);


endmodule // openGFX430

`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_undefines.v"
`endif
