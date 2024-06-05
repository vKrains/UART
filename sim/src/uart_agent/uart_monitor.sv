class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)

  virtual uart_if v_uart_if;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      uart_sequence_item item = uart_sequence_item::type_id::create("item");

      item.data = v_uart_if.rx;
    end
  endtask
endclass
