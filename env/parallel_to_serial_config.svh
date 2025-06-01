//----------------------------------------------------------------------
// Description   : This is a configuration class for parallel_to_serial agent,
//                 it holds the variables that are required for different
//                 configurations of parallel_to_serial UVC.  
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_CONFIG_SVH
`define PARALLEL_TO_SERIAL_CONFIG_SVH
typedef enum { NONE, LOW, MEDIUM, HIGH } verbosity_e;
class parallel_to_serial_config extends uvm_object;

  //--------------------------------------------------------------------
  // Variables declarations
  //-----------------------------------------------------------------
  // Variable to enable/disable the checker coverage
  // Default : Enable -> 1
  // Disable -> 0
  bit en_checker_cov = 1'b1;
  rand bit global_parity_en;
  rand bit [BAUD_RATE-1:0] baud_rate;
  rand int num_pkts;
  rand verbosity_e verb_dbg_msg_e;
  uvm_agent_mode_e agent_mode;

    // Constraint for checker coverage
    constraint c_en_chk_cov {
    soft en_checker_cov == 1;}
    constraint parity_bit_valid{
    global_parit_en inside {PARITY_DISABLED,PARITY_ENABLED};}
  //This we can use inside sequence for future purpose 
  //  constraint dynamic_c {
  //  if (cfg.global_parity_en==PARITY_ENABLED)
  //      parity_enable == 1;
  //  else
  //      parity_enable == 0;}
  
    constraint baud_rate_valid{
    baud_rate inside {BAUD_9600,BAUD_19200,BAUD_38400,BAUD_115200};}
    constraint num_packets_valid{
    num_pkts inside {[MIN_NUM_PACKETS:MAX_NUM_PACKETS]};}

  //--------------------------------------------------------------------
  // UVM factory registration
  //-------------------------------------------------------------------
  `uvm_object_utils_begin(parallel_to_serial_config)
    `uvm_field_int(en_checker_cov,UVM_ALL_ON)
    `uvm_field_int(global_parity_en,UVM_ALL_ON)
    `uvm_field_int(baud_rate,UVM_ALL_ON)
    `uvm_field_int(num_pkts,UVM_ALL_ON) 
    `uvm_field_int(verb_dbg_msg_e,UVM_ALL_ON) 
     `uvm_field_int(agent_mode,UVM_ALL_ON)
  
    
  `uvm_object_utils_end

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  // Description : Constructor for parallel_to_serial agent configuration class objects.
  //------------------------------------------------------------------
  function new(string name="parallel_to_serial_config");
    super.new(name);
  endfunction : new


  
endclass : parallel_to_serial_config

`endif // PARALLEL_TO_SERIAL_CONFIG_SVH
