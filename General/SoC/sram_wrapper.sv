// 临时占位使用
module sram_wrapper (
    input aclk,
    input aresetn,
    AXI_LITE.Slave slv
  );

  //slv.aw_valid
  assign slv.aw_ready = 1'b1;
  //slv.aw_addr

  reg b_valid_q;
  //slv.w_valid
  assign slv.w_ready = ~b_valid_q;
  //slv.w_data
  //slv.w_strb

  always_ff @(posedge aclk) begin
    if(!aresetn) begin
      b_valid_q <= '0;
    end
    else begin
      if(slv.w_valid && slv.w_ready) begin
        b_valid_q <= '1;
      end
      else if(slv.b_valid && slv.b_ready) begin
        b_valid_q <= '0;
      end
    end
  end
  assign slv.b_valid = b_valid_q;
  //slv.b_ready
  assign slv.b_resp = '0;

  //slv.ar_valid
  assign slv.ar_ready = 1'b1;
  //slv.ar_addr

  assign slv.r_valid = 1'b1;
  // slv.r_ready
  assign slv.r_data = 32'habadf00d;
  assign slv.r_resp = '0;

endmodule
