AM:02013F9C decode1
  STMFD   SP!, {R4-R11}
  LDR     R3, [R0]
  LDR     R4, [R0,#4]
  LDRB    R5, [R0,#0xF]
  LDRB    R6, [R0,#0x10]
  LDR     R7, [R0,#8]
  LDRB    R8, [R0,#0x11]
  LDRB    R11, [R0,#0x12]

  loc_2013FBC                             ; CODE XREF: decode1+158j
  CMP     R4, #0
  BLE     loc_20140F8
  CMP     R6, #0
  BEQ     loc_20140E0

  loc_2013FCC                             ; CODE XREF: decode1+140j
  CMP     R2, #0
  BEQ     loc_20140F8
  TST     R5, #0x80
  BNE     loc_2013FF4
  LDRB    R9, [R1],#1
  SUB     R4, R4, #1
  SUB     R2, R2, #1
  SWPB    R9, R9, [R3]
  ADD     R3, R3, #1
  B       loc_20140CC
  ; ---------------------------------------------------------------------------

  loc_2013FF4                             ; CODE XREF: decode1+3Cj
                                          ; decode1+DCj
  CMP     R8, #0
  BEQ     loc_2014090
  CMP     R11, #1
  BNE     loc_201407C
  SUBS    R8, R8, #1
  BEQ     loc_2014064
  CMP     R8, #1
  BEQ     loc_2014058
  LDRB    R7, [R1],#1
  TST     R7, #0xE0
  BEQ     loc_201402C
  ADD     R7, R7, #0x10
  MOV     R8, #0
  B       loc_2014088
  ; ---------------------------------------------------------------------------

  loc_201402C                             ; CODE XREF: decode1+80j
  MOV     R10, #0x110
  TST     R7, #0x10
  BEQ     loc_2014048
  AND     R7, R7, #0xF
  ADD     R10, R10, #0x1000
  ADD     R7, R10, R7,LSL#16
  B       loc_2014070
  ; ---------------------------------------------------------------------------

  loc_2014048                             ; CODE XREF: decode1+98j
  AND     R7, R7, #0xF
  ADD     R7, R10, R7,LSL#8
  MOV     R8, #1
  B       loc_2014070
  ; ---------------------------------------------------------------------------

  loc_2014058                             ; CODE XREF: decode1+74j
  LDRB    R10, [R1],#1
  ADD     R7, R7, R10,LSL#8
  B       loc_2014070
  ; ---------------------------------------------------------------------------

  loc_2014064                             ; CODE XREF: decode1+6Cj
  LDRB    R10, [R1],#1
  ADD     R7, R7, R10
  B       loc_2014088
  ; ---------------------------------------------------------------------------

  loc_2014070                             ; CODE XREF: decode1+A8j
                                          ; decode1+B8j ...
  SUBS    R2, R2, #1
  BEQ     loc_20140F8
  B       loc_2013FF4
  ; ---------------------------------------------------------------------------

  loc_201407C                             ; CODE XREF: decode1+64j
  LDRB    R7, [R1],#1
  ADD     R7, R7, #0x30
  MOV     R8, #0

  loc_2014088                             ; CODE XREF: decode1+8Cj
                                          ; decode1+D0j
  SUBS    R2, R2, #1
  BEQ     loc_20140F8

  loc_2014090                             ; CODE XREF: decode1+5Cj
  AND     R9, R7, #0xF
  MOV     R10, R9,LSL#8
  LDRB    R9, [R1],#1
  MOV     R8, #3
  SUB     R2, R2, #1
  ORR     R9, R9, R10
  ADD     R9, R9, #1
  MOVS    R7, R7,ASR#4
  BEQ     loc_20140CC

  loc_20140B4                             ; CODE XREF: decode1+12Cj
  LDRB    R10, [R3,-R9]
  SUB     R4, R4, #1
  SWPB    R10, R10, [R3]
  ADD     R3, R3, #1
  SUBS    R7, R7, #1
  BGT     loc_20140B4

  loc_20140CC                             ; CODE XREF: decode1+54j
                                          ; decode1+114j
  CMP     R4, #0
  BEQ     loc_20140F8
  MOV     R5, R5,LSL#1
  SUBS    R6, R6, #1
  BNE     loc_2013FCC

  loc_20140E0                             ; CODE XREF: decode1+2Cj
  CMP     R2, #0
  BEQ     loc_20140F8
  LDRB    R5, [R1],#1
  MOV     R6, #8
  SUB     R2, R2, #1
  B       loc_2013FBC
  ; ---------------------------------------------------------------------------

  loc_20140F8                             ; CODE XREF: decode1+24j
                                          ; decode1+34j ...
  STR     R3, [R0]
  STR     R4, [R0,#4]
  STRB    R5, [R0,#0xF]
  STRB    R6, [R0,#0x10]
  STR     R7, [R0,#8]
  STRB    R8, [R0,#0x11]
  STRB    R11, [R0,#0x12]
  MOV     R0, R4
  LDMFD   SP!, {R4-R11}
  BX      LR
