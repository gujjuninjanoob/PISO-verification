// Description   : This is a agent class having the instances of parallel_to_serial
//                 driver, parallel_to_serial sequencer and parallel_to_serial monitor.
//                 The agent can be configured as either ACTIVE or PASSIVE. 
//----------------------------------------------------------------------

`ifndef PARALLEL_TO_SERIAL_AGENT_SVH
`define PARALLEL_TO_SERIAL_AGENT_SVH

class parallel_to_serial_agent extends uvm_agent;

  //--------------------------------------------------------------------
  // Components declarations
  //--------------------------------------------------------------------
  // Handle of the parallel_to_serial driver
  parallel_to_serial_driver m_driver;

  // Handle of the parallel_to_serial sequencer 
  parallel_to_serial_sequencer m_sequencer;

  // Handle of the parallel_to_serial monitor 
  parallel_to_serial_monitor m_monitor;

  // Handle of the parallel_to_serial configurations
  parallel_to_serial_config m_cfg;
  
  //Handle of parallel_to_serial_if 
  virtual parallel_to_serial_if m_vif;

  // UVM factory registraction
  `uvm_component_utils_begin(parallel_to_serial_agent)
   `uvm_field_object(m_driver    , UVM_ALL_ON)
   `uvm_field_object(m_sequencer , UVM_ALL_ON)
   `uvm_field_object(m_monitor   , UVM_ALL_ON)
   `uvm_field_object(m_cfg       , UVM_ALL_ON)
  `uvm_component_utils_end

  //--------------------------------------------------------------------
  // Method name : new
  // Arguments   : name - Name of the object.
  //               parent - parent component object.
  // Description : Constructor for parallel_to_serial agent class
  //--------------------------------------------------------------------
  function new(string name = "parallel_to_serial_agent",uvm_component parent);
    super.new(name,parent);
  endfunction : new
   
  //--------------------------------------------------------------------
  // Method name : build_phase 
  // Arguments   : phase - Handle of uvm_phase.
  // Description : This phase creates all the components of parallel_to_serial agent 
  //--------------------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);

    // Calling the build method of the parent class
    super.build_phase(phase);
   //Getting the interface Handle
    if (!uvm_config_db#(virtual parallel_to_serial_if)::get(this, "", "vif", m_vif)) begin
  `uvm_fatal("NOVIF", "Virtual interface not set in config DB for agent")
   end 
    m_driver.vif = vif;
    m_monitor.vif = vif;
    // Get the configuration
    m_cfg = parallel_to_serial_config::get_cfg(this,"parallel_to_serial_config");
    
    if (m_cfg != null) begin
    this.is_active = m_cfg.agent_mode;
    end else begin
    `uvm_warning("PAR_TO_SER_AGENT", "Config object not found; defaulting is_active to UVM_ACTIVE")
    this.is_active = UVM_ACTIVE;
    end
    
    // If configuration is active then create the driver, sequencer, monitor
    if(is_active == UVM_ACTIVE) begin

      // Create the parallel_to_serial driver
      m_driver = parallel_to_serial_driver#(parallel_to_serial_transaction)::type_id::create("m_driver",this);

      // Create the parallel_to_serial sequencer 
      m_sequencer = parallel_to_serial_sequencer::type_id::create("m_sequencer",this);

      // Create the parallel_to_serial monitor
      m_monitor = parallel_to_serial_monitor#(parallel_to_serial_transaction)::type_id::create("m_monitor",this);
    end//if(is_active == 

    // If configuration is passive then create only monitor
    else if(is_active == UVM_PASSIVE) begin

      // Create the parallel_to_serial monitor
      m_monitor = parallel_to_serial_monitor#(parallel_to_serial_transaction)::type_id::create("m_monitor",this);
    end//else if

  endfunction : build_phase

  //--------------------------------------------------------------------
  // Method name : connect_phase 
  // Arguments   : phase - Handle of uvm_phase.
  // Description : This phase establish the connections between different
  //               parallel_to_serial agent components.
  //--------------------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // If the configuration is set to ACTIVE, connect the sequencer and driver
    if(is_active == UVM_ACTIVE)begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end//is_active
  endfunction : connect_phase

 //---------------------------------------------------------------------------
 // Method      : end_of_elaboration 
 // Description : This method prints configuration.
 //---------------------------------------------------------------------------
 virtual function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
  `uvm_info("end_of_elaboration",$sformatf("parallel_to_serial Configuration is: \n%0s",m_cfg.sprint()), m_cfg.verb_imp_msg_e)
 endfunction : end_of_elaboration_phase 
endclass : parallel_to_serial_agent

`endif//PARALLEL_TO_SERIAL_AGENT_SVH
