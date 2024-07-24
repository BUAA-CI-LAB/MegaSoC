`define _DPRAMBW_GEN(WIDTH, BITSIZE, MSIZE) module DP_RAM_DP_W``WIDTH``_B``BITSIZE``_M``MSIZE``_BW \
(                                                                                                           \
  QA,                                                                                                       \
  QB,                                                                                                       \
  CLKA,                                                                                                     \
  CLKB,                                                                                                     \
  CENA,                                                                                                     \
  CENB,                                                                                                     \
  WENA,                                                                                                     \
  WENB,                                                                                                     \
  BWENA,                                                                                                    \
  BWENB,                                                                                                    \
  AA,                                                                                                       \
  AB,                                                                                                       \
  DA,                                                                                                       \
  DB);                                                                                                      \
parameter  Bits = ``BITSIZE``;                                                                              \
parameter  Word_Depth = ``WIDTH``;                                                                          \
localparam Addr_Width = $clog2(Word_Depth);                                                                 \
output          [Bits-1:0]      QA;                                                                         \
output          [Bits-1:0]      QB;                                                                         \
input CLKA;                                                                                                 \
input CLKB;                                                                                                 \
input CENA;                                                                                                 \
input CENB;                                                                                                 \
input WENA;                                                                                                 \
input WENB;                                                                                                 \
input [Bits-1:0]         BWENA;                                                                             \
input [Bits-1:0]         BWENB;                                                                             \
input	[Addr_Width-1:0]    AA;                                                                             \
input	[Addr_Width-1:0]    AB;                                                                             \
input	[Bits-1:0]         DA;                                                                              \
input	[Bits-1:0]         DB;                                                                              \
wire [(Bits/8) - 1 :0] shallow_wea;                                                                         \
wire [(Bits/8) - 1 :0] shallow_web;                                                                         \
for(genvar i = 0 ;i < Bits / 8 ;i+=1) begin                                                                 \
  assign shallow_wea[i]= (~(|BWENA[7 + i * 8:i * 8])) && ~WENA;                                             \
  assign shallow_web[i] = (~(|BWENB[7 + i * 8:i * 8])) && ~WENB;                                            \
end                                                                                                         \
xpm_memory_tdpram #(                                                                                        \
                      .ADDR_WIDTH_A       (Addr_Width             ),                                        \
                      .ADDR_WIDTH_B       (Addr_Width             ),                                        \
                      .AUTO_SLEEP_TIME    (0                      ),                                        \
                      .BYTE_WRITE_WIDTH_A (8                      ),                                        \
                      .BYTE_WRITE_WIDTH_B (8                      ),                                        \
                      .CASCADE_HEIGHT     (0                      ),                                        \
                      .CLOCKING_MODE      ("common_clock"         ),                                        \
                      .ECC_MODE           ("no_ecc"               ),                                        \
                      .IGNORE_INIT_SYNTH  (0                      ),                                        \
                      .MEMORY_INIT_FILE   ("none"                 ),                                        \
                      .MEMORY_INIT_PARAM  ("0"                    ),                                        \
                      .MEMORY_OPTIMIZATION("true"                 ),                                        \
                      .MEMORY_PRIMITIVE   ("auto"                 ),                                        \
                      .MEMORY_SIZE        (   Bits * Word_Depth   ),                                        \
                      .MESSAGE_CONTROL    (0                      ),                                        \
                      .READ_DATA_WIDTH_A  (Bits                   ),                                        \
                      .READ_DATA_WIDTH_B  (Bits                   ),                                        \
                      .READ_LATENCY_A     (1                      ),                                        \
                      .READ_LATENCY_B     (1                      ),                                        \
                      .USE_MEM_INIT       (0                      ),                                        \
                      .WRITE_DATA_WIDTH_A (Bits                   ),                                        \
                      .WRITE_DATA_WIDTH_B (Bits                   ),                                        \
                      .WRITE_MODE_A       ("write_first"          ),                                        \
                      .WRITE_MODE_B       ("write_first"          ),                                        \
                      .WRITE_PROTECT      (1                      )                                         \
) xpm_memory_tdpram_inst (                                                                                  \
  .douta         (QA         ),                                                                             \
  .doutb         (QB         ),                                                                             \
  .addra         (AA         ),                                                                             \
  .addrb         (AB         ),                                                                             \
  .clka          (CLKA       ),                                                                             \
  .clkb          (CLKB       ),                                                                             \
  .dina          (DA         ),                                                                             \
  .dinb          (DB         ),                                                                             \
  .ena           (~CENA      ),                                                                             \
  .enb           (~CENB      ),                                                                             \
  .wea           (shallow_wea),                                                                             \
  .web           (shallow_web),                                                                             \
  .injectdbiterra('0              ),                                                                        \
  .injectdbiterrb('0              ),                                                                        \
  .injectsbiterra('0              ),                                                                        \
  .injectsbiterrb('0              ),                                                                        \
  .sleep         ('0              ),                                                                        \
  .regcea        ('1              ),                                                                        \
  .regceb        ('1              ),                                                                        \
  .rsta          ('0              ),                                                                        \
  .rstb          ('0              )                                                                         \
);                                                                                                          \
endmodule

`define _DPRAM_GEN(WIDTH, BITSIZE, MSIZE) module DP_RAM_DP_W``WIDTH``_B``BITSIZE``_M``MSIZE``      \
(                                                                                                           \
  QA,                                                                                                       \
  QB,                                                                                                       \
  CLKA,                                                                                                     \
  CLKB,                                                                                                     \
  CENA,                                                                                                     \
  CENB,                                                                                                     \
  WENA,                                                                                                     \
  WENB,                                                                                                     \
  AA,                                                                                                       \
  AB,                                                                                                       \
  DA,                                                                                                       \
  DB);                                                                                                      \
parameter  Bits = ``BITSIZE``;                                                                              \
parameter  Word_Depth = ``WIDTH``;                                                                          \
localparam Addr_Width = $clog2(Word_Depth);                                                                 \
output          [Bits-1:0]      QA;                                                                         \
output          [Bits-1:0]      QB;                                                                         \
input CLKA;                                                                                                 \
input CLKB;                                                                                                 \
input CENA;                                                                                                 \
input CENB;                                                                                                 \
input WENA;                                                                                                 \
input WENB;                                                                                                 \
input	[Addr_Width-1:0]    AA;                                                                             \
input	[Addr_Width-1:0]    AB;                                                                             \
input	[Bits-1:0]         DA;                                                                              \
input	[Bits-1:0]         DB;                                                                              \
xpm_memory_tdpram #(                                                                                        \
                      .ADDR_WIDTH_A       (Addr_Width             ),                                        \
                      .ADDR_WIDTH_B       (Addr_Width             ),                                        \
                      .AUTO_SLEEP_TIME    (0                      ),                                        \
                      .BYTE_WRITE_WIDTH_A (Bits                   ),                                        \
                      .BYTE_WRITE_WIDTH_B (Bits                   ),                                        \
                      .CASCADE_HEIGHT     (0                      ),                                        \
                      .CLOCKING_MODE      ("common_clock"         ),                                        \
                      .ECC_MODE           ("no_ecc"               ),                                        \
                      .IGNORE_INIT_SYNTH  (0                      ),                                        \
                      .MEMORY_INIT_FILE   ("none"                 ),                                        \
                      .MEMORY_INIT_PARAM  ("0"                    ),                                        \
                      .MEMORY_OPTIMIZATION("true"                 ),                                        \
                      .MEMORY_PRIMITIVE   ("auto"                 ),                                        \
                      .MEMORY_SIZE        (   Bits * Word_Depth   ),                                        \
                      .MESSAGE_CONTROL    (0                      ),                                        \
                      .READ_DATA_WIDTH_A  (Bits                   ),                                        \
                      .READ_DATA_WIDTH_B  (Bits                   ),                                        \
                      .READ_LATENCY_A     (1                      ),                                        \
                      .READ_LATENCY_B     (1                      ),                                        \
                      .USE_MEM_INIT       (0                      ),                                        \
                      .WRITE_DATA_WIDTH_A (Bits                   ),                                        \
                      .WRITE_DATA_WIDTH_B (Bits                   ),                                        \
                      .WRITE_MODE_A       ("write_first"          ),                                        \
                      .WRITE_MODE_B       ("write_first"          ),                                        \
                      .WRITE_PROTECT      (1                      )                                         \
) xpm_memory_tdpram_inst (                                                                                  \
  .douta         (QA         ),                                                                             \
  .doutb         (QB         ),                                                                             \
  .addra         (AA         ),                                                                             \
  .addrb         (AB         ),                                                                             \
  .clka          (CLKA       ),                                                                             \
  .clkb          (CLKB       ),                                                                             \
  .dina          (DA         ),                                                                             \
  .dinb          (DB         ),                                                                             \
  .ena           (~CENA      ),                                                                             \
  .enb           (~CENB      ),                                                                             \
  .wea           (~WENA      ),                                                                             \
  .web           (~WENB      ),                                                                             \
  .injectdbiterra('0              ),                                                                        \
  .injectdbiterrb('0              ),                                                                        \
  .injectsbiterra('0              ),                                                                        \
  .injectsbiterrb('0              ),                                                                        \
  .sleep         ('0              ),                                                                        \
  .regcea        ('1              ),                                                                        \
  .regceb        ('1              ),                                                                        \
  .rsta          ('0              ),                                                                        \
  .rstb          ('0              )                                                                         \
);                                                                                                          \
endmodule

`_DPRAMBW_GEN(1024, 32, 4)
`_DPRAM_GEN(512, 32, 4)
`_DPRAM_GEN(512, 30, 4)
`_DPRAM_GEN(256, 32, 4)
`_DPRAM_GEN(256, 21, 4)
`_DPRAM_GEN(256, 14, 4)
`_DPRAM_GEN(256,  8, 4)
`_DPRAM_GEN(128,  7, 4)


// This one is special one, which has 4-bit write enable
module DP_RAM_DP_W512_B32_M4_BW 
(
  QA,
  QB,
CLKA,
  CLKB,
  CENA,
  CENB,
  WENA,
  WENB,
  BWENA,
  BWENB,
  AA,
  AB,
  DA,
  DB);
parameter  Bits = 32;
parameter  Word_Depth = 512;
localparam Addr_Width = $clog2(Word_Depth);
output          [Bits-1:0]      QA;
output          [Bits-1:0]      QB;
input CLKA;
input CLKB;
input CENA;
input CENB;
input WENA;
input WENB;
input [Bits-1:0]         BWENA;
input [Bits-1:0]         BWENB;
input	[Addr_Width-1:0]    AA;
input	[Addr_Width-1:0]    AB;
input	[Bits-1:0]         DA;
input	[Bits-1:0]         DB;
wire [(Bits/4) - 1 :0] shallow_wea;
wire [(Bits/4) - 1 :0] shallow_web;
for(genvar i = 0 ;i < Bits / 4 ;i+=1) begin
  assign shallow_wea[i]= (~(|BWENA[3 + i * 4:i * 4])) && ~WENA;
  assign shallow_web[i] = (~(|BWENB[3 + i * 4:i * 4])) && ~WENB;
end
wire [2*Bits-1:0] eQA;
wire [2*Bits-1:0] eQB;
wire [2*Bits-1:0] eDA;
wire [2*Bits-1:0] eDB;
for(genvar i = 0 ;i < Bits / 4; i+=1) begin
  assign QA[3 + i*4:i*4] = eQA[3 + i*8:i*8];
  assign QB[3 + i*4:i*4] = eQB[3 + i*8:i*8];
  assign eDA[3 + i*8:i*8] = DA[3 + i*4:i*4];
  assign eDB[3 + i*8:i*8] = DB[3 + i*4:i*4];
  assign eDA[7 + i*8:4+i*8] = '0;
  assign eDB[7 + i*8:4+i*8] = '0;
end
xpm_memory_tdpram #(
  .ADDR_WIDTH_A       (Addr_Width             ),
                      .ADDR_WIDTH_B       (Addr_Width             ),
                      .AUTO_SLEEP_TIME    (0                      ),
                      .BYTE_WRITE_WIDTH_A (8                      ),
                      .BYTE_WRITE_WIDTH_B (8                      ),
                      .CASCADE_HEIGHT     (0                      ),
                      .CLOCKING_MODE      ("common_clock"         ),
                      .ECC_MODE           ("no_ecc"               ),
                      .IGNORE_INIT_SYNTH  (0                      ),
                      .MEMORY_INIT_FILE   ("none"                 ),
                      .MEMORY_INIT_PARAM  ("0"                    ),
                      .MEMORY_OPTIMIZATION("true"                 ),
                      .MEMORY_PRIMITIVE   ("auto"                 ),
                      .MEMORY_SIZE        ( 2 * Bits * Word_Depth ),
                      .MESSAGE_CONTROL    (0                      ),
                      .READ_DATA_WIDTH_A  ( 2 * Bits              ),
                      .READ_DATA_WIDTH_B  ( 2 * Bits              ),
                      .READ_LATENCY_A     (1                      ),
                      .READ_LATENCY_B     (1                      ),
                      .USE_MEM_INIT       (0                      ),
                      .WRITE_DATA_WIDTH_A ( 2 * Bits              ),
                      .WRITE_DATA_WIDTH_B ( 2 * Bits              ),
                      .WRITE_MODE_A       ("write_first"          ),
                      .WRITE_MODE_B       ("write_first"          ),
                      .WRITE_PROTECT      (1                      )
) xpm_memory_tdpram_inst (
  .douta         (eQA         ),
  .doutb         (eQB         ),
  .addra         (AA         ),
  .addrb         (AB         ),
  .clka          (CLKA       ),
  .clkb          (CLKB       ),
  .dina          (eDA         ),
  .dinb          (eDB         ),
  .ena           (~CENA      ),
  .enb           (~CENB      ),
  .wea           (shallow_wea),
  .web           (shallow_web),
  .injectdbiterra('0              ),
  .injectdbiterrb('0              ),
  .injectsbiterra('0              ),
  .injectsbiterrb('0              ),
  .sleep         ('0              ),
  .regcea        ('1              ),
  .regceb        ('1              ),
  .rsta          ('0              ),
  .rstb          ('0              )
);
endmodule
