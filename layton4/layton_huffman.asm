; Huffman decoding algorithm.
;
; Arguments:
;  + R0: Some struct
;  + R1: Input stream
;  + R2: Size

; Restore variables
  STMFD   SP!, {R4-R12,LR}
  LDR     R3, [R0]              ; Get output pointer
  LDR     R4, [R0,#4]           ; Get decoded size
  LDR     R5, [R0,#8]           ; Get buffer pointer
  LDR     R6, [R0,#0xC]
  LDR     R7, [R0,#0x10]
  LDRSH   R8, [R0,#0x14]
  LDRB    R9, [R0,#0x16]
  LDRB    R10, [R0,#0x17]
  LDRB    R11, [R0,#0x18]

  CMP     R8, #0
  BEQ     loc_201418C
  BGT     loc_201416C

  LDRB    R8, [R1],#1           ; Read a byte
  SUB     R2, R2, #1            ; Decrease file size
  STRB    R8, [R5],#1           ; Store it into the buffer
  ADD     R8, R8, #1
  MOV     R8, R8,LSL#1
  SUB     R8, R8, #1

  loc_201416C
  CMP     R2, #0
  BEQ     quit
  LDRB    R12, [R1],#1
  SUB     R2, R2, #1
  STRB    R12, [R5],#1
  SUBS    R8, R8, #1
  ADDEQ   R5, R0, #0x1D
  BGT     loc_201416C

  loc_201418C
  CMP     R4, #0                ; Check if we have finished decoding
  BLE     quit                  ; ... quit

  loc_2014194
  CMP     R9, #0x20 ; ' '
  BGE     loc_20141BC

  loc_201419C
  CMP     R2, #0                ; Check if we have processed everything
  BEQ     quit                  ; ... quit

  LDR     R12, [R1],#1          ; Read a word but just move 1 byte
  SUB     R2, R2, #1            ; Decrease pointer
  ORR     R6, R6, R12,LSL R9
  ADD     R9, R9, #8
  CMP     R9, #0x20 ; ' '
  BLT     loc_201419C

  loc_20141BC
  MOV     R12, R6,LSR#31
  LDRB    LR, [R5]
  MOV     R5, R5,LSR#1
  MOV     R5, R5,LSL#1
  AND     R8, LR, #0x3F
  ADD     R8, R8, #1
  ADD     R5, R5, R8,LSL#1
  ADD     R5, R5, R12
  MOV     R8, #0
  MOV     LR, LR,LSL R12
  ANDS    LR, LR, #0x80
  MOV     R6, R6,LSL#1
  SUB     R9, R9, #1
  BEQ     loc_201423C
  MOV     R7, R7,LSR R11
  LDRB    R12, [R5]
  RSB     LR, R11, #0x20
  ORR     R7, R7, R12,LSL LR
  ADD     R5, R0, #0x1D
  ADD     R10, R10, R11
  CMP     R4, R10,ASR#3
  BGT     loc_2014220
  RSB     R12, R10, #0x20
  MOV     R7, R7,ASR R12
  MOV     R10, #0x20 ; ' '

  loc_2014220
  CMP     R10, #0x20 ; ' '
  BNE     loc_201423C
  STR     R7, [R3],#4
  MOV     R10, #0
  SUBS    R4, R4, #4
  MOVLE   R4, #0
  BLE     quit

  loc_201423C
  CMP     R9, #0
  BGT     loc_20141BC
  CMP     R4, #0
  BGT     loc_2014194

quit:
  ; Store everything again
  STR     R3, [R0]                  ; Output pointer
  STR     R4, [R0,#4]               ; Bytes we need
  STR     R5, [R0,#8]
  STR     R6, [R0,#0xC]
  STR     R7, [R0,#0x10]
  STRH    R8, [R0,#0x14]
  STRB    R9, [R0,#0x16]
  STRB    R10, [R0,#0x17]
  STRB    R11, [R0,#0x18]
  MOV     R0, R4                    ; Returns the number of bytes left

  ; Return
  LDMFD   SP!, {R4-R12,LR}
  BX      LR
