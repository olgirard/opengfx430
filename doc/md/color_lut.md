<a name="top"></a>
# Color Look-Up-Table

#### Table of content

*   [1. Introduction](#1_introduction)
*   [2. Hardware Color Look-Up-Table](#2_hardware_lut)
*   [3. Software Color Look-Up-Table](#3_software_lut)
*   [4. Registers](#4_registers)
    *   [4.1 LUT_CFG](#4_1_LUT_CFG)
    *   [4.2 LUT_RAM_ADDR](#4_2_LUT_RAM_ADDR)
    *   [4.3 LUT_RAM_DATA](#4_3_LUT_RAM_DATA)

<a name="1_introduction"></a>
## 1. Introduction

When the controller is configured to 1, 2, 4 or 8-bpp graphic mode through the [GFX_CTRL.GFX_MODE](https://github.com/olgirard/opengfx430/blob/master/doc/md/global_control.md#2_1_GFX_CTRL) register, the individual pixel values of the frame buffer are mapped to a native 16 bit color with a hardware or software look-up-table.
Depending on the graphic mode, 2, 4, 16 or 256 look-up-table entries are used:

| Graphic-mode | Number of used LUT entries |
|--------------|----------------------------|
|    1 bpp     |              2             |
|    2 bpp     |              4             |
|    4 bpp     |             16             |
|    8 bpp     |            256             |
|   16 bpp     |       not applicable       |


The openGFX430 includes a hard-coded color look-up-table but can also interface with a LUT memory if the RTL is configured accordingly, thus allowing software customization of the LUTs: 

~~~~
//-----------------------------------------------------  
// LUT Configuration  
//-----------------------------------------------------  
`define WITH_PROGRAMMABLE_LUT  
`define WITH_EXTRA_LUT_BANK
~~~~

Note that it is also possible to include an extra programmable LUT bank, allowing to dynamically switch between two different color LUT banks.


<a name="2_hardware_lut"></a>
## 2. Hardware Color Look-Up-Table

The hard coded color LUT is enabled when the LUT_CFG.SW_LUT_EN bit is cleared.
It converts each pixel value in the frame buffer according to the selected graphic mode as following:

* **8 bit-per-pixel:**

In this mode, the hardware LUT implements the [8-bit truecolor](https://en.wikipedia.org/wiki/8-bit_color) RGB mapping (i.e. 3 bits for red, 3 bits for green and 2 bits for blue).


| Pixel value  |       R[4:0]     |       G[5:0]      |     B[4:0]      |
|--------------|------------------|-------------------|-----------------|
|  Data[7:0]   |  Data[7,6,5,5,5] | Data[4,3,2,2,2,2] | Data[1,0,0,0,0] |

<img src="https://upload.wikimedia.org/wikipedia/commons/9/93/256colour.png" alt="8-bit truecolor"  style="width:70%;">
 

* **4 bit-per-pixel:**

The hardware LUT implements the regular 16 colors [CGA](https://en.wikipedia.org/wiki/List_of_8-bit_computer_hardware_palettes#CGA) palette.

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>0000</td><td>Black        </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>0001</td><td>Blue         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_1_blue.png"          alt="Blue         " style="width:40%;"></td><td>0x0015</td><td>00000</td><td>000000</td><td>10101</td></tr>
    <tr><td>0010</td><td>Green        </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_2_green.png"         alt="Green        " style="width:40%;"></td><td>0x0560</td><td>00000</td><td>101011</td><td>00000</td></tr>
    <tr><td>0011</td><td>Cyan         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_3_cyan.png"          alt="Cyan         " style="width:40%;"></td><td>0x0575</td><td>00000</td><td>101011</td><td>10101</td></tr>
    <tr><td>0100</td><td>Red          </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_4_red.png"           alt="Red          " style="width:40%;"></td><td>0xA800</td><td>10101</td><td>000000</td><td>00000</td></tr>
    <tr><td>0101</td><td>Magenta      </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_5_magenta.png"       alt="Magenta      " style="width:40%;"></td><td>0xA815</td><td>10101</td><td>000000</td><td>10101</td></tr>
    <tr><td>0110</td><td>Brown        </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_6_brown.png"         alt="Brown        " style="width:40%;"></td><td>0xAAA0</td><td>10101</td><td>010101</td><td>00000</td></tr>
    <tr><td>0111</td><td>Light Gray   </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_7_light_gray.png"    alt="Light Gray   " style="width:40%;"></td><td>0xAD75</td><td>10101</td><td>101011</td><td>10101</td></tr>
    <tr><td>1000</td><td>Gray         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_8_gray.png"          alt="Gray         " style="width:40%;"></td><td>0x5AAB</td><td>01011</td><td>010101</td><td>01011</td></tr>
    <tr><td>1001</td><td>Light Blue   </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_9_light_blue.png"    alt="Light Blue   " style="width:40%;"></td><td>0x5ABF</td><td>01011</td><td>010101</td><td>11111</td></tr>
    <tr><td>1010</td><td>Light Green  </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_A_light_green.png"   alt="Light Green  " style="width:40%;"></td><td>0x5FEB</td><td>01011</td><td>111111</td><td>01011</td></tr>
    <tr><td>1011</td><td>Light Cyan   </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_B_light_cyan.png"    alt="Light Cyan   " style="width:40%;"></td><td>0x5FFF</td><td>01011</td><td>111111</td><td>11111</td></tr>
    <tr><td>1100</td><td>Light Red    </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_C_light_red.png"     alt="Light Red    " style="width:40%;"></td><td>0xFAAB</td><td>11111</td><td>010101</td><td>01011</td></tr>
    <tr><td>1101</td><td>Light Magenta</td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_D_light_magenta.png" alt="Light Magenta" style="width:40%;"></td><td>0xFABF</td><td>11111</td><td>010101</td><td>11111</td></tr>
    <tr><td>1110</td><td>Yellow       </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_E_yellow.png"        alt="Yellow       " style="width:40%;"></td><td>0xFFEB</td><td>11111</td><td>111111</td><td>01011</td></tr>
    <tr><td>1111</td><td>White        </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_F_white.png"         alt="White        " style="width:40%;"></td><td>0xFFFF</td><td>11111</td><td>111111</td><td>11111</td></tr>
  </tbody>
</table>


* **2 bit-per-pixel:**

The hardware LUT implements all 4 colors [CGA](https://en.wikipedia.org/wiki/List_of_8-bit_computer_hardware_palettes#CGA) palettes.
Each palette can be selected with the LUT_CFG.HW_LUT_PALETTE_SEL register.
It is to be noted that the default color (Black) can be modified regardless of the selected palette using the LUT_CFG.HW_LUT_BGCOLOR register.

***Palette #0, high-intensity (LUT_CFG.HW_LUT_PALETTE_SEL=0):***

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>00</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>01</td><td>Light Green        </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_A_light_green.png"   alt="Light Green  " style="width:40%;"></td><td>0x5FEB</td><td>01011</td><td>111111</td><td>01011</td></tr>
    <tr><td>10</td><td>Light Red          </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_C_light_red.png"     alt="Light Red    " style="width:40%;"></td><td>0xFAAB</td><td>11111</td><td>010101</td><td>01011</td></tr>
    <tr><td>11</td><td>Yellow             </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_E_yellow.png"        alt="Yellow       " style="width:40%;"></td><td>0xFFEB</td><td>11111</td><td>111111</td><td>01011</td></tr>
  </tbody>
</table>

***Palette #0, low-intensity (LUT_CFG.HW_LUT_PALETTE_SEL=1):***

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>00</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>01</td><td>Green              </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_2_green.png"         alt="Green        " style="width:40%;"></td><td>0x0560</td><td>00000</td><td>101011</td><td>00000</td></tr>
    <tr><td>10</td><td>Red                </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_4_red.png"           alt="Red          " style="width:40%;"></td><td>0xA800</td><td>10101</td><td>000000</td><td>00000</td></tr>
    <tr><td>11</td><td>Brown              </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_6_brown.png"         alt="Brown        " style="width:40%;"></td><td>0xAAA0</td><td>10101</td><td>010101</td><td>00000</td></tr>
  </tbody>
</table>

***Palette #1, high-intensity (LUT_CFG.HW_LUT_PALETTE_SEL=2):***

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>00</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>01</td><td>Light Cyan         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_B_light_cyan.png"    alt="Light Cyan   " style="width:40%;"></td><td>0x5FFF</td><td>01011</td><td>111111</td><td>11111</td></tr>
    <tr><td>10</td><td>Light Magenta      </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_D_light_magenta.png" alt="Light Magenta" style="width:40%;"></td><td>0xFABF</td><td>11111</td><td>010101</td><td>11111</td></tr>
    <tr><td>11</td><td>White              </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_F_white.png"         alt="White        " style="width:40%;"></td><td>0xFFFF</td><td>11111</td><td>111111</td><td>11111</td></tr>
  </tbody>
</table>

***Palette #1, low-intensity (LUT_CFG.HW_LUT_PALETTE_SEL=3):***

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>00</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>01</td><td>Cyan               </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_3_cyan.png"          alt="Cyan         " style="width:40%;"></td><td>0x0575</td><td>00000</td><td>101011</td><td>10101</td></tr>
    <tr><td>10</td><td>Magenta            </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_5_magenta.png"       alt="Magenta      " style="width:40%;"></td><td>0xA815</td><td>10101</td><td>000000</td><td>10101</td></tr>
    <tr><td>11</td><td>Light Gray         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_7_light_gray.png"    alt="Light Gray   " style="width:40%;"></td><td>0xAD75</td><td>10101</td><td>101011</td><td>10101</td></tr>
  </tbody>
</table>

***Palette #2, high-intensity (LUT_CFG.HW_LUT_PALETTE_SEL=4):***

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>00</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>01</td><td>Light Cyan         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_B_light_cyan.png"    alt="Light Cyan   " style="width:40%;"></td><td>0x5FFF</td><td>01011</td><td>111111</td><td>11111</td></tr>
    <tr><td>10</td><td>Light Red          </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_C_light_red.png"     alt="Light Red    " style="width:40%;"></td><td>0xFAAB</td><td>11111</td><td>010101</td><td>01011</td></tr>
    <tr><td>11</td><td>White              </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_F_white.png"         alt="White        " style="width:40%;"></td><td>0xFFFF</td><td>11111</td><td>111111</td><td>11111</td></tr>
  </tbody>
</table>

***Palette #2, low-intensity (LUT_CFG.HW_LUT_PALETTE_SEL=5):***

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>00</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>01</td><td>Cyan               </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_3_cyan.png"          alt="Cyan         " style="width:40%;"></td><td>0x0575</td><td>00000</td><td>101011</td><td>10101</td></tr>
    <tr><td>10</td><td>Red                </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_4_red.png"           alt="Red          " style="width:40%;"></td><td>0xA800</td><td>10101</td><td>000000</td><td>00000</td></tr>
    <tr><td>11</td><td>Light Gray         </td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_7_light_gray.png"    alt="Light Gray   " style="width:40%;"></td><td>0xAD75</td><td>10101</td><td>101011</td><td>10101</td></tr>
  </tbody>
</table>

* **1 bit-per-pixel:**

By default, the hardware LUT selects **Black** and **White** as the standard two colors.
However, it is possible to modify them with any of the 16 standard CGA color using:
        - LUT_CFG.HW_LUT_BGCOLOR to replace Black.
        - LUT_CFG.HW_LUT_FGCOLOR to replace White.

<table>
  <tbody>
    <tr><td><b>Pixel value</b></td><td colspan="2"><b>Color</b></td><td><b>RGB[15:0]</b></td><td><b>R[4:0]</b></td><td><b>G[5:0]</b></td><td><b>B[4:0]</b></td></tr>
    <tr><td>0</td><td>Black <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_0_black.png"         alt="Black        " style="width:40%;"></td><td>0x0000</td><td>00000</td><td>000000</td><td>00000</td></tr>
    <tr><td>1</td><td>White <i>(dflt)</i></td><td align="center"><img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/lut_F_white.png"         alt="White        " style="width:40%;"></td><td>0xFFFF</td><td>11111</td><td>111111</td><td>11111</td></tr>
  </tbody>
</table>

<a name="3_software_lut"></a>
## 3. Software color Look-Up-Table

The software color LUT is activated when the LUT_CFG.SW_LUT_EN bit is set.
When enabled, the LUT Memory is used to replaces each pixel value from the frame buffer with the 16-bit color value stored at the corresponding index of the LUT-RAM memory.

The following diagram shows how the colors are mapped in the LUT-RAM depending on the selected graphic mode:
![LUT Memory mapping](https://github.com/olgirard/opengfx430/blob/master/doc/images/lut_memory.png?raw=true "LUT Memory mapping")  

The processor can indiredtly access the LUT-RAM through the LUT_RAM_ADDR and LUT_RAM_DATA registers.
In order to simplify and speed-up software procedures, the LUT_RAM_ADDR register is automatically incremented when accessing the LUT_RAM_DATA register:

- after each WRITE access.
- after each READ access if the LUT_CFG.SW_LUT_RMW_MODE is cleared.

As a consequence, a write procedure to update the LUT memory would look as following:

~~~~
LUT_RAM_ADDR = 0x0090;       // Initialize Address to 0x90 (144)
LUT_RAM_DATA = 0xFEED;       // Write at address 0x90
LUT_RAM_DATA = 0xDEAD;       // Write at address 0x91
LUT_RAM_DATA = 0xBEEF;       // Write at address 0x92
LUT_RAM_DATA = 0xCAFE;       // Write at address 0x93
...
~~~~

Likewise, the procedure to read the content of the LUT memory would look as following:

~~~~
LUT_RAM_ADDR = 0x0090;       // Initialize Address to 0x90 (144)
my_data[0]   = LUT_RAM_DATA; // Read data from address 0x90
my_data[1]   = LUT_RAM_DATA; // Read data from address 0x91
my_data[2]   = LUT_RAM_DATA; // Read data from address 0x92
my_data[3]   = LUT_RAM_DATA; // Read data from address 0x93
...
~~~~


<a name="4_registers"></a>
## 4. Registers

<a name="4_1_LUT_CFG"></a>
### 4.1 LUT_CFG

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x30</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LUT Configuration</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=4  align="center" style="word-wrap:break-word;">HW_LUT_FGCOLOR</td>   <!-- 15 ... 12 -->
        <td colspan=4  align="center" style="word-wrap:break-word;">HW_LUT_BGCOLOR</td>   <!-- 11 ...  8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>                 <!--  7       -->
        <td colspan=3  align="center" style="word-wrap:break-word;">HW_LUT_PALETTE_SEL</td>   <!--  6 ... 4 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>                 <!--  3       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">SW_LUT_BANK_SEL</td>      <!--  2       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">SW_LUT_RMW_MODE</td>      <!--  1       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">SW_LUT_EN</td>            <!--  0       -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>HW_LUT_FGCOLOR     </b></td><td>Select foreground color for 1-BPP mode.<br>Default color is White (15).<br>
                                                       &emsp;&emsp;<code>n  = select from 16 standard CGA colors</code><br>
                                                       &emsp;&emsp;<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_16_colors.png" alt="16 CGA Colors" style="width:75%;"><br>
                                                       </td></tr>

    <tr><td valign="top">&#8226;&emsp;<b>HW_LUT_BGCOLOR     </b></td><td>Select background color for 1-BPP and 2-BPP modes.<br>Default color is Black (0).<br>
                                                       &emsp;&emsp;<code>n  = select from 16 standard CGA colors</code><br>
                                                       &emsp;&emsp;<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_16_colors.png" alt="16 CGA Colors" style="width:75%;"><br>
                                                       </td></tr>

    <tr><td valign="top">&#8226;&emsp;<b>HW_LUT_PALETTE_SEL </b></td><td>Hardware palette selection for 2-BPP graphic mode.<br>
                                                       &emsp;&emsp;<code>0  = Palette #0, high-intensity</code>
<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_4_colors_pal0_hi.png" alt="4 CGA Colors - palette #0 - high" style="width:15%;"><br>
                                                       &emsp;&emsp;<code>1  = Palette #0, low-intensity</code>
<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_4_colors_pal0_lo.png" alt="4 CGA Colors - palette #0 - low"  style="width:15%;"><br>
                                                       &emsp;&emsp;<code>2  = Palette #1, high-intensity</code>
<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_4_colors_pal1_hi.png" alt="4 CGA Colors - palette #1 - high" style="width:15%;"><br>
                                                       &emsp;&emsp;<code>3  = Palette #1, low-intensity</code>
<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_4_colors_pal1_lo.png" alt="4 CGA Colors - palette #1 - low"  style="width:15%;"><br>
                                                       &emsp;&emsp;<code>4  = Palette #2, high-intensity</code>
<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_4_colors_pal2_hi.png" alt="4 CGA Colors - palette #2 - high" style="width:15%;"><br>
                                                       &emsp;&emsp;<code>others = Palette #2, low-intensity</code>
<img src="https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/cga_4_colors_pal2_lo.png" alt="4 CGA Colors - palette #2 - low"  style="width:15%;"><br>
                                                       </td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>SW_LUT_BANK_SEL    </b></td><td>Software LUT bank selection.<br>
                                                       &emsp;&emsp;<code>0  = Select BANK 0</code><br>
                                                       &emsp;&emsp;<code>1  = Select BANK 1</code><br>
                                                       </td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>SW_LUT_RMW_MODE    </b></td><td>Read-Modify-Write mode for LUT-RAM access gate.<br>
                                                       &emsp;&emsp;<code>0  = Increment LUT_RAM_ADDR with any accesses to LUT_RAM_DATA (read or write)</code><br>
                                                       &emsp;&emsp;<code>1  = Increment LUT_RAM_ADDR with only write access to LUT_RAM_DATA</code><br>
                                                       </td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>SW_LUT_EN          </b></td><td>Enable/disable software LUT.<br>
                                                       &emsp;&emsp;<code>0  = Hardware LUT selected</code><br>
                                                       &emsp;&emsp;<code>1  = Software LUT selected</code><br>
                                                       </td></tr>
</tbody>
</table>




<a name="4_2_LUT_RAM_ADDR"></a>
### 4.2 LUT_RAM_ADDR

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x32</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LUT-RAM address</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=7  align="center" style="word-wrap:break-word;">reserved</td>          <!-- 15 ... 9 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LUT_RAM_ADDR[8]</td>   <!--  8       -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LUT_RAM_ADDR[7:0]</td>    <!--  7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LUT_RAM_ADDR  </b></td><td style="width:100%;">Memory address for accessing the LUT-RAM.<br>
                                                          It is automaticaly incremented with:<br>
                                                          - each WRITE access on LUT_RAM_DATA.<br>
                                                          - each READ access on LUT RAM_DATA if LUT_CFG.SW_LUT_RMW_MODE is cleared.</td></tr>
</tbody>
</table>

<a name="4_3_LUT_RAM_DATA"></a>
### 4.3 LUT_RAM_DATA

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x34</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LUT-RAM data</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LUT_RAM_DATA[15:8]</td>   <!-- 15 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LUT_RAM_DATA[7:0]</td>    <!--  7 ... 0 -->
    </tr>
  </tbody>
</table>


<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LUT_RAM_DATA  </b></td><td style="width:100%;">Data to be written to or read from the LUT memory.</td></tr>
</tbody>
</table>
