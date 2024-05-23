set PROJECT_NAME            UART
set DIR_OUTPUT              work

set COMMON_FILESET          src_common
set SIM_FILESET             src_sim

# Crate project directory
file mkdir $DIR_OUTPUT

# Crate project
create_project -force $PROJECT_NAME $DIR_OUTPUT/$PROJECT_NAME -part xc7a15tcsg324-3

# add source
create_fileset $COMMON_FILESET
add_files -norecurse ../../src/uart_regs.sv
add_files -norecurse ../../src/uart_rx.sv
add_files -norecurse ../../src/uart_tx.sv
add_files -norecurse ../../src/uart.sv

# add simulation source
create_fileset $SIM_FILESET
add_files -norecurse ../src/uvm_uart_test_pkg/uvm_uart_test_pkg.sv
add_files -norecurse ../src/tb.sv


set_property top tb [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui