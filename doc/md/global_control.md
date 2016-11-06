<a name="top"></a>
# Global control registers

#### Table of content

*   [1. Introduction](#1_introduction)
*   [2. Registers](#2_registers)
    *   [2.1 GFX_CTRL](#2_1_GFX_CTRL)
    *   [2.2 GFX_STATUS](#2_2_GFX_STATUS)
    *   [2.3 GFX_IRQ](#2_3_GFX_IRQ)


<a name="1_introduction"></a>
## 1. Introduction

This section describes the global control, status and interrupt flag registers.  

<a name="2_registers"></a>
## 2. Registers

<a name="2_1_GFX_CTRL"></a>
### 2.1 GFX_CTRL

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x00</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Global control register</b></td>
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
        <td colspan=3  align="center" style="word-wrap:break-word;">res.</td>        <!-- 15 14 13 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">GPU_EN</td>      <!-- 12       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>        <!-- 11       -->
        <td colspan=3  align="center" style="word-wrap:break-word;">GFX_MODE</td>    <!-- 10  9  8 -->
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
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_GCMD_E</td>   <!--  7       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_GCMD_D</td>   <!--  6       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_GFIFO_O</td>  <!--  5       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_GFIFO_D</td>  <!--  4       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>        <!--  3       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_RCDONE</td>   <!--  2       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_RSTART</td>   <!--  1       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IE_RDONE</td>    <!--  0       -->
    </tr>
  </tbody>
</table>

<table border="0" style="width:100%;">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>GPU_EN</b></td><td style="width:100%;">Enable Graphic Processing Unit<br>
                                                       &emsp;&emsp;<code>0 = GPU is disabled</code><br>
                                                       &emsp;&emsp;<code>1 = GPU is enabled</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>GFX_MODE</b></td><td>Graphic Mode Configuration (bit-per-pixel)<br>
                                                       &emsp;&emsp;<code>000 = 1 bit-per-pixel</code><br>
                                                       &emsp;&emsp;<code>001 = 2 bit-per-pixel</code><br>
                                                       &emsp;&emsp;<code>010 = 4 bit-per-pixel</code><br>
                                                       &emsp;&emsp;<code>011 = 8 bit-per-pixel</code><br>
                                                       &emsp;&emsp;<code>others = 16 bit-per-pixel</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_GCMD_E</b></td><td>GPU command error interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable GPUCMD error interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable GPUCMD error interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_GCMD_D</b></td><td>GPU command done interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable GPUCMD done interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable GPUCMD done interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_GFIFO_O</b></td><td>GPU FIFO overflow interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable GPUFIFO overflow interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable GPUFIFO overflow interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_GFIFO_D</b></td><td>GPU FIFO done interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable GPUFIFO done interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable GPUFIFO done interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_RCDONE</b></td><td>Screen refresh counter done interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable REFR counter done interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable REFR counter done interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_RSTART</b></td><td>Screen refresh start interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable REFR start interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable REFR start interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IE_RDONE</b></td><td>Screen refresh done interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable REFR done interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable REFR done interrupt</code></td></tr>
  </tbody>
</table>

<a name="2_2_GFX_STATUS"></a>
### 2.2 GFX_STATUS

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x08</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Global status register</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">res.</td>        <!-- 15 ... 0 -->
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
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>         <!--  7       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">STA_GBUSY</td>    <!--  6       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>         <!--  5       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">STA_GFIFO</td>    <!--  4       -->
        <td colspan=3  align="center" style="word-wrap:break-word;">res.</td>         <!--  3  2  1 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">STA_RBUSY</td>    <!--  0       -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>STA_GBUSY</b></td><td style="width:100%;">GPU busy status bit<br>
                                                       &emsp;&emsp;<code>0 = GPU is idle</code><br>
                                                       &emsp;&emsp;<code>1 = GPU is busy</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>STA_GFIFO</b></td><td>GPU FIFO status bit<br>
                                                       &emsp;&emsp;<code>0 = GPU FIFO is empty</code><br>
                                                       &emsp;&emsp;<code>1 = GPU FIFO is not empty</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>STA_RBUSY</b></td><td>Screen refresh busy status bit<br>
                                                       &emsp;&emsp;<code>0 = no screen refresh on going</code><br>
                                                       &emsp;&emsp;<code>1 = screen refresh currently on going</code></td></tr>
</tbody>
</table>

<a name="2_3_GFX_IRQ"></a>
### 2.3 GFX_IRQ

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x00</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Global control register</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">res.</td>        <!-- 15 ... 8 -->
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
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_GCMD_E</td>   <!--  7       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_GCMD_D</td>   <!--  6       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_GFIFO_O</td>  <!--  5       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_GFIFO_D</td>  <!--  4       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>        <!--  3       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_RCDONE</td>   <!--  2       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_RSTART</td>   <!--  1       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">IF_RDONE</td>    <!--  0       -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>IF_GCMD_E</b></td><td style="width:100%;">GPU command error interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = no GPU command error was detected</code><br>
                                                       &emsp;&emsp;<code>1 = GPU command error detected (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IF_GCMD_D</b></td><td>GPU command done interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = GPU is IDLE or busy</code><br>
                                                       &emsp;&emsp;<code>1 = GPU command execution completed (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IF_GFIFO_O</b></td><td>GPU FIFO overflow interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = GPU FIFO didn't overflow</code><br>
                                                       &emsp;&emsp;<code>1 = GPU FIFO overflow detected (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IF_GFIFO_D</b></td><td>GPU FIFO done interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = GPU FIFO's last word was not read</code><br>
                                                       &emsp;&emsp;<code>1 = Last GPU FIFO word was read (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IF_RCDONE</b></td><td>Screen refresh counter done interrupt flag bit (see <a href="http://opencores.org/project,opengfx430,display%20configuration#2.5%20DISPLAY_REFR_CNT">here</a>)<br>
                                                       &emsp;&emsp;<code>0 = screen refresh counter is either 0 or still running</code><br>
                                                       &emsp;&emsp;<code>1 = screen refresh counter reached 0 (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IF_RSTART</b></td><td>Screen refresh start interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = no new screen refresh started</code><br>
                                                       &emsp;&emsp;<code>1 = a new screen refresh started (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>IF_RDONE</b></td><td>Screen refresh done interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = no screen refresh has completed</code><br>
                                                       &emsp;&emsp;<code>1 = screen refresh completed (write '1' to clear)</code></td></tr>
</tbody>
</table>

