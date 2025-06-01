`ifndef PARALLEL_TO_SERIAL_ENV_SVH
`define PARALLEL_TO_SERIAL_ENV_SVH

class parallel_to_serial_env #(type REQ = parallel_to_serial_transaction) extends uvm_env#(REQ);

  `uvm_component_param_utils(parallel_to_serial_env#(REQ)

  // Sub-components
   parallel_to_serial_driver #(REQ)   m_driver;
   parallel_to_serial_monitor #(REQ) m_monitor;
   parallel_to_serial_scoreboard #(REQ) m_scoreboard;

  // Virtual interface
  virtual parallel_to_serial_if m_vif;

  // Configuration object
  parallel_to_serial_config m_cfg;

  function new(string name = "parallel_to_serial_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get virtual interface
    if (!uvm_config_db#(virtual parallel_to_serial_if)::get(this, "", "parallel_to_serial_if", m_vif)) begin
      `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB")
    end

    // Get configuration object
    if (!uvm_config_db#(parallel_to_serial_config)::get(this, "", "parallel_to_serial_cfg", m_cfg)) begin
      `uvm_info(get_type_name(), "Config object not found, creating default one", m_cfg.verb_dbg_msg_e)
      m_cfg = parallel_to_serial_config::type_id::create("m_cfg", this);
    end else begin
      `uvm_info(get_type_name(), $sformatf("Config loaded: verbosity=%0d", m_cfg.verb_dbg_msg_e), m_cfg.verb_dbg_msg_e)
    end

    // Instantiate sub-components
    m_driver = parallel_to_serial_driver#(WIDTH)::type_id::create("m_driver", this);
    m_monitor = parallel_to_serial_monitor#(WIDTH)::type_id::create("m_monitor", this);
    m_scoreboard = parallel_to_serial_scoreboard#(WIDTH)::type_id::create("m_scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect m_driver and m_monitor to virtual interface
    m_driver.m_vif = m_vif;
    m_monitor.m_vif = m_vif;

    // Pass config object to subcomponents (optional, if they have m_cfg handles)
    if (m_driver.has_field("m_cfg")) m_driver.m_cfg = m_cfg;
    if (m_monitor.has_field("m_cfg")) m_monitor.m_cfg = m_cfg;
    if (m_scoreboard.has_field("m_cfg")) m_scoreboard.m_cfg = m_cfg;

    // Connect m_monitor analysis port to m_scoreboard
    m_monitor.item_analysis_port.connect(m_scoreboard.item_export);
  endfunction

endclass

`endif // PARALLEL_TO_SERIAL_ENV_SVH
