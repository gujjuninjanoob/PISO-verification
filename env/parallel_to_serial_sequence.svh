//----------------------------------------------------------------------
// Description   : This is a base sequence class for parallel_to_serial UVC. 
//                 All the UVC sequences will be extended from this
//                 sequence. This sequence have the common methods 
//                 to be used by other derived sequences. 
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_SEQUENCES_SVH
`define PARALLEL_TO_SERIAL_SEQUENCES_SVH

class parallel_to_serial_sequence extends uvm_sequence#(parallel_to_serial_transaction);

  `uvm_object_utils(parallel_to_serial_seq)

  // Local variables matching transaction fields
  rand bit [7:0]    parallel_data;
  rand bit          data_valid;
  rand bit          parity_enable;
  rand bit          parity_type;
  rand bit          start_bit;
  rand bit          stop_bit;

  // Handle to config object
  parallel_to_serial_config m_cfg;

  // Constructor
  function new(string name = "parallel_to_serial_sequence ");
    super.new(name);
  endfunction

  // sequence body
  virtual task body();
    // Get config from parent hierarchy
    if (!uvm_config_db#(parallel_to_serial_config)::get(null, get_full_name(), "parallel_to_serial_config", m_cfg)) begin
      `uvm_fatal(get_type_name(), "Unable to get parallel_to_serial_config from config DB")
    end

    `uvm_info(get_type_name(), "Starting randomized parallel_to_serial sequence", m_cfg.verb_dbg_msg_e)

    // Create and initialize transaction
    parallel_to_serial_transaction tx;
    tx = parallel_to_serial_transaction::type_id::create("tx");

    // Randomize local sequence variables
    if (!randomize()) begin
      `uvm_error(get_type_name(), "Randomization failed for sequence-local variables")
      return;
    end

    // Assign values to transaction fields
    tx.parallel_data  = parallel_data;
    tx.data_valid     = data_valid;
    tx.parity_enable  = parity_enable;
    tx.parity_type    = parity_type;
    tx.start_bit      = start_bit;
    tx.stop_bit       = stop_bit;

    // Start and send item
    start_item(tx);
    if (!tx.randomize()) begin
      `uvm_warning(get_type_name(), "Randomization failed for transaction — using assigned values only")
    end
    finish_item(tx);

    // Print transaction info
    tx.do_print();
    `uvm_info(get_type_name(), $sformatf("Sent transaction: %s", tx.convert2string()), m_cfg.verb_dbg_msg_e)
  endtask

endclass : parallel_to_serial_sequence 

`endif // PARALLEL_TO_SERIAL_SEQUENCES_SVH
