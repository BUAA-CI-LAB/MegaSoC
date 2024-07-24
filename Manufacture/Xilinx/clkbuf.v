module CLKBUFHDV16 (
  input I,
  output Z
);

  assign Z = I;

endmodule

module CLKAND2HDV12(
  input A1,
  input A2,
  output Z
);
  assign Z = A1 & A2;
endmodule
