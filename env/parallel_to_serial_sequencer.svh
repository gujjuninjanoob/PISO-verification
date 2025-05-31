//----------------------------------------------------------------------
// Description   : This is a sequencer class for the parallel_to_serial.
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_SEQUENCER_SVH
`define PARALLEL_TO_SERIAL_SEQUENCER_SVH

class parallel_to_serial_sequencer extends uvm_sequencer#(parallel_to_serial_transaction);

  //--------------------------------------------------------------------
  // UVM factory registration 
  //--------------------------------------------------------------------
  `uvm_component_utils_begin(parallel_to_serial_sequencer)
  `uvm_component_utils_end

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  //               patent - parent component object.
  // Description : Constructor for parallel_to_serial sequencer.
  //-------------------------------------------------------------------
  function new(string name ="parallel_to_serial_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction : new

endclass : parallel_to_serial_sequencer

`endif // PARALLEL_TO_SERIAL_SEQUENCER_SVH
