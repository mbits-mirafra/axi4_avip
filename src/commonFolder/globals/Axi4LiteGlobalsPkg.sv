`ifndef AXI4LITEGLOBALSPKG_INCLUDED
`define AXI4LITEGLOBALSPKG_INCLUDED

package Axi4LiteGlobalsPkg;

  parameter bit MASTER_AGENT_ACTIVE = 1;

  parameter bit SLAVE_AGENT_ACTIVE = 1;

  parameter int NO_OF_MASTERS = 1;

  parameter int NO_OF_SLAVES = 1;

  parameter int ADDRESS_WIDTH = 32;

  parameter int DATA_WIDTH = 32;

  parameter int DELAY_WIDTH = 4;

  parameter int DELAY_VALUE = 16;

  parameter DELAY_VALUE0  = 4'b0000;
  parameter DELAY_VALUE1  = 4'b0001;
  parameter DELAY_VALUE2  = 4'b0010;
  parameter DELAY_VALUE3  = 4'b0011;
  parameter DELAY_VALUE4  = 4'b0100;
  parameter DELAY_VALUE5  = 4'b0101;
  parameter DELAY_VALUE6  = 4'b0110;
  parameter DELAY_VALUE7  = 4'b0111;
  parameter DELAY_VALUE8  = 4'b1000;
  parameter DELAY_VALUE9  = 4'b1001;
  parameter DELAY_VALUE10 = 4'b1010;
  parameter DELAY_VALUE11 = 4'b1011;
  parameter DELAY_VALUE12 = 4'b1100;
  parameter DELAY_VALUE13 = 4'b1101;
  parameter DELAY_VALUE14 = 4'b1110;
  parameter DELAY_VALUE15 = 4'b1111;

  typedef enum bit {
    BIG_ENDIAN    = 1'b0,
    LITTLE_ENDIAN = 1'b1
  } endianEnum;

  typedef enum bit [2:0] {
    WRITE_NORMAL_SECURE_DATA               = 3'b000,
    WRITE_NORMAL_SECURE_INSTRUCTION        = 3'b001,
    WRITE_NORMAL_NONSECURE_DATA            = 3'b010,
    WRITE_NORMAL_NONSECURE_INSTRUCTION     = 3'b011,
    WRITE_PRIVILEGED_SECURE_DATA           = 3'b100,
    WRITE_PRIVILEGED_SECURE_INSTRUCTION    = 3'b101,
    WRITE_PRIVILEGED_NONSECURE_DATA        = 3'b110,
    WRITE_PRIVILEGED_NONSECURE_INSTRUCTION = 3'b111
  } awprotEnum;

  typedef enum bit [2:0] {
    READ_NORMAL_SECURE_DATA               = 3'b000,
    READ_NORMAL_SECURE_INSTRUCTION        = 3'b001,
    READ_NORMAL_NONSECURE_DATA            = 3'b010,
    READ_NORMAL_NONSECURE_INSTRUCTION     = 3'b011,
    READ_PRIVILEGED_SECURE_DATA           = 3'b100,
    READ_PRIVILEGED_SECURE_INSTRUCTION    = 3'b101,
    READ_PRIVILEGED_NONSECURE_DATA        = 3'b110,
    READ_PRIVILEGED_NONSECURE_INSTRUCTION = 3'b111
  } arprotEnum;


  typedef enum bit [1:0] {
    WRITE_OKAY   = 2'b00,
    WRITE_EXOKAY = 2'b01,
    WRITE_SLVERR = 2'b10,
    WRITE_DECERR = 2'b11
  } brespEnum;

  typedef enum bit [1:0] {
    READ_OKAY   = 2'b00,
    READ_EXOKAY = 2'b01,
    READ_SLVERR = 2'b10,
    READ_DECERR = 2'b11
  } rrespEnum;

  typedef enum bit {
    WRITE = 1,
    READ  = 0
  } transactionTypeEnum;

  typedef enum bit[1:0] {
    BLOCKING_WRITE      = 2'b00, 
    BLOCKING_READ       = 2'b01, 
    NON_BLOCKING_WRITE  = 2'b10, 
    NON_BLOCKING_READ   = 2'b11 
  }transferTypeEnum;

  
  typedef struct {
    bit [DELAY_WIDTH-1:0]   writeDelayForReady;
  } axi4LiteWriteTransferCharStruct; 

  typedef struct {
    bit [DELAY_WIDTH-1:0]   readDelayForReady;
  } axi4LiteReadTransferCharStruct;

  typedef struct {
    bit [DELAY_WIDTH-1:0] delayForReadyWriteCfgValue;
  } axi4LiteWriteTransferCfgStruct;

  typedef struct {
    bit [DELAY_WIDTH-1:0] delayForReadyReadCfgValue;
  } axi4LiteReadTransferCfgStruct;

endpackage : Axi4LiteGlobalsPkg
`endif

