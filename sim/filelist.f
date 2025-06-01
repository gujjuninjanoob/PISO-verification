+incdir+./ENV
+incdir+./TB_TOP
+incdir+./TEST
+incdit+./DUT

// DUT
DUT/piso.v

// ENV (recommended order)
ENV/parallel_to_serial_pkg.sv

// Interface and TB
TB_TOP/parallel_to_serial_intf.sv
TB_TOP/tb_top.sv

// Test
TEST/parallel_to_serial_test_list.sv
