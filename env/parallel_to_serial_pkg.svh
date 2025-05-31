/----------------------------------------------------------------------
// Description   : This is package has all the files included and imported
//                 for the parallel_to_serial UVC. 
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_PKG_SVH
`define PARALLEL_TO_SERIAL_PKG_SVH
 
// Including other files.
`include "parallel_to_serial_typedef_pkg.sv"
`include "parallel_to_serial_if.sv"

package parallel_to_serial_pkg;

  // Import external packages 
  import uvm_pkg::*;
  import base_pkg::*;
  import parallel_to_serial_typedef_pkg::*;

  // Include all supporting files for parallel_to_serial UVC
  `include "base_macros.svh";
  `include "parallel_to_serial_parameters.sv";
  `include "parallel_to_serial_config.sv";
  `include "parallel_to_serial_transaction.sv";
  `include "parallel_to_serial_driver.sv";
  `include "parallel_to_serial_sequencer.sv";
  `include "parallel_to_serial_monitor.sv";
  `include "parallel_to_serial_agent.sv";
  `include "parallel_to_serial_sequences.sv";

endpackage : parallel_to_serial_pkg

`endif // PARALLEL_TO_SERIAL_PKG_SVH
