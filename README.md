# OpenMegaSoC

## 1 关于

MegaSoC 是由北航百芯计划团队开发的一款 SoC 框架，支持使用 AXI 总线的 LoongArch 指令集处理器的正常工作。

MegaSoC 由北航计算机学院本科生田韵豪 @t123yh 完成面向 MIPS 的[初代版本](https://github.com/orgs/MegaSoC)，并由后续北航百芯计划团队迭代完善。

MegaSoC 初代版本及所支持的MIPS芯片流片工作可参阅：[2022年田韵豪本科毕设论文](./18373444-田韵豪-MIPS处理器设计与操作系统移植.pdf) 

OpenMegaSoC 是 MegaSoC 的开源版本。

## 2 支持外设

OpenMegaSoC 提供了 SPI、SDIO、I2S、VGA、Ethernet、UART、CDBUS、I2C 等硬件外设支持。

![百芯部署整体框架图](./picture/megasoc.drawio.png)

### 2.1 AXI4 Peripheral Address Mapping

| Address Range                                            | Device                    | Select Value |
| -------------------------------------------------------- | ------------------------- | ------------ |
| `0x00000000 - 0x0FFFFFFF`                                | Memory Controller         | 0            |
| `0x1C000000 - 0x1C0FFFFF`<br />`0x1D000000 - 0x1D00FFFF` | SPI Device                | 1            |
| `0x1D010000 - 0x1D0FFFFF`                                | AXI-Lite Device           | 2            |
| `0x1D100000 - 0x1D1FFFFF`                                | USB Controller            | 3            |
| Other Addresses                                          | AXI-Lite Device (Default) | 2            |

### 2.2 AXI4-Lite Peripheral Address Mapping

| Address Range             | Device                         | Select Value |
| ------------------------- | ------------------------------ | ------------ |
| `0x1D010000 - 0x1D03FFFF` | APB Devices (UART, I2C, CDBUS) | 1            |
| `0x1D040000 - 0x1D04FFFF` | Configuration Registers        | 2            |
| `0x1D050000 - 0x1D05FFFF` | Ethernet Controller            | 3            |
| `0x1D060000 - 0x1D06FFFF` | Interrupt Controller           | 4            |
| `0x1D070000 - 0x1D07FFFF` | SD Controller                  | 5            |
| `0x1D0A0000 - 0x1D0AFFFF` | JPEG Controller                | 6            |
| `0x1D0B0000 - 0x1D0BFFFF` | I2S Controller-0（DMA）        | 7            |
| `0x1D0C0000 - 0x1D0CFFFF` | I2S Controller-1（GEN）        | 8            |
| `0x1D0D0000 - 0x1D0DFFFF` | VGA Controller                 | 9            |
| Other Addresses           | SRAM Controller (Default)      | 0            |

### 2.3 IP来源

| 名称                       | 来源                                                         | 作用                                        |
| :------------------------- | ------------------------------------------------------------ | ------------------------------------------- |
| loongson-blocks            | https://gitee.com/loongson-edu/chiplab/tree/chiplab_diff/IP  | 提供UART、CONFREG、SPI控制器                |
| pulp-axi                   | https://github.com/pulp-platform/axi                         | 用于高性能片上通信的 AXI SystemVerilog 模块 |
| pulp-common_cells          | https://github.com/pulp-platform/common_cells                | 常用模块、头文件                            |
| register_interface         | https://github.com/pulp-platform/register_interface          | 通用寄存器接口                              |
| ultraembedded-jpeg_decoder | https://github.com/ultraembedded/core_jpeg_decoder           | JPEG解码器                                  |
| Xilinx-AXI-Intc            | Xilinx开源IP                                                 | 中断控制器                                  |
| Xilinx-emaclite            | Xilinx开源IP                                                 | 以太网控制器                                |
| Xilinx-primitive           | Xilinx开源IP                                                 | cdc、fifo                                   |
| Xilinx-AXIAHB              | Xilinx开源IP                                                 | AXI-AHB总线桥                               |
| ZipCPU-wb2axip             | https://github.com/ZipCPU/wb2axip                            | 总线互连、桥接器和其他组件                  |
| i2c-slave                  | https://github.com/freecores/i2cslave                        | I2C从设备                                   |
| opencores-i2c              | https://github.com/fabriziotappero/ip-cores/tree/communication_controller_i2c_controller_core#vhdlverilog-ip-cores-repository | I2C主设备                                   |
| axi_to_i2s                 | 自主设计                                                     | AXI控制的I2S输出模块                        |
| axi-hdmi                   | 自主设计                                                     | SII-146芯片控制器                           |
| dukelec-cdbus_ip           | https://github.com/dukelec/cdbus                             | CDBUS控制器                                 |
| axi-sdc                    | https://github.com/mczerski/SD-card-controller               | SD卡控制器                                  |

## 3 支持平台

OpenMegaSoC 尽可能以 RTL 形式提供使用到的所有模块，因此对硬件开发平台有最小化的要求。

目前本项目提供面向龙芯百芯计划开发板（7A200T）、北航百芯计划开发板（7K325T）、ZU15MINI开发板（XCZU15EG）三款 FPGA 开发板的支持。

本项目最小化了对厂商相关的 Primitive 使用。对于不同的开发平台，只需要准备 SRAM 、PLL 这两类模块既可。

你可以很轻松的将本项目 SoC 部署到其它平台。具体可参考 Menufacturer/Xilinx 目录下的实现，完成约束和 SRAM 模块的替换即可。

## 4 目录结构

- Board 文件夹
  存放板级相关文件，包括板级顶层、板级 FPGA IO 约束、开发板工程。
- General 文件夹
  存放平台无关代码，包括 SoC 顶层（soc_top）、SoC 使用到的 IP 核等。若需要修改核心地址映射，或者添加新的外设设备，需要对这一层进行修改
- Manufacture
  存放平台相关代码，目前仅有 Xilinx 平台下的相关代码支持。用户需要在这里提供本项目使用的不同规格 SRAM。
  本项目使用双口及单口 SRAM，具体涉及的 SRAM 规格及模块名称，可参考 `Xilinx/dpram_wrapper.sv` 及 `Xilinx/spram_wrapper.sv` 文件。

## 5 视频接口说明

OpenMegaSoC 对外输出 RGB888 全彩视频，但需要借助 SII-164 芯片辅助。具体输出格式，请参考 SII-164 芯片数据手册。

视频中的 24 位色彩信号采用双边沿时钟采样格式并行传输。SoC 内部按照 VGA 时序生成视频信号，并对 RGB 数据信号做双边沿采样操作。

也可以修改 SoC 中的相关数据通路，改为直接输出单边沿采样的 VGA 信号。

## 6 音频接口说明

OpenMegaSoC 对外输出 I2S 格式的音频，需要外部 DAC 配合完成模拟音频信号的输出。同时建议采用来自外部晶振的音频时钟以获得较好的音频质量（也可由内部 PLL 产生）。

对于龙芯提供的两款开发板，均需要使用拓展 IO 完成对 I2S 音频输出的支持。
