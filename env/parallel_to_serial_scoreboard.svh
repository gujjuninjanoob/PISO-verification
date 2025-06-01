`ifndef PARALLEL_TO_SERIAL_SCOREBOARD_SVH
`define PARALLEL_TO_SERIAL_SCOREBOARD_SVH

class parallel_to_serial_scoreboard #(type REQ = parallel_to_serial_transaction) extends uvm_scoreboard#(REQ);

  `uvm_component_param_utils(parallel_to_serial_scoreboard#(REQ))

  uvm_analysis_export #(parallel_to_serial_transaction#(REQ)) item_export;
  uvm_tlm_analysis_fifo #(parallel_to_serial_transaction#(REQ)) item_fifo;

  virtual parallel_to_serial_if m_vif;

  int unsigned mismatch_count;
  bit [1023:0] expected_frame_buffer;
  int frame_len;
  int total_frames_checked;

  function new(string name = "parallel_to_serial_scoreboard", uvm_component parent);
    super.new(name, parent);
    mismatch_count = 0;
    expected_frame_buffer = '0;
    frame_len = 0;
    total_frames_checked = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
    item_fifo = new("item_fifo", this);
    item_export.connect(item_fifo.analysis_export);

    m_cfg = m_cfg.get_cfg(this,"parallel_to_serial_config");
    
    `uvm_info("build_phase","In the build phase of SCOREBOARD",m_cfg.verb_dbg_msg_e);

    // If interface is null, then it is not received from the top level hirerchey
    if((!uvm_config_db#(virtual parallel_to_serial_if)::get(this, "", "parallel_to_serial_if",m_vif)) && (m_vif == null)) begin
     `uvm_fatal("build_phase","The interface is not received in the parallel_to_serial_monitor");
  endfunction

  task run_phase(uvm_phase phase);
    parallel_to_serial_transaction#(WIDTH) tr;
    forever begin
      item_fifo.get(tr);
      tr.do_print();
      check_serial_output(tr);
    end
  endtask

  task check_serial_output(parallel_to_serial_transaction#(WIDTH) tr);
    bit [WIDTH+2:0] expected_bits;
    bit parity_bit;
    int bit_count;

    expected_bits = 0;
    bit_count = 0;

    expected_bits[bit_count] = 1'b0; // Start bit
    bit_count++;

    for (int i = 0; i < WIDTH; i++) begin
      expected_bits[bit_count] = tr.parallel_data[i];
      bit_count++;
    end

    if (tr.parity_enable) begin
      parity_bit = ^tr.parallel_data;
      if (tr.parity_type == 1) // ODD parity
        parity_bit = ~parity_bit;

      expected_bits[bit_count] = parity_bit;
      bit_count++;
    end

    expected_bits[bit_count] = 1'b1; // Stop bit
    bit_count++;

    expected_frame_buffer = 0;
    frame_len = bit_count;

    @(posedge m_vif.DCLK);
    for (int i = 0; i < frame_len; i++) begin
      expected_frame_buffer[i] = expected_bits[i];
    end

    for (int i = 0; i < frame_len; i++) begin
      if (m_vif.TXD !== expected_frame_buffer[i]) begin
        `uvm_error("SCOREBOARD", $sformatf("Mismatch at bit[%0d]: Expected %0b, Got %0b", i, expected_frame_buffer[i], m_vif.TXD))
        mismatch_count++;
      end else begin
        `uvm_info("SCOREBOARD", $sformatf("Bit[%0d] matched: %0b", i, m_vif.TXD), m_cfg.verb_dbg_msg_e)
      end
      @(posedge m_vif.DCLK);
    end

    total_frames_checked++;
    `uvm_info("SCOREBOARD", $sformatf("Frame %0d checked. Mismatches this frame: %0d", total_frames_checked, mismatch_count), m_cfg.verb_dbg_msg_e)
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (total_frames_checked == 0) begin
      `uvm_error("SCOREBOARD", "No transactions were received and processed in the scoreboard.")
    end else begin
      `uvm_info("SCOREBOARD", $sformatf("Total frames checked: %0d", total_frames_checked), m_cfg.verb_dbg_msg_e)
      `uvm_info("SCOREBOARD", $sformatf("Total mismatches: %0d", mismatch_count), m_cfg.verb_dbg_msg_e)
    end
  endfunction

endclass

`endif // PARALLEL_TO_SERIAL_SCOREBOARD_SVH
