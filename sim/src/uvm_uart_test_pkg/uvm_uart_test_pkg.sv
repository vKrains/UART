package uvm_uart_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "../uvm_apb_agent/apb_transaction.sv"
    `include "../uvm_apb_agent/apb_sequence.sv"
    `include "../uvm_apb_agent/apb_sequencer.sv"  
    `include "../uvm_apb_agent/apb_driver.sv"
    `include "../uvm_apb_agent/apb_monitor.sv"
    `include "../uvm_apb_agent/apb_agent.sv"
    `include "../uvm_apb_agent/apb_scoreboard.sv"
    `include "../uvm_apb_agent/apb_subscriber.sv"
    `include "../uvm_apb_agent/apb_env.sv"
    `include "../uvm_apb_agent/apb_test.sv" 
    

    `include "../../src/AXIS_UVM_Agent/src/axis_include.svh"
    `include "uvm_uart_env.sv"
    `include "uvm_uart_base_test.sv"
    
endpackage