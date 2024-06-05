`timescale 1ns/1ps
`include "../src/AXIS_UVM_Agent/src/axis_intf.sv"
module tb;
    import uvm_pkg::*;
    import uvm_uart_test_pkg::*;
    //`include "/uvm_uart_test_pkg/uvm_uart_test_pkg.sv"
    //`include "uvm_macros.svh"

    bit aclk = 0;

    axis_if #(8) u_axis_if (aclk);

    initial begin
        uvm_config_db #(virtual axis_if #(8))::set(null, "uvm_test_top.*", "u_axis_if", u_axis_if);
        run_test("uvm_uart_base_test");
    end
endmodule