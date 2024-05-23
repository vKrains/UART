`timescale 1ns/1ps

module tb;
    import uvm_pkg::*;
    import uvm_uart_test_pkg::*;
    `include "uvm_macros.svh"
    // `include "uvm_uart_base_test.sv"

    initial begin
        run_test("uvm_uart_base_test");
    end
endmodule