# AXI4 AVIP — Verification Plan (Standalone Master Mode)

| S.No | Sections | Features | Sub-Features | Description | Status | Testcase Name |
|------|----------|----------|--------------|-------------|--------|---------------|
| 1 | Standalone Master | Non-Outstanding | write | Master drives writes, slave passive | DONE | axi4_non_outstanding_slave_write_test |
|   |   |   | read | Master drives reads, slave passive | DONE | axi4_non_outstanding_slave_read_test |
|   |   |   | write & read | Master drives write+read, slave passive | DONE | axi4_non_outstanding_slave_write_read_test |
| 2 | Standalone Master | Outstanding | write | Master drives outstanding writes | DONE | axi4_outstanding_slave_write_test |
|   |   |   | read | Master drives outstanding reads | DONE | axi4_outstanding_slave_read_test |
|   |   |   | write & read | Master drives outstanding write+read | DONE | axi4_outstanding_slave_write_read_test |
