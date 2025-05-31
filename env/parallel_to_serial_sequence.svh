//----------------------------------------------------------------------
// Description   : This is a base sequence class for serial_to_parallel UVC. 
//                 All the UVC sequences will be extended from this
//                 sequence. This sequence have the common methods 
//                 to be used by other derived sequences. 
//----------------------------------------------------------------------

`ifndef SERIAL_TO_PARALLEL_SEQUENCES_SVH
`define SERIAL_TO_PARALLELS_EQUENCES_SVH

class serial_to_parallel_base_seq extends uvm_sequence#(serial_to_parallel_transaction);

  `uvm_object_utils(serial_to_parallel_base_seq)

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  // Description : Constructor for base sequence class.
  //------------------------------------------------------------------
  function new(string name="serial_to_parallel_base_seq");
    super.new(name);
  endfunction : new
   
  //--------------------------------------------------------------------
  // Defining virtual body method
  //--------------------------------------------------------------------
  virtual task body();
  endtask : body
   
endclass : serial_to_parallel_base_seq

 // TODO : Add all the sequences over here extended from serial_to_parallel_base_seq

`endif // SERIAL_TO_PARALLEL_SEQUENCES_SVH
