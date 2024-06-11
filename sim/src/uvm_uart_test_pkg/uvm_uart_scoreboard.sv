`uvm_analysis_imp_decl(_mst_axis)
`uvm_analysis_imp_decl(_slv_axis)
`uvm_analysis_imp_decl(_mst_apb)

class uvm_uart_scoreboard extends uvm_scoreboard;
    `uvm_component_param_utils(uvm_uart_scoreboard)
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp_mst_axis #(axis_data, uvm_uart_scoreboard)       analysis_port_mst_axis;
    uvm_analysis_imp_slv_axis #(axis_data, uvm_uart_scoreboard)       analysis_port_slv_axis;
    uvm_analysis_imp_mst_apb  #(apb_transaction, uvm_uart_scoreboard) analysis_port_mst_apb;

    bit [8-1:0]     axis_data_q_mst_axis[$];
    bit [8-1:0]     axis_data_q_slv_axis[$];
    apb_transaction apb_data_q_mst_apb[$];

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_port_mst_axis = new("analysis_port_mst_axis", this);
        analysis_port_slv_axis = new("analysis_port_slv_axis", this);
        analysis_port_mst_apb =  new("analysis_port_mst_apb", this);

        `uvm_info("UVM_INFO", "Hello from scoreboard", UVM_NONE);
    endfunction

    function void write_mst_axis (axis_data axis_data_h);
        axis_data_q_mst_axis.push_back(axis_data_h.tdata);
    endfunction

    function void write_slv_axis (axis_data axis_data_h);
        axis_data_q_slv_axis.push_back(axis_data_h.tdata);
    endfunction

    function void write_mst_apb (apb_transaction apb_transaction_h);
        apb_data_q_mst_apb.push_back(apb_transaction_h);
    endfunction

endclass