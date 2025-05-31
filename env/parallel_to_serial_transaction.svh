/----------------------------------------------------------------------
// Description   : This is the transaction class for parallel_to_serial UVC. 
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_TRANSACTION_SVH
`define PARALLEL_TO_SERIAL_TRANSACTION_SVH

class parallel_to_serial_transaction extends uvm_transaction;

  //--------------------------------------------------------------------
  // Variables declarations
  //------------------------------------------------------------------
    rand bit [WIDTH-1:0] parallel_data;
    rand bit data_valid;
    rand bit parity_enable;
    rand bit parity_type;
    rand bit start_bit;
    rand bit stop_bit;
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

    if (this.parallel_data    !== trans.parallel_data)    return 0;
    if (this.data_valid       !== trans.data_valid)       return 0;
    if (this.parity_enable    !== trans.parity_enable)    return 0;
    if (this.parity_type      !== trans.parity_type)      return 0;
    if (this.start_bit        !== trans.start_bit)        return 0;
    if (this.stop_bit         !== trans.stop_bit)         return 0;

    return 1;

  endfunction : do_compare

  //--------------------------------------------------------------------
  // Method name : convert2string 
  // Description : This method return string with transaction variable values
  //--------------------------------------------------------------------
  virtual function string convert2string();
    string msg;
    $sformat(msg, "parallel_data = 0x%0h, data_valid = %0b, parity_enable = %0b, parity_type = %0b, start_bit = %0b, stop_bit = %0b",
             parallel_data, data_valid, parity_enable, parity_type, start_bit, stop_bit);
    return msg;
endfunction : convert2string

endclass : parallel_to_serial_transaction

`endif // PARALLEL_TO_SERIAL_TRANSACTION_SVH
