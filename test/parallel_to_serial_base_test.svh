class parallel_to_serial_base_test extends uvm_test;
  `uvm_component_utils(parallel_to_serial_base_test)

  parallel_to_serial_env m_env;
  parallel_to_serial_config m_cfg;
  parallel_to_serial_sequence m_seq;
  parallel_to_serial_transaction m_transaction;

  function new(string name = "parallel_to_serial_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_env = parallel_to_serial_env::type_id::create("m_env", this);

    // Create and set config object

    m_cfg = parallel_to_serial_config::type_id::create("m_cfg", this);
    m_cfg.en_checker_cov = 1;
    m_cfg.global_parity_en = 1;
    m_cfg.baud_rate = 2; // 38400 bps
    m_cfg.num_pkts = 10;
    m_cfg.agent_mode = UVM_ACTIVE;
    m_cfg.verb_dbg_msg_e = MEDIUM; // or as needed
    uvm_config_db#(parallel_to_serial_config)::set(this, "*", "parallel_to_serial_config", m_cfg);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);


    m_transaction = parallel_to_serial_transaction::type_id::create("m_transaction");

    // Randomize transaction
    if (!m_transaction.randomize() with {data_valid==1'b1;
                                         parity_enable==1'b1;
                                         parity_type==1'b1;
                                         parallel_data==$urandom;}) begin
      `uvm_error("TEST", "Randomization of transaction failed")
    end else begin
      `uvm_info("TEST", $sformatf("Randomized transaction: %s", m_transaction.convert2string()), m_cfg.verb_dbg_msg_e)
    end
      

    // Create sequence
    m_seq = parallel_to_serial_sequence::type_id::create("m_seq");
    m_seq.data_valid=m_transaction.data_valid;
    m_seq.parity_enable=m_transaction.parity_enable;
    m_seq.parity_type=m_transaction.parity_type;
    m_seq.parallel_data=m_transaction.parallel_data;
    
    for (int i = 0; i < m_cfg.num_pkts; i++) begin
      `uvm_info("BASE_TEST", $sformatf("Starting sequence %0d", i+1), m_cfg.verb_dbg_msg_e)
      seq.start(m_env.m_agent.m_sequencer,m_transaction);
    end 

    phase.drop_objection(this);
  endtask

endclass
