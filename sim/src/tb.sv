`timescale 1ns/1ps
`include "../src/AXIS_UVM_Agent/src/axis_intf.sv"
`include "uvm_apb_agent/design.sv"
module tb;
    import uvm_pkg::*;
    import uvm_uart_test_pkg::*;
    //`include "/uvm_uart_test_pkg/uvm_uart_test_pkg.sv"
    //`include "uvm_macros.svh"

    bit aclk = 0;
    bit rst_n = 1;

    axis_if  u_axis_if (aclk);
    dut_if u_apb_if;

    initial begin
        uvm_config_db #(virtual axis_if)::set(null, "uvm_test_top.*", "mst_axis_if_h", u_axis_if);
        uvm_config_db #(virtual uvma_apb_if)::set(null, "uvm_test_top.*", "vif", u_apb_if);
        run_test("uvm_uart_base_test");
    end
endmodule