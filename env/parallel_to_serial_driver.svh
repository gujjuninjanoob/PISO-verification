//----------------------------------------------------------------------
// Description   : This is the drivr class of the parallel_to_serial agent.
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_DRIVER_SVH
`define PARALLEL_TO_SERIAL_DRIVER_SVH

class parallel_to_serial_driver#(type REQ = parallel_to_serial_transaction) extends uvm_driver#(REQ);

  //--------------------------------------------------------------------
  // Interface declarations
  //--------------------------------------------------------------------
  protected virtual interface parallel_to_serial_if.driver_mp m_vif;
 
  //--------------------------------------------------------------------
  // Object declarations
  //--------------------------------------------------------------------
  protected parallel_to_serial_config m_cfg;

  //--------------------------------------------------------------------
  // Variable declarations
  //--------------------------------------------------------------------

  //---------------------------------------------------------------
  // UVM factory registration 
  //---------------------------------------------------------------
  `uvm_component_param_utils(parallel_to_serial_driver#(REQ))


  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  //               patent - parent component object.
  // Description : Constructor for parallel_to_serial driver class.
  //-------------------------------------------------------------------
  function new(string name = "parallel_to_serial_driver",uvm_component parent);
    super.new(name,parent);     
  endfunction : new

  //--------------------------------------------------------------------
  // Method name : build_phase 
  // Arguments   : phase - Handle of uvm_phase.
  // Description : This phase creates all the  of parallel_to_serial agent 
  //-------------------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get the configuration variable from top level hierechy
    m_cfg = m_cfg.get_cfg(this,"parallel_to_serial_config");

   `uvm_info("build_phase","build phase of driver",m_cfg.verb_dbg_msg_e);
    
    // If interface is null, then it is not received from the top level hirerchey
    if((!uvm_config_db#(virtual parallel_to_serial_if)::get(this, "", "parallel_to_serial_if",m_vif)) 
        && (m_vif == null)) begin 

      `uvm_fatal("build_phase","parallel_to_serial interface is not received in the driver"); 
    end // if
  endfunction : build_phase

  //--------------------------------------------------------------------
  // Method name : run_phase 
  // Arguments   : phase - Handle of the uvm_phase.
  // Description : The phase in which the TB execution starts
  //               This phase collects the transaction from the 
  //               sequence item port and send the transaction on
  //               interface
  //-------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Wait for the reset to be de-asserted
    wait_for_reset();
    forever begin
      fork begin
        fork

          // Collect the transaction from the sequence item port
          begin : PROCESS_parallel_to_serial_REQ
            forever begin

              // Get the sequence item from the sequence item port
              seq_item_port.get_next_item(req);

              // Raise the objection after item is received from sequencer
              phase.raise_objection(this);
              
               REQ rsp;     
              // Cast the request with the response packet
              $cast(rsp,req.clone());

              // Drive the packet on the interface       
              drive_pkt(rsp);

              // Set the id info for the request
              rsp.set_id_info(req);
              
              // Send the item_done to the parallel_to_serial_sequencer
              seq_item_port.item_done(rsp);

              // Drop the objection after item done is sent to sequencer
              phase.drop_objection(this);
            end//forever begin

          end : PROCESS_parallel_to_serial_REQ

          begin : EXIT_ON_RESET
            // Reset is asserted
            @(negedge m_vif.RST_N);
          end : EXIT_ON_RESET
        join_any

        //disable the thread as the reset is received
        disable fork;
      end join

      // Wait for reset to initialize the interface signals to default values
      wait_for_reset();
    end//forever
  endtask : run_phase

  //--------------------------------------------------------------------
  // Method name : drive_pkt 
  // Arguments   : trans - Handle of the transaction type.
  // Description : The method has the logic to drive the packet on the
  //               interface as per the protocol
  //--------------------------------------------------------------------
  virtual task drive_pkt(REQ trans);

    // Print the transaction 
    // Wait for clocking block edge
    @(vif.drv_cb);
    m_vif.drv_cb.DI                <= trans.parallel_data;
    m_vif.drv_cb.DVALID            <= trans.data_valid;
    m_vif.drv_cb.CTRL_PARITY_EN    <= trans.parity_enable;
    m_vif.drv_cb.CTRL_PARITY_TYPE  <= trans.parity_type;
    m_vif.drv_cb.START             <= trans.start_bit;
    m_vif.drv_cb.STOP              <= trans.stop_bit;

    // Hold for a cycle, then deassert DVALID
    repeat (1) @(m_vif.drv_cb);
    m_vif.drv_cb.DVALID <= 0;


  endtask : drive_pkt

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

    // TODO: Reset interface signals if needed
    // e.g., m_vif.drv_cb.DVALID <= 0; m_vif.drv_cb.DI <= '0;

    // Wait for reset to be deasserted
    @(posedge m_vif.RST_N);
   `uvm_info("wait_for_reset","Reset is Deasserted",m_cfg.verb_dbg_msg_e)
  endtask : wait_for_reset

endclass : parallel_to_serial_driver  


`endif // PARALLEL_TO_SERIAL_DRIVER_SVH
