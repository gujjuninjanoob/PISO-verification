//----------------------------------------------------------------------
// Description   : This is a configuration class for parallel_to_serial agent,
//                 it holds the variables that are required for different
//                 configurations of parallel_to_serial UVC.  
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_CONFIG_SVH
`define PARALLEL_TO_SERIAL_CONFIG_SVH

class parallel_to_serial_config extends uvm_object;

  //--------------------------------------------------------------------
  // Variables declarations
  //-----------------------------------------------------------------
  // Variable to enable/disable the checker coverage
  // Default : Enable -> 1
  // Disable -> 0
  bit en_checker_cov = 1;

  // Constraint for checker coverage
  constraint c_en_chk_cov {
    soft en_checker_cov == 1;
  }

  //--------------------------------------------------------------------
  // UVM factory registration
  //-------------------------------------------------------------------
  `uvm_object_utils_begin(parallel_to_serial_config)
    `uvm_field_int(en_checker_cov,UVM_ALL_ON)
    // TODO : Register all the local variables and objects.
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
