/----------------------------------------------------------------------
// Description   : This is the transaction class for parallel_to_serial UVC. 
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_TRANSACTION_SVH
`define PARALLEL_TO_SERIAL_TRANSACTION_SVH

class parallel_to_serial_transaction extends uvm_transaction;

  //--------------------------------------------------------------------
  // Variables declarations
  //------------------------------------------------------------------
  
  //--------------------------------------------------------------------
  // UVM factory registration 
  //--------------------------------------------------------------------
  `uvm_object_utils_begin(parallel_to_serial_transaction)
    // TODO : Register all the variables declared with the factory over here
  `uvm_object_utils_end

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  // Description : Class constructor for parallel_to_serial transaction.
  //--------------------------------------------------------------------
  function new(string name = "parallel_to_serial_transaction");
    super.new(name);
  endfunction : new

  //--------------------------------------------------------------------
  // Method name : do_compare 
  // Arguments   : rhs- is the variable of type uvm_object.
  //               comparer - is the object of the uvm_comparer
  // Description : Method in which we do the user defined comparision 
  //--------------------------------------------------------------------
  virtual function bit do_compare(uvm_object rhs,uvm_comparer comparer);
    parallel_to_serial_transaction trans;

    // Cast the object type with transaction type
    if(!$cast(trans, rhs)) begin
     `uvm_error("do_compare","Incompatibale Types used in casting");
      return 0; 
    end//if(!$cast(trans, rhs)

   // TODO : Add the comparision over here

  endfunction : do_compare

  //--------------------------------------------------------------------
  // Method name : convert2string 
  // Description : This method return string with transaction variable values
  //--------------------------------------------------------------------
  virtual function string convert2string();
    string msg;
    
    // TODO - Update this to print required variables of the transaction with different transaction types.

    return msg;
  endfunction

endclass : parallel_to_serial_transaction

`endif // PARALLEL_TO_SERIAL_TRANSACTION_SVH
