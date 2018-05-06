//----------------------------------------------------------------------------
// Copyright (C) 2015 Authors
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
// *File Name: ogfx_if_lt24_reg.v
//
// *Module Description:
//                      Registers for LT24 interface.
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

module  ogfx_if_lt24_reg (

// OUTPUTs
    irq_lt24_o,                                // LT24 interface interrupt

    lt24_reset_n_o,                            // LT24 Reset (Active Low)
    lt24_on_o,                                 // LT24 on/off
    lt24_cfg_clk_o,                            // LT24 Interface clock configuration
    lt24_cfg_refr_o,                           // LT24 Interface refresh configuration
    lt24_cfg_refr_sync_en_o,                   // LT24 Interface refresh sync enable configuration
    lt24_cfg_refr_sync_val_o,                  // LT24 Interface refresh sync value configuration
    lt24_cmd_refr_o,                           // LT24 Interface refresh command
    lt24_cmd_val_o,                            // LT24 Generic command value
    lt24_cmd_has_param_o,                      // LT24 Generic command has parameters
    lt24_cmd_param_o,                          // LT24 Generic command parameter value
    lt24_cmd_param_rdy_o,                      // LT24 Generic command trigger
    lt24_cmd_dfill_o,                          // LT24 Data fill value
    lt24_cmd_dfill_wr_o,                       // LT24 Data fill trigger

    per_dout_o,                                // Peripheral data output

// INPUTs
    mclk,                                      // Main system clock
    puc_rst,                                   // Main system reset

    lt24_status_i,                             // LT24 FSM Status
    lt24_start_evt_i,                          // LT24 FSM is starting
    lt24_done_evt_i,                           // LT24 FSM is done

    per_addr_i,                                // Peripheral address
    per_din_i,                                 // Peripheral data input
    per_en_i,                                  // Peripheral enable (high active)
    per_we_i                                   // Peripheral write enable (high active)
);

// PARAMETERs
//============

parameter     [14:0] BASE_ADDR = 15'h0280;     // Register base address
                                               //  - 5 LSBs must stay cleared: 0x0020, 0x0040,
                                               //                              0x0060, 0x0080,
                                               //                              0x00A0, ...
// OUTPUTs
//============
output               irq_lt24_o;               // LT24 interface interrupt

output               lt24_reset_n_o;           // LT24 Reset (Active Low)
output               lt24_on_o;                // LT24 on/off
output         [2:0] lt24_cfg_clk_o;           // LT24 Interface clock configuration
output        [11:0] lt24_cfg_refr_o;          // LT24 Interface refresh configuration
output               lt24_cfg_refr_sync_en_o;  // LT24 Interface refresh sync configuration
output         [9:0] lt24_cfg_refr_sync_val_o; // LT24 Interface refresh sync value configuration
output               lt24_cmd_refr_o;          // LT24 Interface refresh command
output         [7:0] lt24_cmd_val_o;           // LT24 Generic command value
output               lt24_cmd_has_param_o;     // LT24 Generic command has parameters
output        [15:0] lt24_cmd_param_o;         // LT24 Generic command parameter value
output               lt24_cmd_param_rdy_o;     // LT24 Generic command trigger
output        [15:0] lt24_cmd_dfill_o;         // LT24 Data fill value
output               lt24_cmd_dfill_wr_o;      // LT24 Data fill trigger

output        [15:0] per_dout_o;               // Peripheral data output

// INPUTs
//============
input                mclk;                     // Main system clock
input                puc_rst;                  // Main system reset

input          [4:0] lt24_status_i;            // LT24 FSM Status
input                lt24_start_evt_i;         // LT24 FSM is starting
input                lt24_done_evt_i;          // LT24 FSM is done

input         [13:0] per_addr_i;               // Peripheral address
input         [15:0] per_din_i;                // Peripheral data input
input                per_en_i;                 // Peripheral enable (high active)
input          [1:0] per_we_i;                 // Peripheral write enable (high active)


//=============================================================================
// 1)  PARAMETER DECLARATION
//=============================================================================

// Decoder bit width (defines how many bits are considered for address decoding)
parameter              DEC_WD              =  5;

// Register addresses offset
parameter [DEC_WD-1:0] LT24_CFG            = 'h00,  // LT24 configuration and Generic command sending
                       LT24_REFRESH        = 'h02,
                       LT24_REFRESH_SYNC   = 'h04,
                       LT24_CMD            = 'h06,
                       LT24_CMD_PARAM      = 'h08,
                       LT24_CMD_DFILL      = 'h0A,
                       LT24_STATUS         = 'h0C,
                       LT24_IRQ            = 'h0E;


// Register one-hot decoder utilities
parameter              DEC_SZ              =  (1 << DEC_WD);
parameter [DEC_SZ-1:0] BASE_REG            =  {{DEC_SZ-1{1'b0}}, 1'b1};

// Register one-hot decoder
parameter [DEC_SZ-1:0] LT24_CFG_D          = (BASE_REG << LT24_CFG          ),
                       LT24_REFRESH_D      = (BASE_REG << LT24_REFRESH      ),
                       LT24_REFRESH_SYNC_D = (BASE_REG << LT24_REFRESH_SYNC ),
                       LT24_CMD_D          = (BASE_REG << LT24_CMD          ),
                       LT24_CMD_PARAM_D    = (BASE_REG << LT24_CMD_PARAM    ),
                       LT24_CMD_DFILL_D    = (BASE_REG << LT24_CMD_DFILL    ),
                       LT24_STATUS_D       = (BASE_REG << LT24_STATUS       ),
                       LT24_IRQ_D          = (BASE_REG << LT24_IRQ          );


//============================================================================
// 2)  REGISTER DECODER
//============================================================================

// Local register selection
wire               reg_sel   =  per_en_i & (per_addr_i[13:DEC_WD-1]==BASE_ADDR[14:DEC_WD]);

// Register local address
wire  [DEC_WD-1:0] reg_addr  =  {per_addr_i[DEC_WD-2:0], 1'b0};

// Register address decode
wire  [DEC_SZ-1:0] reg_dec   =  (LT24_CFG_D          &  {DEC_SZ{(reg_addr == LT24_CFG          )}})  |
                                (LT24_REFRESH_D      &  {DEC_SZ{(reg_addr == LT24_REFRESH      )}})  |
                                (LT24_REFRESH_SYNC_D &  {DEC_SZ{(reg_addr == LT24_REFRESH_SYNC )}})  |
                                (LT24_CMD_D          &  {DEC_SZ{(reg_addr == LT24_CMD          )}})  |
                                (LT24_CMD_PARAM_D    &  {DEC_SZ{(reg_addr == LT24_CMD_PARAM    )}})  |
                                (LT24_CMD_DFILL_D    &  {DEC_SZ{(reg_addr == LT24_CMD_DFILL    )}})  |
                                (LT24_STATUS_D       &  {DEC_SZ{(reg_addr == LT24_STATUS       )}})  |
                                (LT24_IRQ_D          &  {DEC_SZ{(reg_addr == LT24_IRQ          )}})  ;

// Read/Write probes
wire               reg_write =  |per_we_i & reg_sel;
wire               reg_read  = ~|per_we_i & reg_sel;

// Read/Write vectors
wire  [DEC_SZ-1:0] reg_wr    = reg_dec & {DEC_SZ{reg_write}};
wire  [DEC_SZ-1:0] reg_rd    = reg_dec & {DEC_SZ{reg_read}};


//============================================================================
// 3) REGISTERS
//============================================================================

//------------------------------------------------
// LT24_CFG Register
//------------------------------------------------
reg  [15:0] lt24_cfg;

wire        lt24_cfg_wr = reg_wr[LT24_CFG];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)          lt24_cfg  <=  16'h0000;
  else if (lt24_cfg_wr) lt24_cfg  <=  per_din_i & 16'hC07F;

// Bitfield assignments
wire        lt24_irq_refr_done_en  =  lt24_cfg[15];
wire        lt24_irq_refr_start_en =  lt24_cfg[14];
assign      lt24_cfg_clk_o         =  lt24_cfg[6:4];
assign      lt24_reset_n_o         = ~lt24_cfg[1];
assign      lt24_on_o              =  lt24_cfg[0];


//------------------------------------------------
// LT24_REFRESH Register
//------------------------------------------------
reg         lt24_cmd_refr_o;
reg  [11:0] lt24_cfg_refr_o;

wire        lt24_refresh_wr   = reg_wr[LT24_REFRESH];
wire        lt24_cmd_refr_clr = lt24_done_evt_i & lt24_status_i[2] & (lt24_cfg_refr_o==12'h000); // Auto-clear in manual refresh mode when done

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                lt24_cmd_refr_o  <=  1'h0;
  else if (lt24_refresh_wr)   lt24_cmd_refr_o  <=  per_din_i[0];
  else if (lt24_cmd_refr_clr) lt24_cmd_refr_o  <=  1'h0;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                lt24_cfg_refr_o  <=  12'h000;
  else if (lt24_refresh_wr)   lt24_cfg_refr_o  <=  per_din_i[15:4];

wire [15:0] lt24_refresh = {lt24_cfg_refr_o, 3'h0, lt24_cmd_refr_o};


//------------------------------------------------
// LT24_REFRESH_SYNC Register
//------------------------------------------------
reg         lt24_cfg_refr_sync_en_o;
reg   [9:0] lt24_cfg_refr_sync_val_o;

wire        lt24_refresh_sync_wr   = reg_wr[LT24_REFRESH_SYNC];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                   lt24_cfg_refr_sync_en_o  <=  1'h0;
  else if (lt24_refresh_sync_wr) lt24_cfg_refr_sync_en_o  <=  per_din_i[15];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                   lt24_cfg_refr_sync_val_o <=  10'h000;
  else if (lt24_refresh_sync_wr) lt24_cfg_refr_sync_val_o <=  per_din_i[9:0];

wire [15:0] lt24_refresh_sync = {lt24_cfg_refr_sync_en_o, 5'h00, lt24_cfg_refr_sync_val_o};


//------------------------------------------------
// LT24_CMD Register
//------------------------------------------------
reg  [15:0] lt24_cmd;

wire        lt24_cmd_wr = reg_wr[LT24_CMD];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)          lt24_cmd <=  16'h0000;
  else if (lt24_cmd_wr) lt24_cmd <=  per_din_i & 16'h01FF;

assign      lt24_cmd_val_o        = lt24_cmd[7:0];
assign      lt24_cmd_has_param_o  = lt24_cmd[8];


//------------------------------------------------
// LT24_CMD_PARAM Register
//------------------------------------------------
reg  [15:0] lt24_cmd_param_o;

wire        lt24_cmd_param_wr = reg_wr[LT24_CMD_PARAM];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                lt24_cmd_param_o <=  16'h0000;
  else if (lt24_cmd_param_wr) lt24_cmd_param_o <=  per_din_i;

reg lt24_cmd_param_rdy_o;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_cmd_param_rdy_o <=  1'b0;
  else         lt24_cmd_param_rdy_o <=  lt24_cmd_param_wr;


//------------------------------------------------
// LT24_CMD_DFILL Register
//------------------------------------------------
reg  [15:0] lt24_cmd_dfill_o;

assign      lt24_cmd_dfill_wr_o = reg_wr[LT24_CMD_DFILL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                  lt24_cmd_dfill_o <=  16'h0000;
  else if (lt24_cmd_dfill_wr_o) lt24_cmd_dfill_o <=  per_din_i;


//------------------------------------------------
// LT24_STATUS Register
//------------------------------------------------
wire [15:0] lt24_status;

assign      lt24_status[0]    = lt24_status_i[0]; // FSM_BUSY
assign      lt24_status[1]    = lt24_status_i[1]; // WAIT_PARAM
assign      lt24_status[2]    = lt24_status_i[2]; // REFRESH_BUSY
assign      lt24_status[3]    = lt24_status_i[3]; // WAIT_FOR_SCANLINE
assign      lt24_status[4]    = lt24_status_i[4]; // DATA_FILL_BUSY
assign      lt24_status[15:5] = 11'h000;


//------------------------------------------------
// GFX_IRQ Register
//------------------------------------------------
wire [15:0] lt24_irq;

// Clear IRQ when 1 is written. Set IRQ when FSM is done
wire         lt24_irq_refr_done_clr  = per_din_i[15] & reg_wr[LT24_IRQ];
wire         lt24_irq_refr_done_set  = lt24_done_evt_i;

wire         lt24_irq_refr_start_clr = per_din_i[14] & reg_wr[LT24_IRQ];
wire         lt24_irq_refr_start_set = lt24_start_evt_i;

reg          lt24_irq_refr_done;
reg          lt24_irq_refr_start;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)
    begin
       lt24_irq_refr_done  <=  1'b0;
       lt24_irq_refr_start <=  1'b0;
    end
  else
    begin
       lt24_irq_refr_done  <=  ( lt24_irq_refr_done_set  | (~lt24_irq_refr_done_clr  & lt24_irq_refr_done ) ); // IRQ set has priority over clear
       lt24_irq_refr_start <=  ( lt24_irq_refr_start_set | (~lt24_irq_refr_start_clr & lt24_irq_refr_start) ); // IRQ set has priority over clear
    end

assign  lt24_irq   = {lt24_irq_refr_done, lt24_irq_refr_start, 14'h0000};

assign  irq_lt24_o = (lt24_irq_refr_done     & lt24_irq_refr_done_en)     |
                     (lt24_irq_refr_start    & lt24_irq_refr_start_en)    ;  // LT24 interrupt


//============================================================================
// 4) DATA OUTPUT GENERATION
//============================================================================

// Data output mux
wire [15:0] lt24_cfg_read          = lt24_cfg               & {16{reg_rd[LT24_CFG          ]}};
wire [15:0] lt24_refresh_read      = lt24_refresh           & {16{reg_rd[LT24_REFRESH      ]}};
wire [15:0] lt24_refresh_sync_read = lt24_refresh_sync      & {16{reg_rd[LT24_REFRESH_SYNC ]}};
wire [15:0] lt24_cmd_read          = lt24_cmd               & {16{reg_rd[LT24_CMD          ]}};
wire [15:0] lt24_cmd_param_read    = lt24_cmd_param_o       & {16{reg_rd[LT24_CMD_PARAM    ]}};
wire [15:0] lt24_cmd_dfill_read    = lt24_cmd_dfill_o       & {16{reg_rd[LT24_CMD_DFILL    ]}};
wire [15:0] lt24_status_read       = lt24_status            & {16{reg_rd[LT24_STATUS       ]}};
wire [15:0] lt24_irq_read          = lt24_irq               & {16{reg_rd[LT24_IRQ          ]}};

wire [15:0] per_dout_o             = lt24_cfg_read          |
                                     lt24_refresh_read      |
                                     lt24_refresh_sync_read |
                                     lt24_cmd_read          |
                                     lt24_cmd_param_read    |
                                     lt24_cmd_dfill_read    |
                                     lt24_status_read       |
                                     lt24_irq_read          ;

endmodule // ogfx_if_lt24_reg

`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_undefines.v"
`endif
