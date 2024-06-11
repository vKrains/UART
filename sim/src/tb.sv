`timescale 1ns/1ps
`include "../src/AXIS_UVM_Agent/src/axis_intf.sv"
`include "uvm_apb_agent/design.sv"
`include "uart_if.sv"
module tb;
    import uvm_pkg::*;
    import uvm_uart_test_pkg::*;
    //`include "/uvm_uart_test_pkg/uvm_uart_test_pkg.sv"
    //`include "uvm_macros.svh"

    bit clk = 0;
    bit rst_n = 1;

    axis_if  mst_axis_if (clk);
    axis_if  slv_axis_if (clk);
    dut_if u_apb_if();
    uart_if u_uart_if(clk);

    assign u_apb_if.pclk = clk;

    initial begin
        uvm_config_db #(virtual axis_if)::set(null, "uvm_test_top.*", "mst_axis_if_h", mst_axis_if);
        uvm_config_db #(virtual axis_if)::set(null, "uvm_test_top.*", "slv_axis_if_h", slv_axis_if);
        uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.*", "vif", u_apb_if);
        uvm_config_db #(virtual uart_if)::set(null, "uvm_test_top.*", "u_uart_if", u_uart_if);

        run_test("uvm_uart_base_test");
    end

    uart DUT 
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .slv_axis_tdata_i   (slv_axis_if.tdata),
        .slv_axis_tvalid_i  (slv_axis_if.tvalid),
        //.slv_axis_tlast_i   (slv_axis_if.tlast),
        .slv_axis_tready_o  (slv_axis_if.tready),
        .mst_axis_tdata_o   (mst_axis_if.tdata),
        .mst_axis_tvalid_o  (mst_axis_if.tvalid),
        //.mst_axis_tlast_o   (mst_axis_if.tlast),
        .mst_axis_tready_i  (mst_axis_if.tready),
        .psel_i             (u_apb_if.psel),
        .penable_i          (u_apb_if.penable),
        .pwrite_i           (u_apb_if.pwrite),
        .paddr_i            (u_apb_if.paddr),
        .pwdata_i           (u_apb_if.pwdata),
        .pready_o           (u_apb_if.pready),
        .prdata_o           (u_apb_if.prdata),
        .rx_i               (u_uart_if.rx),
        .tx_o               (u_uart_if.tx)
    );


endmodule