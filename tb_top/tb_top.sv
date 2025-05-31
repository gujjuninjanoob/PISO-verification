`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;

    // Parameters
    parameter int DATA_WIDTH = 8;
    parameter int BAUD_CTRL_WIDTH = 2;

    // Clock period
    localparam time CLK_PERIOD = 20ns;

    // Interface instantiation
    parallel_to_serial_converter_intf #(
        .DATA_WIDTH(DATA_WIDTH),
        .BAUD_CTRL_WIDTH(BAUD_CTRL_WIDTH)
    ) m_intf();

    // DUT instantiation using DUT modport
    parallel_to_serial_converter #(
        .DATA_WIDTH(DATA_WIDTH),
        .BAUD_CTRL_WIDTH(BAUD_CTRL_WIDTH)
    ) dut (
        .DCLK (m_intf.DCLK),
        .RST_N (m_intf.RST_N),
        .DVALID (m_intf.DVALID),
        .DI (m_intf.DI),
        .CTRL_PARITY_EN (m_intf.CTRL_PARITY_EN),
        .CTRL_BAUD_RATE (m_intf.CTRL_BAUD_RATE),
        .TXD (m_intf.TXD)
    );

    // Clock generation
    initial begin
        m_intf.DCLK = 0;
        forever #(CLK_PERIOD/2) m_intf.DCLK = ~m_intf.DCLK;
    end

    // Reset generation
    initial begin
        m_intf.RST_N = 0;
        #100;
        m_intf.RST_N = 1;
    end

    // UVM test launch and interface config
    initial begin
        // Pass full interface handle for modport selection in UVM components
        uvm_config_db#(virtual parallel_to_serial_converter_intf)::set(null, "*", "vif", m_intf);

        // Start UVM test (default or specified via +UVM_TESTNAME)
        run_test();
    end

endmodule

Sent from Outlook for Android
