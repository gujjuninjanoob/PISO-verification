// Declaring all the required parameters
`ifndef PARALLEL_TO_SERIAL_PARAMS_PKG_SVH
`define PARALLEL_TO_SERIAL_PARAMS_PKG_SVH   
package parallel_to_serial_params_pkg;
//BAUD_RATE
  parameter bit [1:0] BAUD_9600=2'b00;
  parameter bit [1:0] BAUD_19200=2'b01;
  parameter bit [1:0] BAUD_38400=2'b10;
  parameter bit [1:0] BAUD_115200=2'b11;
  //Parity Enable and Disable
  parameter bit PARITY_DISABLED=1'b0;
  parameter bit PARITY_ENABLED=1'b1;
  //Num of packets
  parameter int MIN_NUM_PACKETS=1;
  parameter int MAX_NUM_PACKETS=1000;
  
  
endpackage  
`endif //PARALLEL_TO_SERIAL_PARAMS_PKG_SVH
