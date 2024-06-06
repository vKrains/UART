class uvm_uart_env extends uvm_env;
    `uvm_component_utils(uvm_uart_env)

    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // virtual uvma_apb_if apb_if_h;

    virtual axis_if mst_axis_if_h;

    // uvma_apb_agent apb_agent_h;

    axis_agent mst_axis_agent;

    

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual axis_if )::get(this, "", "mst_axis_if_h", mst_axis_if_h))
           `uvm_fatal("GET_DB", "Can not get mst_axis_if_h")

        mst_axis_agent = axis_agent::type_id::create("mst_axis_agent", this);
        // apb_agent_h = uvma_apb_agent #(4)::type_id::create("apb_agent_h", this);        

        `uvm_info("UVM_INFO", "Hello from env", UVM_NONE);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        uvm_top.print_topology();
        
        // mst_axis_agent.axis_monitor_h.analysis_port_h.connect(test_scoreboard_h.analysis_port_in_1);

        
    endfunction
endclass