interface parallel_to_serial_converter_intf #(
    parameter int DATA_WIDTH = 8,
    parameter int BAUD_CTRL_WIDTH = 2
);

    // Clock and Reset
    logic DCLK;
    logic RST_N;

    // Parallel Data Input
    logic DVALID;
    logic [DATA_WIDTH-1:0] DI;

    // Control Signals
    logic CTRL_PARITY_EN;
    logic [BAUD_CTRL_WIDTH-1:0] CTRL_BAUD_RATE;

    // Serial Output
    logic TXD;

    // Clocking block for DRIVER (active drives)
    clocking drv_cb @(posedge DCLK);
        default input #1step output #1step;
        output DVALID;
        output DI;
        output CTRL_PARITY_EN;
        output CTRL_BAUD_RATE;
        input TXD;
    endclocking

    // Clocking block for MONITOR (passive reads)
    clocking mon_cb @(posedge DCLK);
        default input #1step output #1step;
        input DVALID;
        input DI;
        input CTRL_PARITY_EN;
        input CTRL_BAUD_RATE;
        input TXD;
    endclocking

    // Modport for DUT connection
    modport DUT (
        input DCLK, RST_N,
        input DVALID, DI, CTRL_PARITY_EN, CTRL_BAUD_RATE,
        output TXD
    );

    // Modport for UVM Driver (using driver clocking block)
    modport driver_cb (
        clocking drv_cb,
        output DCLK, RST_N
    );

    // Modport for UVM Monitor (using monitor clocking block)
    modport monitor_cb (
        clocking mon_cb,
        input DCLK, RST_N
    );

endinterface
