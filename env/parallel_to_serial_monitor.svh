//----------------------------------------------------------------------
// Description   : This is a monitor class for the parallel_to_serial agent. This component
//                 samples the data frmo the interface and create parallel_to_serial 
//                 transaction. It sends the sampled transaction on analysis
//                 port. It also contain all the checkers required for parallel_to_serial 
//                 with coverage.
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_MONITOR_SVH
`define PARALLEL_TO_SERIAL_MONITOR_SVH

class parallel_to_serial_monitor#(type REQ = parallel_to_serial_transaction) extends uvm_monitor#(REQ);

  //--------------------------------------------------------------------------
  // Object declarations
  //-------------------------------------------------------------------------
  // Transaction handle used to collect the transaction
  protected REQ m_trans_collected;

  // Handle of parallel_to_serial configuration type 
  protected parallel_to_serial_config m_cfg;

  //--------------------------------------------------------------------
  // Analysis Port declarations
  //--------------------------------------------------------------------
  uvm_analysis_port #(REQ) item_collected_port;

  //--------------------------------------------------------------------
  // Interface declarations
  //--------------------------------------------------------------------
  protected virtual interface parallel_to_serial_if.monitor_mp m_vif;

  //--------------------------------------------------------------------
  // Short hand macro registration 
  //--------------------------------------------------------------------
  `uvm_component_param_utils_begin(parallel_to_serial_monitor#(REQ))
   `uvm_field_object(m_cfg,UVM_ALL_ON)
    // TODO : Add all the local variables and objects over here to register them with factory
  `uvm_component_utils_end

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  //               patent - parent component object.
  // Description : Constructor for parallel_to_serial class objects.
  //------------------------------------------------------------------
  function new(string name = "parallel_to_serial_monitor",uvm_component parent);
    super.new(name,parent);

    // Create the analysis port
    item_collected_port = new("item_collected_port", this); 
  endfunction : new

  //--------------------------------------------------------------------
  // Method name : build_phase 
  // Arguments   : phase - Handle of uvm_phase.
  // Description : This phase create all the required objects.
  //-------------------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get parallel_to_serial configuartion
    m_cfg = m_cfg.get_cfg(this,"parallel_to_serial_config");
    
   `uvm_info("build_phase","In the build phase of monitor",m_cfg.verb_dbg_msg_e);

    // If interface is null, then it is not received from the top level hirerchey
    if((!uvm_config_db#(virtual parallel_to_serial_if)::get(this, "", "parallel_to_serial_if",m_vif)) && (m_vif == null)) begin
     `uvm_fatal("build_phase","The interface is not received in the parallel_to_serial_monitor");
    end
  endfunction : build_phase

  //--------------------------------------------------------------------
  // Method name : run_phase 
  // Arguments   : phase - Handle of uvm_phase.
  // Description : This phase samples interface and create transaction.
  //-------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Wait for the initial reset
    wait_for_reset();

    // Start the different threads to sample the interface and create transaction.
    forever begin
      fork begin
        fork
          begin : SAMPLE_PROTOTOTYPE_INTERFACE
            @(posedge m_vif.mon_cb);
            m_trans_collected = REQ::type_id::create("m_trans_collected");
            m_trans_collected.parallel_data = m_vif.mon_cb.DI;
            m_trans_collected.data_valid    = m_vif.mon_cb.DVALID;
            m_trans_collected.parity_enable = m_vif.mon_cb.CTRL_PARITY_EN;
            // fill parity_type, start_bit, stop_bit from protocol-specific logic if applicable
            `uvm_info(get_type_name(), $sformatf("Monitor collected: %s", m_trans_collected.convert2string()), UVM_MEDIUM)
            write_transaction(m_trans_collected);
      end
    end
          end : SAMPLE_PROTOTOTYPE_INTERFACE

          begin : EXIT_ON_RESET
            //if reset is received then break the running threads
            @(negedge m_vif.RST_N);
          end : EXIT_ON_RESET
        join_any
        disable fork;
      end join

      // Wait for reset
      wait_for_reset();
    end
  endtask : run_phase

  //--------------------------------------------------------------------
  // Method name : wait_for_reset 
  // Description : The method wait for the reset and initialize all the 
  //               interface and local variables when reset is asserted,
  //               and waits till reset is deasserted
  //--------------------------------------------------------------------
  virtual task wait_for_reset();
    // Wait for reset to be asserted
    wait(m_vif.RST_N == 0);
   `uvm_info("wait_for_reset","Reset is Asserted",m_cfg.verb_dbg_msg_e)

    // Wait for reset to be deasserted
    @(posedge m_vif.RST_N);
   `uvm_info("wait_for_reset","Reset is Deasserted",m_cfg.verb_dbg_msg_e)
  endtask : wait_for_reset

  //--------------------------------------------------------------------
  // Method name : write_transaction 
  // Arguments   : trans - Handle of parallel_to_serial transaction.
  // Description : This method writes the transactions on the analysis 
  //               port. 
  //-------------------------------------------------------------------
  function void write_transaction(REQ trans);
    // Print the collected transaction
   `uvm_info("write_transaction",$psprintf("Transaction Collected in the monitor is : \n%0s", 
      trans.sprint()),m_cfg.verb_imp_msg_e);

    // Populate the transaction
    item_collected_port.write(trans);

  endfunction : write_transaction

endclass : parallel_to_serial_monitor

`endif // PARALLEL_TO_SERIAL_MONITOR_SVH
