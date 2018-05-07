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
// *File Name: ogfx_if_lt24.v
//
// *Module Description:
//                      Interface to the LT24 LCD display.
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

module  ogfx_if_lt24 (

// Clock & Reset
    mclk                                           ,    // Main system clock
    puc_rst                                        ,    // Main system reset

// Peripheral Interface
    per_addr_i                                     ,    // Peripheral address
    per_en_i                                       ,    // Peripheral enable (high active)
    per_we_i                                       ,    // Peripheral write enable (high active)
    per_din_i                                      ,    // Peripheral data input
    per_dout_o                                     ,    // Peripheral data output

    irq_lt24_o                                     ,    // LT24 interface interrupt

// LT24 Interface
    lt24_d_i                                       ,    // LT24 Data input
    lt24_cs_n_o                                    ,    // LT24 Chip select (Active low)
    lt24_rd_n_o                                    ,    // LT24 Read strobe (Active low)
    lt24_wr_n_o                                    ,    // LT24 Write strobe (Active low)
    lt24_rs_o                                      ,    // LT24 Command/Param selection (Cmd=0/Param=1)
    lt24_d_o                                       ,    // LT24 Data output
    lt24_d_en_o                                    ,    // LT24 Data output enable
    lt24_reset_n_o                                 ,    // LT24 Reset (Active Low)
    lt24_on_o                                      ,    // LT24 on/off

// openGFX430 Interface
    screen_display_size_i                          ,    // Display size configuration (number of pixels)
    screen_refresh_data_i                          ,    // Display refresh data
    screen_refresh_data_ready_i                    ,    // Display refresh new data is ready
    screen_refresh_data_request_o                  ,    // Display refresh new data request
    screen_refresh_active_o                             // Display refresh on going
);

// PARAMETERs
parameter     [14:0] BASE_ADDR = 15'h0280          ;    // Register base address
                                                        //  - 5 LSBs must stay cleared: 0x0020, 0x0040,
                                                        //                              0x0060, 0x0080,
                                                        //                              0x00A0, ...

// Clock & Reset
input                mclk                          ;    // Main system clock
input                puc_rst                       ;    // Main system reset

// Peripheral Interface
input         [13:0] per_addr_i                    ;    // Peripheral address
input         [15:0] per_din_i                     ;    // Peripheral data input
input                per_en_i                      ;    // Peripheral enable (high active)
input          [1:0] per_we_i                      ;    // Peripheral write enable (high active)
output        [15:0] per_dout_o                    ;    // Peripheral data output

output               irq_lt24_o                    ;    // LT24 interface interrupt

// LT24 Interface
input         [15:0] lt24_d_i                      ;    // LT24 Data input
output               lt24_cs_n_o                   ;    // LT24 Chip select (Active low)
output               lt24_rd_n_o                   ;    // LT24 Read strobe (Active low)
output               lt24_wr_n_o                   ;    // LT24 Write strobe (Active low)
output               lt24_rs_o                     ;    // LT24 Command/Param selection (Cmd=0/Param=1)
output        [15:0] lt24_d_o                      ;    // LT24 Data output
output               lt24_d_en_o                   ;    // LT24 Data output enable
output               lt24_reset_n_o                ;    // LT24 Reset (Active Low)
output               lt24_on_o                     ;    // LT24 on/off

// openGFX430 Interface
input  [`SPIX_MSB:0] screen_display_size_i         ;    // Display size configuration (number of pixels)
input         [15:0] screen_refresh_data_i         ;    // Display refresh data
input                screen_refresh_data_ready_i   ;    // Display refresh new data is ready
output               screen_refresh_data_request_o ;    // Display refresh new data request
output               screen_refresh_active_o       ;    // Display refresh on going


//=============================================================================
// 1)  WIRE, REGISTERS AND PARAMETER DECLARATION
//=============================================================================

// Configuration, control and status registers
wire           [2:0] lt24_cfg_clk                  ;           
wire          [11:0] lt24_cfg_refr                 ;          
wire                 lt24_cfg_refr_sync_en         ;  
wire           [9:0] lt24_cfg_refr_sync_val        ; 
wire                 lt24_cmd_refresh              ;          
wire           [7:0] lt24_cmd_val                  ;           
wire                 lt24_cmd_has_param            ;     
wire          [15:0] lt24_cmd_param_val            ;         
wire                 lt24_cmd_param_trig           ;     
wire          [15:0] lt24_cmd_dfill                ;         
wire                 lt24_cmd_dfill_trig           ;      
wire           [4:0] lt24_status                   ;            
wire                 lt24_start_evt                ;         
wire                 lt24_done_evt                 ;          

// State machine registers
reg            [4:0] lt24_state                    ;
reg            [4:0] lt24_state_nxt                ;

// Others
reg                  refresh_trigger               ;
wire                 status_gts_match              ;

// State definition
parameter            STATE_IDLE               =   0,    // IDLE state

                     STATE_CMD_LO             =   1,    // Generic command to LT24
                     STATE_CMD_HI             =   2,
                     STATE_CMD_PARAM_LO       =   3,
                     STATE_CMD_PARAM_HI       =   4,
                     STATE_CMD_PARAM_WAIT     =   5,

                     STATE_RAMWR_INIT_CMD_LO  =   6,    // Initialize display buffer with data
                     STATE_RAMWR_INIT_CMD_HI  =   7,
                     STATE_RAMWR_INIT_DATA_LO =   8,
                     STATE_RAMWR_INIT_DATA_HI =   9,

                     STATE_SCANLINE_CMD_LO    =  10,    // Wait for right scanline
                     STATE_SCANLINE_CMD_HI    =  11,
                     STATE_SCANLINE_DUMMY_LO  =  12,
                     STATE_SCANLINE_DUMMY_HI  =  13,
                     STATE_SCANLINE_GTS1_LO   =  14,
                     STATE_SCANLINE_GTS1_HI   =  15,
                     STATE_SCANLINE_GTS2_LO   =  16,
                     STATE_SCANLINE_GTS2_HI   =  17,


                     STATE_RAMWR_REFR_CMD_LO  =  18,    // Refresh display buffer
                     STATE_RAMWR_REFR_CMD_HI  =  19,
                     STATE_RAMWR_REFR_WAIT    =  20,
                     STATE_RAMWR_REFR_DATA_LO =  21,
                     STATE_RAMWR_REFR_DATA_HI =  22;


//============================================================================
// 2) STATE MACHINE SENDING IMAGE DATA TO A SPECIFIED DISPLAY
//============================================================================

ogfx_if_lt24_reg #(.BASE_ADDR(BASE_ADDR)) ogfx_if_lt24_reg_inst (

// OUTPUTs
    .irq_lt24_o               ( irq_lt24_o             ),  // LT24 interface interrupt

    .lt24_reset_n_o           ( lt24_reset_n_o         ),  // LT24 Reset (Active Low)
    .lt24_on_o                ( lt24_on_o              ),  // LT24 on/off
    .lt24_cfg_clk_o           ( lt24_cfg_clk           ),  // LT24 Interface clock configuration
    .lt24_cfg_refr_o          ( lt24_cfg_refr          ),  // LT24 Interface refresh configuration
    .lt24_cfg_refr_sync_en_o  ( lt24_cfg_refr_sync_en  ),  // LT24 Interface refresh sync enable configuration
    .lt24_cfg_refr_sync_val_o ( lt24_cfg_refr_sync_val ),  // LT24 Interface refresh sync value configuration
    .lt24_cmd_refr_o          ( lt24_cmd_refresh       ),  // LT24 Interface refresh command
    .lt24_cmd_val_o           ( lt24_cmd_val           ),  // LT24 Generic command value
    .lt24_cmd_has_param_o     ( lt24_cmd_has_param     ),  // LT24 Generic command has parameters
    .lt24_cmd_param_o         ( lt24_cmd_param_val     ),  // LT24 Generic command parameter value
    .lt24_cmd_param_rdy_o     ( lt24_cmd_param_trig    ),  // LT24 Generic command trigger
    .lt24_cmd_dfill_o         ( lt24_cmd_dfill         ),  // LT24 Data fill value
    .lt24_cmd_dfill_wr_o      ( lt24_cmd_dfill_trig    ),  // LT24 Data fill trigger

    .per_dout_o               ( per_dout_o             ),  // Peripheral data output

// INPUTs
    .mclk                     ( mclk                   ),  // Main system clock
    .puc_rst                  ( puc_rst                ),  // Main system reset

    .lt24_status_i            ( lt24_status            ),  // LT24 FSM Status
    .lt24_start_evt_i         ( lt24_start_evt         ),  // LT24 FSM is starting
    .lt24_done_evt_i          ( lt24_done_evt          ),  // LT24 FSM is done

    .per_addr_i               ( per_addr_i             ),  // Peripheral address
    .per_din_i                ( per_din_i              ),  // Peripheral data input
    .per_en_i                 ( per_en_i               ),  // Peripheral enable (high active)
    .per_we_i                 ( per_we_i               )   // Peripheral write enable (high active)
);


//============================================================================
// 3) STATE MACHINE SENDING IMAGE DATA TO A SPECIFIED DISPLAY
//============================================================================

//--------------------------------
// LT24 Controller Clock Timer
//--------------------------------
reg [3:0] lt24_timer;

wire      lt24_timer_done = lt24_d_en_o ? (lt24_timer == {1'b0, lt24_cfg_clk}) :
                                          (lt24_timer == {lt24_cfg_clk, 1'b0}) ; // Use slower timing for read accesses

wire      lt24_timer_run  = (lt24_state     != STATE_IDLE)            &
                            (lt24_state     != STATE_CMD_PARAM_WAIT)  &
                            (lt24_state     != STATE_RAMWR_REFR_WAIT) &
                            ~lt24_timer_done;

wire      lt24_timer_init = (lt24_timer_done                          &                                               // Init if counter reaches limit:
                           !((lt24_state    == STATE_CMD_PARAM_HI)    & lt24_cmd_has_param)  &                        //    -> if not moving to STATE_CMD_PARAM_WAIT
                           !((lt24_state    == STATE_CMD_PARAM_WAIT)))                       |                        //    -> if not in STATE_CMD_PARAM_WAIT
                            ((lt24_state    == STATE_CMD_PARAM_WAIT)  & (lt24_cmd_param_trig | ~lt24_cmd_has_param)); // Init when leaving the STATE_CMD_PARAM_WAIT state

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)              lt24_timer <= 4'h0;
  else if (lt24_timer_init) lt24_timer <= 4'h0;
  else if (lt24_timer_run)  lt24_timer <= lt24_timer+4'h1;


//--------------------------------
// Pixel counter
//--------------------------------
reg [`SPIX_MSB:0] lt24_pixel_cnt;

wire              lt24_pixel_cnt_run  = (lt24_state==STATE_RAMWR_INIT_DATA_HI) |
                                        (lt24_state==STATE_RAMWR_REFR_DATA_HI);

wire              lt24_pixel_cnt_done = (lt24_pixel_cnt==1) | (lt24_pixel_cnt==0);

wire              lt24_pixel_cnt_init = (lt24_state==STATE_RAMWR_INIT_CMD_HI) |
                                        (lt24_state==STATE_RAMWR_REFR_CMD_HI) |
                                        (lt24_pixel_cnt_done & lt24_pixel_cnt_run);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                      lt24_pixel_cnt <= {`SPIX_MSB+1{1'h0}};
  else if (lt24_timer_init)
    begin
       if (lt24_pixel_cnt_init)     lt24_pixel_cnt <= screen_display_size_i;
       else if (lt24_pixel_cnt_run) lt24_pixel_cnt <= lt24_pixel_cnt-{{`SPIX_MSB{1'h0}},1'b1};
    end


//--------------------------------
// States Transitions
//--------------------------------
always @(lt24_state or lt24_cmd_dfill_trig or lt24_cmd_param_trig or refresh_trigger or lt24_cfg_refr_sync_en or status_gts_match or screen_refresh_data_request_o or lt24_cmd_has_param or lt24_timer_done or lt24_pixel_cnt_done)
    case(lt24_state)
      STATE_IDLE               :  lt24_state_nxt =  lt24_cmd_dfill_trig           ? STATE_RAMWR_INIT_CMD_LO  :
                                                    refresh_trigger               ?
                                                   (lt24_cfg_refr_sync_en         ? STATE_SCANLINE_CMD_LO    : STATE_RAMWR_REFR_CMD_LO) :
                                                    lt24_cmd_param_trig           ? STATE_CMD_LO             : STATE_IDLE               ;

      // GENERIC COMMANDS
      STATE_CMD_LO             :  lt24_state_nxt = ~lt24_timer_done               ? STATE_CMD_LO             : STATE_CMD_HI             ;
      STATE_CMD_HI             :  lt24_state_nxt = ~lt24_timer_done               ? STATE_CMD_HI             :
                                                    lt24_cmd_has_param            ? STATE_CMD_PARAM_LO       : STATE_IDLE               ;

      STATE_CMD_PARAM_LO       :  lt24_state_nxt = ~lt24_timer_done               ? STATE_CMD_PARAM_LO       : STATE_CMD_PARAM_HI       ;
      STATE_CMD_PARAM_HI       :  lt24_state_nxt = ~lt24_timer_done               ? STATE_CMD_PARAM_HI       :
                                                    lt24_cmd_has_param            ? STATE_CMD_PARAM_WAIT     : STATE_IDLE               ;

      STATE_CMD_PARAM_WAIT     :  lt24_state_nxt =  lt24_cmd_param_trig           ? STATE_CMD_PARAM_LO       :
                                                    lt24_cmd_has_param            ? STATE_CMD_PARAM_WAIT     : STATE_IDLE               ;

      // MEMORY INITIALIZATION
      STATE_RAMWR_INIT_CMD_LO  :  lt24_state_nxt = ~lt24_timer_done               ? STATE_RAMWR_INIT_CMD_LO  : STATE_RAMWR_INIT_CMD_HI  ;
      STATE_RAMWR_INIT_CMD_HI  :  lt24_state_nxt = ~lt24_timer_done               ? STATE_RAMWR_INIT_CMD_HI  : STATE_RAMWR_INIT_DATA_LO ;

      STATE_RAMWR_INIT_DATA_LO :  lt24_state_nxt = ~lt24_timer_done               ? STATE_RAMWR_INIT_DATA_LO : STATE_RAMWR_INIT_DATA_HI ;
      STATE_RAMWR_INIT_DATA_HI :  lt24_state_nxt =  lt24_timer_done               &
                                                    lt24_pixel_cnt_done           ? STATE_IDLE               :
                                                   ~lt24_timer_done               ? STATE_RAMWR_INIT_DATA_HI : STATE_RAMWR_INIT_DATA_LO ;

      // WAIT FOR RIGHT SCANLINE BEFORE REFRESH
      STATE_SCANLINE_CMD_LO    :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_CMD_LO    : STATE_SCANLINE_CMD_HI    ;
      STATE_SCANLINE_CMD_HI    :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_CMD_HI    : STATE_SCANLINE_DUMMY_LO  ;

      STATE_SCANLINE_DUMMY_LO  :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_DUMMY_LO  : STATE_SCANLINE_DUMMY_HI  ;
      STATE_SCANLINE_DUMMY_HI  :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_DUMMY_HI  : STATE_SCANLINE_GTS1_LO   ;

      STATE_SCANLINE_GTS1_LO   :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_GTS1_LO   : STATE_SCANLINE_GTS1_HI   ;
      STATE_SCANLINE_GTS1_HI   :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_GTS1_HI   : STATE_SCANLINE_GTS2_LO   ;

      STATE_SCANLINE_GTS2_LO   :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_GTS2_LO   : STATE_SCANLINE_GTS2_HI   ;
      STATE_SCANLINE_GTS2_HI   :  lt24_state_nxt = ~lt24_timer_done               ? STATE_SCANLINE_GTS2_HI   :
                                                   (status_gts_match |
                                                  ~lt24_cfg_refr_sync_en)         ? STATE_RAMWR_REFR_CMD_LO  : STATE_SCANLINE_CMD_LO    ;

      // FRAME REFRESH
      STATE_RAMWR_REFR_CMD_LO  :  lt24_state_nxt = ~lt24_timer_done               ? STATE_RAMWR_REFR_CMD_LO  : STATE_RAMWR_REFR_CMD_HI  ;
      STATE_RAMWR_REFR_CMD_HI  :  lt24_state_nxt = ~lt24_timer_done               ? STATE_RAMWR_REFR_CMD_HI  :
                                                   ~screen_refresh_data_request_o ? STATE_RAMWR_REFR_DATA_LO : STATE_RAMWR_REFR_WAIT    ;

      STATE_RAMWR_REFR_WAIT    :  lt24_state_nxt = ~screen_refresh_data_request_o ? STATE_RAMWR_REFR_DATA_LO : STATE_RAMWR_REFR_WAIT    ;

      STATE_RAMWR_REFR_DATA_LO :  lt24_state_nxt = ~lt24_timer_done               ? STATE_RAMWR_REFR_DATA_LO : STATE_RAMWR_REFR_DATA_HI ;
      STATE_RAMWR_REFR_DATA_HI :  lt24_state_nxt =  lt24_timer_done    &
                                                    lt24_pixel_cnt_done           ? STATE_IDLE               :
                                                   ~lt24_timer_done               ? STATE_RAMWR_REFR_DATA_HI :
                                                   ~screen_refresh_data_request_o ? STATE_RAMWR_REFR_DATA_LO : STATE_RAMWR_REFR_WAIT    ;

    // pragma coverage off
      default                  :  lt24_state_nxt =  STATE_IDLE;
    // pragma coverage on
    endcase

// State machine
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_state  <= STATE_IDLE;
  else         lt24_state  <= lt24_state_nxt;


// Output status
assign   lt24_status[0]           =  (lt24_state != STATE_IDLE);                                                            // LT24 FSM BUSY

assign   lt24_status[1]           =  (lt24_state == STATE_CMD_PARAM_WAIT);                                                  // LT24 Waits for command parameter

assign   lt24_status[2]           =  (lt24_state == STATE_RAMWR_REFR_CMD_LO)  | (lt24_state == STATE_RAMWR_REFR_CMD_HI)  |  // LT24 REFRESH BUSY
                                     (lt24_state == STATE_RAMWR_REFR_DATA_LO) | (lt24_state == STATE_RAMWR_REFR_DATA_HI) |
                                     (lt24_state == STATE_RAMWR_REFR_WAIT);

assign   lt24_status[3]           =  (lt24_state == STATE_SCANLINE_CMD_LO)    | (lt24_state == STATE_SCANLINE_CMD_HI)    |  // LT24 WAIT FOR SCANLINE
                                     (lt24_state == STATE_SCANLINE_DUMMY_LO)  | (lt24_state == STATE_SCANLINE_DUMMY_HI)  |
                                     (lt24_state == STATE_SCANLINE_GTS1_LO)   | (lt24_state == STATE_SCANLINE_GTS1_HI)   |
                                     (lt24_state == STATE_SCANLINE_GTS2_LO)   | (lt24_state == STATE_SCANLINE_GTS2_HI);

assign   lt24_status[4]           =  (lt24_state == STATE_RAMWR_INIT_CMD_LO)  | (lt24_state == STATE_RAMWR_INIT_CMD_HI)  |  // LT24 INIT BUSY
                                     (lt24_state == STATE_RAMWR_INIT_DATA_LO) | (lt24_state == STATE_RAMWR_INIT_DATA_HI);

assign   screen_refresh_active_o  =  lt24_status[2];


// Refresh data request
wire     refresh_data_request_set = ((lt24_state == STATE_RAMWR_REFR_CMD_LO)  & (lt24_state_nxt == STATE_RAMWR_REFR_CMD_HI))  |
                                    ((lt24_state == STATE_RAMWR_REFR_DATA_LO) & (lt24_state_nxt == STATE_RAMWR_REFR_DATA_HI)) |
                                     (lt24_state == STATE_RAMWR_REFR_WAIT);
wire     refresh_data_request_clr = screen_refresh_data_ready_i;
reg      refresh_data_request_reg;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) refresh_data_request_reg <= 1'b0;
  else         refresh_data_request_reg <= refresh_data_request_clr ? 1'b0 :
                                           refresh_data_request_set ? 1'b1 : refresh_data_request_reg;

assign   screen_refresh_data_request_o  = refresh_data_request_reg & ~screen_refresh_data_ready_i;

assign   lt24_start_evt                 =  (lt24_state_nxt != STATE_IDLE) & (lt24_state     == STATE_IDLE);
assign   lt24_done_evt                  =  (lt24_state     != STATE_IDLE) & (lt24_state_nxt == STATE_IDLE);


//============================================================================
// 4) LT24 CONTROLLER OUTPUT ASSIGNMENT
//============================================================================

// LT24 Chip select (active low)
reg  lt24_cs_n_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_cs_n_o <= 1'b1;
  else         lt24_cs_n_o <= (lt24_state_nxt==STATE_IDLE);

// Command (0) or Data (1)
reg  lt24_rs_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_rs_o   <= 1'b1;
  else         lt24_rs_o   <= ~((lt24_state_nxt==STATE_CMD_LO)            | (lt24_state_nxt==STATE_CMD_HI)            |
                                (lt24_state_nxt==STATE_SCANLINE_CMD_LO)   | (lt24_state_nxt==STATE_SCANLINE_CMD_HI)   |
                                (lt24_state_nxt==STATE_RAMWR_INIT_CMD_LO) | (lt24_state_nxt==STATE_RAMWR_INIT_CMD_HI) |
                                (lt24_state_nxt==STATE_RAMWR_REFR_CMD_LO) | (lt24_state_nxt==STATE_RAMWR_REFR_CMD_HI));

// LT24 Write strobe (Active low)
reg  lt24_wr_n_o;

wire lt24_wr_n_clr = (lt24_state_nxt==STATE_CMD_LO)            | (lt24_state_nxt==STATE_CMD_PARAM_LO)       | (lt24_state_nxt==STATE_SCANLINE_CMD_LO) |
                     (lt24_state_nxt==STATE_RAMWR_INIT_CMD_LO) | (lt24_state_nxt==STATE_RAMWR_INIT_DATA_LO) |
                     (lt24_state_nxt==STATE_RAMWR_REFR_CMD_LO) | (lt24_state_nxt==STATE_RAMWR_REFR_DATA_LO);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)              lt24_wr_n_o <= 1'b1;
  else if (lt24_wr_n_clr)   lt24_wr_n_o <= 1'b0;
  else                      lt24_wr_n_o <= 1'b1;

// LT24 Read strobe (active low)
reg  lt24_rd_n_o;

wire lt24_rd_n_clr = (lt24_state_nxt==STATE_SCANLINE_DUMMY_LO) |
                     (lt24_state_nxt==STATE_SCANLINE_GTS1_LO)  | (lt24_state_nxt==STATE_SCANLINE_GTS2_LO);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)              lt24_rd_n_o <= 1'b1;
  else if (lt24_rd_n_clr)   lt24_rd_n_o <= 1'b0;
  else                      lt24_rd_n_o <= 1'b1;


// LT24 Data
reg [15:0] lt24_d_nxt;
always @(lt24_state_nxt or lt24_cmd_val or lt24_cmd_param_val or lt24_d_o or lt24_cmd_dfill or screen_refresh_data_i)
  case(lt24_state_nxt)
    STATE_IDLE               : lt24_d_nxt = 16'h0000;

    STATE_CMD_LO,
    STATE_CMD_HI             : lt24_d_nxt = {8'h00, lt24_cmd_val};
    STATE_CMD_PARAM_LO,
    STATE_CMD_PARAM_HI       : lt24_d_nxt = lt24_cmd_param_val;
    STATE_CMD_PARAM_WAIT     : lt24_d_nxt = lt24_d_o;

    STATE_RAMWR_INIT_CMD_LO,
    STATE_RAMWR_INIT_CMD_HI  : lt24_d_nxt = 16'h002C;
    STATE_RAMWR_INIT_DATA_LO,
    STATE_RAMWR_INIT_DATA_HI : lt24_d_nxt = lt24_cmd_dfill;

    STATE_SCANLINE_CMD_LO,
    STATE_SCANLINE_CMD_HI    : lt24_d_nxt = 16'h0045;

    STATE_RAMWR_REFR_CMD_LO,
    STATE_RAMWR_REFR_CMD_HI  : lt24_d_nxt = 16'h002C;
    STATE_RAMWR_REFR_DATA_LO : lt24_d_nxt = screen_refresh_data_i;
    STATE_RAMWR_REFR_DATA_HI : lt24_d_nxt = lt24_d_o;
    STATE_RAMWR_REFR_WAIT    : lt24_d_nxt = lt24_d_o;

    // pragma coverage off
    default                  : lt24_d_nxt = 16'h0000;
    // pragma coverage on
  endcase

reg [15:0] lt24_d_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_d_o <= 16'h0000;
  else         lt24_d_o <= lt24_d_nxt;

// Output enable
reg lt24_d_en_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_d_en_o <= 1'h0;       // Don't drive output during reset
  else         lt24_d_en_o <= ~((lt24_state_nxt == STATE_SCANLINE_DUMMY_LO) |
                                (lt24_state_nxt == STATE_SCANLINE_DUMMY_HI) |
                                (lt24_state_nxt == STATE_SCANLINE_GTS1_LO ) |
                                (lt24_state_nxt == STATE_SCANLINE_GTS1_HI ) |
                                (lt24_state_nxt == STATE_SCANLINE_GTS2_LO ) |
                                (lt24_state_nxt == STATE_SCANLINE_GTS2_HI ));


//============================================================================
// 5) LT24 GTS VALUE (i.e. CURRENT SCAN LINE)
//============================================================================

reg  [1:0] status_gts_msb;
wire       status_gts_msb_wr  = ((lt24_state == STATE_SCANLINE_GTS1_LO) & (lt24_state_nxt == STATE_SCANLINE_GTS1_HI));
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                status_gts_msb <= 2'h0;
  else if (status_gts_msb_wr) status_gts_msb <= lt24_d_i[1:0];

reg  [7:0] status_gts_lsb;
wire       status_gts_lsb_wr  = ((lt24_state == STATE_SCANLINE_GTS2_LO) & (lt24_state_nxt == STATE_SCANLINE_GTS2_HI));
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                status_gts_lsb <= 8'h00;
  else if (status_gts_lsb_wr) status_gts_lsb <= lt24_d_i[7:0];

wire [7:0] unused_lt24_d_15_8 = lt24_d_i[15:8];
wire [9:0] status_gts         = {status_gts_msb, status_gts_lsb};

assign     status_gts_match   = (status_gts == lt24_cfg_refr_sync_val);


//============================================================================
// 6) REFRESH TIMER & TRIGGER
//============================================================================

// Refresh Timer
reg [23:0] refresh_timer;
wire       refresh_timer_disable = (lt24_cfg_refr==12'h000) | ~lt24_cmd_refresh;
wire       refresh_timer_done    = (refresh_timer[23:12]==lt24_cfg_refr);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                    refresh_timer <= 24'h000000;
  else if (refresh_timer_disable) refresh_timer <= 24'h000000;
  else if (refresh_timer_done)    refresh_timer <= 24'h000000;
  else                            refresh_timer <= refresh_timer + 24'h1;

// Refresh Trigger
wire       refresh_trigger_set = (lt24_state==STATE_IDLE) & lt24_cmd_refresh & (refresh_timer==24'h000000);
wire       refresh_trigger_clr = (lt24_state==STATE_RAMWR_REFR_CMD_LO);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                  refresh_trigger <= 1'b0;
  else if (refresh_trigger_set) refresh_trigger <= 1'b1;
  else if (refresh_trigger_clr) refresh_trigger <= 1'b0;


endmodule // ogfx_if_lt24

`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_undefines.v"
`endif
