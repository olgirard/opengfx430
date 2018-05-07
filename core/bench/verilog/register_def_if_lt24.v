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
// *File Name: register_def_lt24.v
//
// *Module Description:
//                      LT24 interface register and field definition
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 205 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2015-07-15 22:59:52 +0200 (Wed, 15 Jul 2015) $
//----------------------------------------------------------------------------

//----------------------------------------------------------
// LT24 INTERFACE REGISTERS
//----------------------------------------------------------
`define  R_LT24_CFG                    16'h0280
`define  R_LT24_REFRESH                16'h0282
`define  R_LT24_REFRESH_SYNC           16'h0284
`define  R_LT24_CMD                    16'h0286
`define  R_LT24_CMD_PARAM              16'h0288
`define  R_LT24_CMD_DFILL              16'h028A
`define  R_LT24_STATUS                 16'h028C
`define  R_LT24_IRQ                    16'h028E


//----------------------------------------------------------
// LT24 INTERFACE REGISTER FIELD MAPPING
//----------------------------------------------------------

// GFX_CTRL Register

// LT24_CFG Register
`define  F_LT24_ON                     `R_LT24_CFG          ,  0 , 16'h0001
`define  F_LT24_RESET                  `R_LT24_CFG          ,  1 , 16'h0002
`define  F_LT24_CLK                    `R_LT24_CFG          ,  4 , 16'h0070
`define  F_LT24_IRQ_EN_REFR_START      `R_LT24_CFG          , 14 , 16'h4000
`define  F_LT24_IRQ_EN_REFR_DONE       `R_LT24_CFG          , 15 , 16'h8000

// LT24_REFRESH Register
`define  F_LT24_REFR_START             `R_LT24_REFRESH      ,  0 , 16'h0001
`define  F_LT24_REFR                   `R_LT24_REFRESH      ,  4 , 16'hFFF0

// LT24_REFRESH_SYNC Register
`define  F_LT24_REFR_SYNC              `R_LT24_REFRESH_SYNC ,  0 , 16'h03FF
`define  F_LT24_REFR_SYNC_EN           `R_LT24_REFRESH_SYNC , 15 , 16'h8000

// LT24_CMD Register
`define  F_LT24_CMD_MSK                `R_LT24_CMD          ,  0 , 16'h00FF
`define  F_LT24_CMD_HAS_PARAM          `R_LT24_CMD          ,  8 , 16'h0100

// LT24_STATUS Register
`define  F_LT24_STATUS_FSM_BUSY        `R_LT24_STATUS       ,  0 , 16'h0001
`define  F_LT24_STATUS_WAIT_PARAM      `R_LT24_STATUS       ,  1 , 16'h0002
`define  F_LT24_STATUS_REFRESH_BUSY    `R_LT24_STATUS       ,  2 , 16'h0004
`define  F_LT24_STATUS_REFRESH_WAIT    `R_LT24_STATUS       ,  3 , 16'h0008
`define  F_LT24_STATUS_DFILL_BUSY      `R_LT24_STATUS       ,  4 , 16'h0010

// GFX_IRQ Register
`define  F_LT24_IRQ_REFRESH_DONE       `R_LT24_IRQ          , 15 , 16'h8000
`define  F_LT24_IRQ_REFRESH_START      `R_LT24_IRQ          , 14 , 16'h4000


//----------------------------------------------------------
// USEFULL VALUES
//----------------------------------------------------------

`define  V_LT24_CLK_DIV1               16'h0000
`define  V_LT24_CLK_DIV2               16'h0001
`define  V_LT24_CLK_DIV3               16'h0002
`define  V_LT24_CLK_DIV4               16'h0003
`define  V_LT24_CLK_DIV5               16'h0004
`define  V_LT24_CLK_DIV6               16'h0005
`define  V_LT24_CLK_DIV7               16'h0006
`define  V_LT24_CLK_DIV8               16'h0007

`define  V_LT24_REFR_MANUAL            16'h0000
`define  V_LT24_REFR_21_FPS            (((48000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_24_FPS            (((40000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_31_FPS            (((32000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_42_FPS            (((24000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_62_FPS            (((16000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_125_FPS           ((( 8000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_250_FPS           ((( 4000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_500_FPS           ((( 2000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_1000_FPS          ((( 1000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_48MS              (((48000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_40MS              (((40000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_32MS              (((32000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_24MS              (((24000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_16MS              (((16000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_8MS               ((( 8000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_4MS               ((( 4000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_2MS               ((( 2000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_1MS               ((( 1000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
