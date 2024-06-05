class uart_driver extends uvm_driver #(uart_sequence_item);
    `uvm_component_utils(uart_driver)

    virtual uart_if v_uart_if;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
        uart_sequence_item req;
        seq_item_port.get_next_item(req);

        v_uart_if.tx = req.data;
        
        seq_item_port.item_done();
        end
    endtask
endclass
