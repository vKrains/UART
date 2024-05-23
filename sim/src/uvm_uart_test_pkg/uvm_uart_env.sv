// `include "../src/AXIS_UVM_Agent/example_env/test_pkg.sv"
//`include "../src/AXIS_UVM_Agent/example_env/"
//`include "../src/AXIS_UVM_Agent/src/axis_include.svh"

class uvm_uart_env extends uvm_env;
    `uvm_component_utils(uvm_uart_env)

   // virtual axis_if axis_if_h;
    // virtual axis_if axis_if_h;
    // virtual axis_if v_slv_axis_out;
    // virtual apb_if  v_apb_if;
    //virtual uart_if v_uart_if;

    // axis_agent mst_axis_agent;
    // axis_agent
    // apb_agent
    //uart_agent

    // test_scoreboard test_scoreboard_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // mst_axis_agent = axis_agent::type_id::create("mst_axis_agent", this);

        // mst_axis_agent.agent_type = MASTER;

        // mst_axis_agent.axis_if_h = this.axis_if_h;
        `uvm_info("UVM_INFO", "Hello from env", UVM_NONE);
    endfunction

    // virtual function void connect_phase(uvm_phase phase);
    //     super.connect_phase(phase);

        
    //     mst_axis_agent.axis_monitor_h.analysis_port_h.connect(test_scoreboard_h.analysis_port_in_1);

        
    // endfunction
endclass