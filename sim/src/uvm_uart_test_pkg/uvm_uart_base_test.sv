// `include "uvm_uart_env.sv"

class uvm_uart_base_test extends uvm_test;
    `uvm_component_utils(uvm_uart_base_test)

    uvm_uart_env u_uvm_uart_env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("UVM INFO", "Hello from test", UVM_NONE);
        u_uvm_uart_env = uvm_uart_env::type_id::create("u_uvm_uart_env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
endclass