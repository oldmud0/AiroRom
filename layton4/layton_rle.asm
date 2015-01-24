  STMFD   SP!, {R4-R8}
  LDR     R3, [R0]
  LDR     R4, [R0,#4]
  LDRB    R5, [R0,#0xB]
  LDRH    R6, [R0,#0xC]

  loc_2013F04
  CMP     R4, #0
  BLE     quit
  TST     R5, #0x80
  BNE     encoded

  ; Just copy
  not_encoded
  CMP     R6, #0
  BLE     read_token
  SUB     R6, R6, #1
  LDRB    R7, [R1],#1
  SUB     R4, R4, #1
  SWPB    R8, R7, [R3]
  ADD     R3, R3, #1
  SUBS    R2, R2, #1
  BEQ     quit
  B       not_encoded

  encoded
  CMP     R6, #0
  BLE     read_token
  LDRB    R7, [R1],#1

  repeat_byte
  SUB     R4, R4, #1
  SWPB    R8, R7, [R3]
  ADD     R3, R3, #1
  SUBS    R6, R6, #1
  BGT     repeat_byte
  SUBS    R2, R2, #1
  BEQ     quit

read_token:
  LDRB    R5, [R1],#1           ; Read token
  SUBS    R2, R2, #1

  AND     R6, R5, #0x7F         ; Get flag bit
  TST     R5, #0x80             ; If the flag is set, encoded
  ADDNE   R6, R6, #2            ; ... repeat next byte R6 + 3

  ADD     R6, R6, #1            ; Not encoded, copy R6 + 1 data
  BNE     loc_2013F04

quit:
  STR     R3, [R0]
  STR     R4, [R0,#4]
  STRB    R5, [R0,#0xB]
  STRH    R6, [R0,#0xC]
  MOV     R0, R4

  LDMFD   SP!, {R4-R8}
  BX      LR
