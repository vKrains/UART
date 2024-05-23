class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)

    uart_driver uart_driver_h;
    uart_monitor uart_monitor_h;
    uart_sequencer uart_sequencer_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uart_driver_h = uart_driver::type_id::create("uart_driver_h", this);
        uart_monitor_h = uart_monitor::type_id::create("uart_monitor_h", this);
        uart_sequencer_h = uart_sequencer::type_id::create("uart_sequencer_h", this);
    endfunction

    function void connect_phase (uvm_phase phase);
        uart_driver_h.seq_item_port.connect(uart_sequencer_h.seq_item_export);
    endfunction

endclass