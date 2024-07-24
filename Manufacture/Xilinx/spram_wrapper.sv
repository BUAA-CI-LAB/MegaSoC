`define _SPRAMBW_GEN(WIDTH, BITSIZE, MSIZE) module RAM_SP_W``WIDTH``_B``BITSIZE``_M``MSIZE``_BW \
(                                                                                                           \
  Q,                                                                                                        \
  CLK,                                                                                                      \
  CEN,                                                                                                      \
  WEN,                                                                                                      \
  BWEN,                                                                                                     \
  A,                                                                                                        \
  D);                                                                                                       \
parameter  Bits = ``BITSIZE``;                                                                              \
parameter  Word_Depth = ``WIDTH``;                                                                          \
localparam Addr_Width = $clog2(Word_Depth);                                                                 \
output          [Bits-1:0]      Q;                                                                          \
input CLK;                                                                                                  \
input CEN;                                                                                                  \
input WEN;                                                                                                  \
input [Bits-1:0]          BWEN;                                                                             \
input	[Addr_Width-1:0]    A;                                                                                \
input	[Bits-1:0]          D;                                                                                \
wire [(Bits/8) - 1 :0] shallow_we;                                                                          \
for(genvar i = 0 ;i < Bits / 8 ;i+=1) begin                                                                 \
  assign shallow_we[i]= (~(|BWEN[7 + i * 8:i * 8])) && ~WEN;                                              \
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
  .douta         (Q          ),                                                                             \
  .doutb         (           ),                                                                             \
  .addra         (A          ),                                                                             \
  .addrb         (           ),                                                                             \
  .clka          (CLK        ),                                                                             \
  .clkb          (           ),                                                                             \
  .dina          (D          ),                                                                             \
  .dinb          (           ),                                                                             \
  .ena           (~CEN       ),                                                                             \
  .enb           (           ),                                                                             \
  .wea           (shallow_we ),                                                                             \
  .web           ('0         ),                                                                             \
  .injectdbiterra('0              ),                                                                        \
  .injectdbiterrb('0              ),                                                                        \
  .injectsbiterra('0              ),                                                                        \
  .injectsbiterrb('0              ),                                                                        \
  .sleep         ('0              ),                                                                        \
  .regcea        ('1              ),                                                                        \
  .regceb        ('0              ),                                                                        \
  .rsta          ('0              ),                                                                        \
  .rstb          ('0              )                                                                         \
);                                                                                                          \
endmodule

`define _SPRAM_GEN(WIDTH, BITSIZE, MSIZE) module RAM_SP_W``WIDTH``_B``BITSIZE``_M``MSIZE``      \
(                                                                                                           \
  Q,                                                                                                        \
  CLK,                                                                                                      \
  CEN,                                                                                                      \
  WEN,                                                                                                      \
  A,                                                                                                        \
  D);                                                                                                       \
parameter  Bits = ``BITSIZE``;                                                                              \
parameter  Word_Depth = ``WIDTH``;                                                                          \
localparam Addr_Width = $clog2(Word_Depth);                                                                 \
output          [Bits-1:0]      Q;                                                                          \
input CLK;                                                                                                  \
input CEN;                                                                                                  \
input WEN;                                                                                                  \
input	[Addr_Width-1:0]    A;                                                                                \
input	[Bits-1:0]          D;                                                                                \
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
  .douta         (Q          ),                                                                             \
  .doutb         (           ),                                                                             \
  .addra         (A          ),                                                                             \
  .addrb         (           ),                                                                             \
  .clka          (CLK        ),                                                                             \
  .clkb          (           ),                                                                             \
  .dina          (D          ),                                                                             \
  .dinb          (           ),                                                                             \
  .ena           (~CEN       ),                                                                             \
  .enb           (           ),                                                                             \
  .wea           (~WEN       ),                                                                             \
  .web           ('0         ),                                                                             \
  .injectdbiterra('0              ),                                                                        \
  .injectdbiterrb('0              ),                                                                        \
  .injectsbiterra('0              ),                                                                        \
  .injectsbiterrb('0              ),                                                                        \
  .sleep         ('0              ),                                                                        \
  .regcea        ('1              ),                                                                        \
  .regceb        ('0              ),                                                                        \
  .rsta          ('0              ),                                                                        \
  .rstb          ('0              )                                                                         \
);                                                                                                          \
endmodule

`_SPRAMBW_GEN(512, 64, 4)
`_SPRAM_GEN(4096, 35, 8)
`_SPRAM_GEN(256, 21, 4)
