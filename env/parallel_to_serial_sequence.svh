//----------------------------------------------------------------------
// Description   : This is a base sequence class for parallel_to_serial UVC. 
//                 All the UVC sequences will be extended from this
//                 sequence. This sequence have the common methods 
//                 to be used by other derived sequences. 
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_SEQUENCES_SVH
`define PARALLEL_TO_SERIAL_SEQUENCES_SVH

class parallel_to_serial_base_seq extends uvm_sequence#(parallel_to_serial_transaction);

  `uvm_object_utils(parallel_to_serial_base_seq)

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  // Description : Constructor for base sequence class.
  //------------------------------------------------------------------
  function new(string name="parallel_to_serial_base_seq");
    super.new(name);
  endfunction : new
   
  //--------------------------------------------------------------------
  // Defining virtual body method
  //--------------------------------------------------------------------
  virtual task body();
  endtask : body
   
endclass : parallel_to_serial_base_seq

 // TODO : Add all the sequences over here extended from parallel_to_serial_base_seq

`endif // PARALLEL_TO_SERIAL_SEQUENCES_SVH
