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
// *File Name: peripheral_tasks.v
//
// *Module Description:
//                      generic tasks for using the peripheral interface
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev$
// $LastChangedBy$
// $LastChangedDate$
//----------------------------------------------------------------------------

//============================================================================
// Peripheral Register Write access
//============================================================================

//---------------------
// Generic write task
//---------------------
task reg_write;
   input  [15:0] addr;   // Address
   input  [15:0] data;   // Data
   input         size;   // Access size (0: 8-bit / 1: 16-bit)

   begin
      #1;
      per_addr   = addr[15:1];
      per_en     = 1'b1;
      per_we     = size    ? 2'b11  :
                   addr[0] ? 2'b10  :  2'b01;
      per_din    = data;
      @(posedge mclk);
      #1;
      per_en     = 1'b0;
      per_we     = 2'b00;
      per_addr   = 15'h0000;
      per_din    = 16'h0000;
   end
endtask

//---------------------
// Write 16b task
//---------------------
task reg_write_16b;
   input  [15:0] addr;   // Address
   input  [15:0] data;   // Data

   begin
      reg_write(addr, data, 1'b1);
   end
endtask

//---------------------
// Write 8b task
//---------------------
task reg_write_8b;
   input  [15:0] addr;   // Address
   input   [7:0] data;   // Data

   begin
      if (addr[0]) reg_write(addr, {data,  8'h00}, 1'b0);
      else         reg_write(addr, {8'h00, data }, 1'b0);
   end
endtask


//============================================================================
// Peripheral Register Read access
//============================================================================
reg    [15:0] reg_read_data;

//---------------------
// Generic read task
//---------------------
task reg_read;
   input  [15:0] addr;   // Address
   input  [15:0] data;   // Data to check against
   input         check;  // Enable/disable read value check
   input         size;   // Access size (0: 8-bit / 1: 16-bit)

   begin
      // Perform read transfer
      #1;
      per_addr = addr[15:1];
      per_en   = 1'b1;
      per_we   = 2'b00;
      per_din  = 16'h0000;
      @(posedge mclk);

      // Read check
      reg_read_data  =  size    ? per_dout :
                       (addr[0] ? {8'h00, per_dout[15:8]} : {8'h00, per_dout[7:0]});

      if ((data !== reg_read_data) & ~puc_rst & check)
        begin
          $display("ERROR: Peripheral read check -- address: 0x%h -- read: 0x%h / expected: 0x%h (%t ns)", addr, reg_read_data, data, $time);
          error = error+1;
        end

      #1;
      per_en   = 1'b0;
      per_addr = 15'h0000;
   end
endtask

//---------------------
// Read 16b task
//---------------------
task reg_read_16b;
   input  [15:0] addr;   // Address
   input  [15:0] data;   // Data to check against

   begin
      reg_read(addr, data, 1'b1, 1'b1);
   end
endtask

//---------------------
// Read 8b task
//---------------------
task reg_read_8b;
   input  [15:0] addr;   // Address
   input   [7:0] data;   // Data to check against

   begin
      if (addr[0]) reg_read(addr, {data,  8'h00}, 1'b1, 1'b0);
      else         reg_read(addr, {8'h00, data }, 1'b1, 1'b0);
   end
endtask

//--------------------------------
// Read 16b value task (no check)
//--------------------------------
task reg_read_val_16b;
   input  [15:0] addr;   // Address

   begin
      reg_read(addr, 16'h0000, 1'b0, 1'b1);
   end
endtask


//============================================================================
// Peripheral Field Write access
//============================================================================

//---------------------
// Read 8b task
//---------------------
task field_write;
   input  [15:0] reg_addr;       // Register Address
   input  [31:0] field_offset;   // Bit offset of the field
   input  [15:0] field_mask;     // Field mask
   input  [15:0] field_data;     // Data

   reg    [15:0] tmp_data1;
   reg    [15:0] tmp_data2;
   reg    [15:0] tmp_data3;
   begin
      reg_read_val_16b(reg_addr);
      tmp_data1 = (reg_read_data & ~field_mask);
      tmp_data2 = ((field_data<<field_offset) & field_mask);
      tmp_data3 = tmp_data1 | tmp_data2;
      reg_write_16b(reg_addr, tmp_data3);
   end
endtask


















