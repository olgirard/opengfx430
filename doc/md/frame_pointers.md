<a name="top"></a>
# Frame Pointers configuration register

#### Table of content

*   [1. Introduction](#1_introduction)
*   [2. Registers](#2_registers)
    *   [2.1 FRAME_SELECT](#2_1_FRAME_SELECT)
    *   [2.2 FRAME*n*_PTR (HI/LO)](#2_2_FRAMEx_PTR)


<a name="1_introduction"></a>
## 1. Introduction

This section describes the frame pointers and corresponding configuration registers.


<a name="2_registers"></a>
## 2. Registers

<a name="2_1_FRAME_SELECT"></a>
### 2.1 FRAME_SELECT

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x3E</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Frame pointer selection register</b></td>
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
        <td colspan=2  align="center" style="word-wrap:break-word;">res.</td>             <!-- 15 ... 14 -->
        <td colspan=2  align="center" style="word-wrap:break-word;">VRAM1_FRAME_SEL</td>  <!-- 13 ... 12 -->
        <td colspan=2  align="center" style="word-wrap:break-word;">res.</td>             <!-- 11 ... 10 -->
        <td colspan=2  align="center" style="word-wrap:break-word;">VRAM0_FRAME_SEL</td>  <!--  9 ...  8 -->
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
        <td colspan=6  align="center" style="word-wrap:break-word;">res.</td>              <!-- 7 ... 2 -->
        <td colspan=2  align="center" style="word-wrap:break-word;">REFR_FRAME_SEL</td>    <!-- 1 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>VRAM1_FRAME_SEL</b></td><td style="width:100%;">Selects the address offset for the VID_RAM1 interface.<br>
                                                       &emsp;&emsp;<code>0  = Select FRAME0_PTR for VID_RAM1 interface.</code><br>
                                                       &emsp;&emsp;<code>1  = Select FRAME1_PTR for VID_RAM1 interface.</code><br>
                                                       &emsp;&emsp;<code>2  = Select FRAME2_PTR for VID_RAM1 interface.</code><br>
                                                       &emsp;&emsp;<code>3  = Select FRAME3_PTR for VID_RAM1 interface.</code><br></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>VRAM0_FRAME_SEL</b></td><td style="width:100%;">Selects the address offset for the VID_RAM0 interface.<br>
                                                       &emsp;&emsp;<code>0  = Select FRAME0_PTR for VID_RAM0 interface.</code><br>
                                                       &emsp;&emsp;<code>1  = Select FRAME1_PTR for VID_RAM0 interface.</code><br>
                                                       &emsp;&emsp;<code>2  = Select FRAME2_PTR for VID_RAM0 interface.</code><br>
                                                       &emsp;&emsp;<code>3  = Select FRAME3_PTR for VID_RAM0 interface.</code><br></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>REFR_FRAME_SEL</b></td><td style="width:100%;">Selects the address offset for the screen refresh.<br>
                                                       &emsp;&emsp;<code>0  = Select FRAME0_PTR for the screen refresh.</code><br>
                                                       &emsp;&emsp;<code>1  = Select FRAME1_PTR for the screen refresh.</code><br>
                                                       &emsp;&emsp;<code>2  = Select FRAME2_PTR for the screen refresh.</code><br>
                                                       &emsp;&emsp;<code>3  = Select FRAME3_PTR for the screen refresh.</code><br></td></tr>
</tbody>
</table>

<a name="2_2_FRAMEx_PTR"></a>
### 2.2 FRAME*n*_PTR (HI/LO)

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=3 bgcolor="#B0B0B0">&nbsp;<b>Addresses:<br>
                                        &nbsp;&nbsp;&nbsp;FRAME0_PTR_LO: 0x40<br>
                                        &nbsp;&nbsp;&nbsp;FRAME1_PTR_LO: 0x44<br>
                                        &nbsp;&nbsp;&nbsp;FRAME2_PTR_LO: 0x48<br>
                                        &nbsp;&nbsp;&nbsp;FRAME3_PTR_LO: 0x4C</b></td>
        <td colspan=5 bgcolor="#B0B0B0">&nbsp;<b>Frame address pointer <i>n</i> low (bits 0 to 15)</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">FRAME<i>n</i>_PTR[15:8]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">FRAME<i>n</i>_PTR[7:0]</td>        <!--  7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=3 bgcolor="#B0B0B0">&nbsp;<b>Addresses:<br>
                                        &nbsp;&nbsp;&nbsp;FRAME0_PTR_HI: 0x42<br>
                                        &nbsp;&nbsp;&nbsp;FRAME1_PTR_HI: 0x46<br>
                                        &nbsp;&nbsp;&nbsp;FRAME2_PTR_HI: 0x4A<br>
                                        &nbsp;&nbsp;&nbsp;FRAME3_PTR_HI: 0x4E</b></td>
        <td colspan=5 bgcolor="#B0B0B0">&nbsp;<b>Frame address pointer <i>n</i> high (bits 16 to 31)</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">FRAME<i>n</i>_PTR[31:24]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">FRAME<i>n</i>_PTR[23:16]</td>        <!--  7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>FRAME<i>n</i>_PTR</b></td><td>Frame buffer address pointer.<br>
                It can be selected as offset for screen refresh and indirect video-memory access.</td></tr>
</tbody>
</table>

