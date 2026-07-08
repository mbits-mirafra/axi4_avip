# AXI4 AVIP — Verification Plan (Standalone Slave Mode)

| S.No | Sections | Features | Sub-Features | Description | Status | Testcase Name |
|------|----------|----------|--------------|-------------|--------|---------------|
| 1 | Standalone Slave | Base | write & read | Basic write+read, master passive | DONE | axi4_non_outstanding_write_read_test |
| 2 | Standalone Slave | Ordered | 32b write & read | 32b ordered write+read responses | DONE | axi4_32b_ordered_write_read_test |
| 3 | Standalone Slave | Response | okay write | OKAY write response | DONE | axi4_non_outstanding_okay_response_write_test |
|   |   |   | okay read | OKAY read response | DONE | axi4_non_outstanding_okay_response_read_test |
|   |   |   | okay write & read | OKAY write+read response | DONE | axi4_non_outstanding_okay_response_write_read_test |
|   |   |   | exokay write | EXOKAY (exclusive) write response | DONE | axi4_non_outstanding_exokay_response_write_test |
|   |   |   | exokay read | EXOKAY (exclusive) read response | DONE | axi4_non_outstanding_exokay_response_read_test |
| 4 | Standalone Slave | Non-Outstanding · 8 bits | write data | 8b write data | DONE | axi4_non_outstanding_8b_write_data_test |
|   |   |   | data read | 8b read data | DONE | axi4_non_outstanding_8b_data_read_test |
|   |   |   | write & read | 8b write read | DONE | axi4_non_outstanding_8b_write_read_test |
| 5 | Standalone Slave | Non-Outstanding · 16 bits | write data | 16b write data | DONE | axi4_non_outstanding_16b_write_data_test |
|   |   |   | data read | 16b read data | DONE | axi4_non_outstanding_16b_data_read_test |
|   |   |   | write & read | 16b write read | DONE | axi4_non_outstanding_16b_write_read_test |
| 6 | Standalone Slave | Non-Outstanding · 32 bits | write data | 32b write data | DONE | axi4_non_outstanding_32b_write_data_test |
|   |   |   | data read | 32b read data | DONE | axi4_non_outstanding_32b_data_read_test |
|   |   |   | write & read | 32b write read | DONE | axi4_non_outstanding_32b_write_read_test |
| 7 | Standalone Slave | Non-Outstanding · 64 bits | write data | 64b write data | DONE | axi4_non_outstanding_64b_write_data_test |
|   |   |   | data read | 64b read data | DONE | axi4_non_outstanding_64b_data_read_test |
|   |   |   | write & read | 64b write read | DONE | axi4_non_outstanding_64b_write_read_test |
| 8 | Standalone Slave | Non-Outstanding · 128 bits | write data | 128b write data | DONE | axi4_non_outstanding_128b_write_data_test |
|   |   |   | data read | 128b read data | DONE | axi4_non_outstanding_128b_data_read_test |
|   |   |   | write & read | 128b write read | DONE | axi4_non_outstanding_128b_write_read_test |
|   |   |   | fixed burst | 128b fixed burst write read | DONE | axi4_non_outstanding_128b_fixed_burst_write_read_test |
|   |   |   | wrap burst | 128b wrap burst write read | DONE | axi4_non_outstanding_128b_wrap_burst_write_read_test |
| 9 | Standalone Slave | Non-Outstanding · 256 bits | write data | 256b write data | DONE | axi4_non_outstanding_256b_write_data_test |
|   |   |   | data read | 256b read data | DONE | axi4_non_outstanding_256b_data_read_test |
|   |   |   | write & read | 256b write read | DONE | axi4_non_outstanding_256b_write_read_test |
|   |   |   | fixed burst | 256b fixed burst write read | DONE | axi4_non_outstanding_256b_fixed_burst_write_read_test |
|   |   |   | wrap burst | 256b wrap burst write read | DONE | axi4_non_outstanding_256b_wrap_burst_write_read_test |
| 10 | Standalone Slave | Non-Outstanding · 512 bits | write data | 512b write data | DONE | axi4_non_outstanding_512b_write_data_test |
|   |   |   | data read | 512b read data | DONE | axi4_non_outstanding_512b_data_read_test |
|   |   |   | write & read | 512b write read | DONE | axi4_non_outstanding_512b_write_read_test |
|   |   |   | fixed burst | 512b fixed burst write read | DONE | axi4_non_outstanding_512b_fixed_burst_write_read_test |
|   |   |   | wrap burst | 512b wrap burst write read | DONE | axi4_non_outstanding_512b_wrap_burst_write_read_test |
| 11 | Standalone Slave | Non-Outstanding · Burst | incr write | INCR burst write | DONE | axi4_non_outstanding_incr_burst_write_test |
|   |   |   | incr read | INCR burst read | DONE | axi4_non_outstanding_incr_burst_read_test |
|   |   |   | incr write & read | INCR burst write read | DONE | axi4_non_outstanding_incr_burst_write_read_test |
|   |   |   | wrap write | WRAP burst write | DONE | axi4_non_outstanding_wrap_burst_write_test |
|   |   |   | wrap read | WRAP burst read | DONE | axi4_non_outstanding_wrap_burst_read_test |
|   |   |   | wrap write & read | WRAP burst write read | DONE | axi4_non_outstanding_wrap_burst_write_read_test |
|   |   |   | fixed write & read | FIXED burst write read | DONE | axi4_non_outstanding_fixed_burst_write_read_test |
| 12 | Standalone Slave | Outstanding · 8 bits | write data | 8b write data | DONE | axi4_outstanding_8b_write_data_test |
|   |   |   | data read | 8b read data | DONE | axi4_outstanding_8b_data_read_test |
|   |   |   | write & read | 8b write read | DONE | axi4_outstanding_8b_write_read_test |
| 13 | Standalone Slave | Outstanding · 16 bits | write data | 16b write data | DONE | axi4_outstanding_16b_write_data_test |
|   |   |   | data read | 16b read data | DONE | axi4_outstanding_16b_data_read_test |
|   |   |   | write & read | 16b write read | DONE | axi4_outstanding_16b_write_read_test |
| 14 | Standalone Slave | Outstanding · 32 bits | write data | 32b write data | DONE | axi4_outstanding_32b_write_data_test |
|   |   |   | data read | 32b read data | DONE | axi4_outstanding_32b_data_read_test |
|   |   |   | write & read | 32b write read | DONE | axi4_outstanding_32b_write_read_test |
| 15 | Standalone Slave | Outstanding · 64 bits | write data | 64b write data | DONE | axi4_outstanding_64b_write_data_test |
|   |   |   | data read | 64b read data | DONE | axi4_outstanding_64b_data_read_test |
|   |   |   | write & read | 64b write read | DONE | axi4_outstanding_64b_write_read_test |
| 16 | Standalone Slave | Outstanding · 128 bits | write data | 128b write data | DONE | axi4_outstanding_128b_write_data_test |
|   |   |   | data read | 128b read data | DONE | axi4_outstanding_128b_data_read_test |
|   |   |   | write & read | 128b write read | DONE | axi4_outstanding_128b_write_read_test |
|   |   |   | fixed burst | 128b fixed burst write read | DONE | axi4_outstanding_128b_fixed_burst_write_read_test |
|   |   |   | wrap burst | 128b wrap burst write read | DONE | axi4_outstanding_128b_wrap_burst_write_read_test |
| 17 | Standalone Slave | Outstanding · 256 bits | write data | 256b write data | DONE | axi4_outstanding_256b_write_data_test |
|   |   |   | data read | 256b read data | DONE | axi4_outstanding_256b_data_read_test |
|   |   |   | write & read | 256b write read | DONE | axi4_outstanding_256b_write_read_test |
|   |   |   | fixed burst | 256b fixed burst write read | DONE | axi4_outstanding_256b_fixed_burst_write_read_test |
|   |   |   | wrap burst | 256b wrap burst write read | DONE | axi4_outstanding_256b_wrap_burst_write_read_test |
| 18 | Standalone Slave | Outstanding · 512 bits | write data | 512b write data | DONE | axi4_outstanding_512b_write_data_test |
|   |   |   | data read | 512b read data | DONE | axi4_outstanding_512b_data_read_test |
|   |   |   | write & read | 512b write read | DONE | axi4_outstanding_512b_write_read_test |
|   |   |   | fixed burst | 512b fixed burst write read | DONE | axi4_outstanding_512b_fixed_burst_write_read_test |
|   |   |   | wrap burst | 512b wrap burst write read | DONE | axi4_outstanding_512b_wrap_burst_write_read_test |
| 19 | Standalone Slave | Outstanding · Burst | incr write | INCR burst write | DONE | axi4_outstanding_incr_burst_write_test |
|   |   |   | incr read | INCR burst read | DONE | axi4_outstanding_incr_burst_read_test |
|   |   |   | incr write & read | INCR burst write read | DONE | axi4_outstanding_incr_burst_write_read_test |
|   |   |   | wrap write | WRAP burst write | DONE | axi4_outstanding_wrap_burst_write_test |
|   |   |   | wrap read | WRAP burst read | DONE | axi4_outstanding_wrap_burst_read_test |
|   |   |   | wrap write & read | WRAP burst write read | DONE | axi4_outstanding_wrap_burst_write_read_test |
|   |   |   | fixed write & read | FIXED burst write read | DONE | axi4_outstanding_fixed_burst_write_read_test |
