;; Function to decode files
;; Arguments:
;;  + R0:
;;  + R1:
;; Registers:
;;  + R4: Input size (updating after read)
;;  + R5: Token
;;  + R6: Token size (in bits)
;;  + R7: Input pointer
;;  + R8: Decompress struct pointer
;;  + R9: R0 struct
;;  + R11: Output pointer
;; Stack variables:
;;  + var_60= -0x60
;;  + var_5C= -0x5C
;;  + arg1= -0x58
;;  + var_54= -0x54
;;  + var_50= -0x50
;;  + var_4C= -0x4C
;;  + stru_10_2= -0x48
;;  + inSize= -0x44
;;  + stru_10= -0x40
;;  + var_3C= -0x3C
;;  + var_3A= -0x3A
;;  + var_38= -0x38
;;  + var_36= -0x36
;;  + var_34= -0x34
;;  + var_32= -0x32
;;  + var_30= -0x30
;;  + var_2F= -0x2F
;;  + var_2E= -0x2E
;;  + var_2D= -0x2D
;;  + var_2C= -0x2C
;;  + var_2A= -0x2A
;;  + var_28= -0x28
;;  + var_26= -0x26
;; Struct of R0:
;;  + 0x00: Input pointer
;;  + 0x04: Input size
;;  + 0x08:
;;  + 0x0C: Output pointer
;;  + 0x10:
;;  + 0x14:
;;  + 0x18:
;;  + 0x1C: Decompress struct
;; Struct of R8:
;;  + 0x00: State
;;  + 0x08: Something checked in case0
;;  + 0x30: Token
;;  + 0x34: Token size (in bits)
;; State enum:
;;  + 0x00:
;;  + 0x0B: Change to 0x0C at the start
;;  + 0x0C:

  ; Start, save registers
  STMFD   SP!, {R4-R11,LR}
  SUB     SP, SP, #0x3C
  STR     R1, [SP,#0x60+arg1]

  ; Check the "decompress struct" pointer is set
  MOVS    R9, R0
  LDRNE   R8, [R9,#0x1C]
  CMPNE   R8, #0

  ; Check the output pointer is set
  LDRNE   R0, [R9,#0xC]
  CMPNE   R0, #0
  BEQ     error_quit

  ; Check the input pointer is set
  LDR     R0, [R9]
  CMP     R0, #0
  BNE     start

  ; Check if size is zero (because the pointer was not set)
  LDR     R0, [R9,#4]
  CMP     R0, #0
  BEQ     start

error_quit:
  ADD     SP, SP, #0x3C
  MOV     R0, 0xFFFFFFFE
  LDMFD   SP!, {R4-R11,PC}

start:
  ; If state is 11, set to 12
  LDR     R0, [R8]
  CMP     R0, #0xB
  MOVEQ   R0, #0xC
  STREQ   R0, [R8]

  LDR     R0, [R9,#0x10]
  STR     R0, [SP,#0x60+stru_10]
  STR     R0, [SP,#0x60+stru_10_2]

  ; Get input size
  LDR     R4, [R9,#4]
  STR     R4, [SP,#0x60+inSize]

  MOV     R0, #0
  STR     R0, [SP,#0x60+var_50]

  ; Get the input and output pointer
  LDR     R11, [R9,#0xC]
  LDR     R7, [R9]

  ; Get current token and token size
  LDR     R5, [R8,#0x30]
  LDR     R6, [R8,#0x34]

state_switch:
  ; State switch with 30 (0x1D) cases
  LDR     R0, [R8]
  CMP     R0, #0x1D
  ADDLS   PC, PC, R0,LSL#2
  B       error2_quit                     ; default case
  B       state_case0                     ; case 0
  B       state_case1                     ; case 1
  B       loc_208117C                     ; case 2
  B       loc_20811FC                     ; case 3
  B       loc_2081264                     ; case 4
  B       loc_20812DC                     ; case 5
  B       loc_2081340                     ; case 6
  B       loc_20813AC                     ; case 7
  B       loc_2081418                     ; case 8
  B       loc_208149C                     ; case 9
  B       loc_20814FC                     ; case 10
  B       loc_2081550                     ; case 11
  B       loc_208155C                     ; case 12
  B       loc_208161C                     ; case 13
  B       loc_2081690                     ; case 14
  B       loc_20816FC                     ; case 15
  B       loc_2081798                     ; case 16
  B       loc_20818A4                     ; case 17
  B       loc_2081BA8                     ; case 18
  B       loc_2081D4C                     ; case 19
  B       loc_2081DB0                     ; case 20
  B       loc_2081ED4                     ; case 21
  B       loc_2081FC0                     ; case 22
  B       loc_2082070                     ; case 23
  B       loc_20820A0                     ; case 24
  B       loc_208218C                     ; case 25
  B       loc_20821F8                     ; case 26
  B       error3_quit                     ; case 27
  B       error4_quit                     ; case 28
  B       error2_quit                     ; default case

state_case0:
  ; If something is zero, go to state 0x0C
  LDR     R1, [R8,#8]
  CMP     R1, #0
  MOVEQ   R0, #0xC
  STREQ   R0, [R8]
  BEQ     state_switch

  ; Check if we have enough tokens (16)
  CMP     R6, #0x10
  BCS     loc_2080FA4

  case0_readToken16:
  ; Check size
  CMP     R4, #0
  BEQ     close_quit

  ; Read a byte and compare
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x10
  BCC     case0_readToken16

  loc_2080FA4
  TST     R1, #2
  BEQ     loc_2081000

  LDR     R0, =0x8B1F
  CMP     R5, R0
  BNE     loc_2081000

  MOV     R0, #0
  MOV     R1, R0
  MOV     R2, R0
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  ADD     R1, SP, #0x60+var_30
  SWPB    R2, R5, [R1]
  MOV     R6, R5,LSR#8
  ADD     R3, SP, #0x60+var_2F
  SWPB    R2, R6, [R3]
  MOV     R2, #2

  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  MOV     R5, #0
  MOV     R0, #1
  MOV     R6, R5
  STR     R0, [R8]
  B       state_switch

  loc_2081000
  MOV     R0, #0
  STR     R0, [R8,#0x10]

  LDR     R1, [R8,#8]
  TST     R1, #1
  BEQ     loc_2081044

  ; Swap (to little endian) a byte from token
  MOV     R2, R5,LSL#24
  MOV     R1, R5,LSR#8
  ADD     R2, R1, R2,LSR#16

  ; Do module 0x1F
  LDR     R3, =0x8421085
  MOV     R1, #0x1F
  UMULL   R10, R3, R2, R3
  SUB     R10, R2, R3
  ADD     R3, R3, R10,LSR#1
  MOV     R3, R3,LSR#4
  UMULL   R3, R10, R1, R3
  SUBS    R3, R2, R3
  BEQ     loc_2081058

  loc_2081044
  LDR     R1, =aIncorrectHeade            ; "incorrect header check"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081058                             ; CODE XREF: decode_unk_base_+1E4j
  AND     R1, R5, #0xF
  CMP     R1, #8
  BEQ     loc_2081078

  LDR     R1, =aUnknownCompres            ; "unknown compression method"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081078                             ; CODE XREF: decode_unk_base_+204j
  MOV     R5, R5,LSR#4
  SUB     R6, R6, #4
  AND     R1, R5, #0xF
  ADD     R2, R1, #8
  LDR     R1, [R8,#0x1C]
  CMP     R2, R1
  BLS     loc_20810A8

  LDR     R1, =aInvalidWindowS            ; "invalid window size"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_20810A8                             ; CODE XREF: decode_unk_base_+234j
  MOV     R1, R0
  MOV     R2, R0
  BL      sub_20804C8
  STR     R0, [R8,#0x14]
  TST     R5, #0x200
  STR     R0, [R9,#0x30]
  MOVNE   R0, #9
  MOVEQ   R0, #0xB
  MOV     R5, #0
  MOV     R6, R5
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

state_case1:
  CMP     R6, #0x10
  BCS     loc_2081100

  loc_20810E0                             ; CODE XREF: decode_unk_base_+2A0j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x10
  BCC     loc_20810E0

  loc_2081100                             ; CODE XREF: decode_unk_base_+280j
  AND     R0, R5, #0xFF
  CMP     R0, #8
  STR     R5, [R8,#0x10]
  BEQ     loc_2081124
  LDR     R1, =aUnknownCompres            ; "unknown compression method"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081124                             ; CODE XREF: decode_unk_base_+2B0j
  TST     R5, #0xE000
  BEQ     loc_2081140
  LDR     R1, =aUnknownHeaderF            ; "unknown header flags set"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081140                             ; CODE XREF: decode_unk_base_+2CCj
  TST     R5, #0x200
  BEQ     loc_208116C
  ADD     R1, SP, #0x60+var_30
  SWPB    R0, R5, [R1]
  ADD     R2, SP, #0x60+var_2F
  MOV     R0, R5,LSR#8
  SWPB    R0, R0, [R2]
  MOV     R2, #2
  LDR     R0, [R8,#0x14]
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_208116C                             ; CODE XREF: decode_unk_base_+2E8j
  MOV     R5, #0
  MOV     R0, #2
  MOV     R6, R5
  STR     R0, [R8]

  loc_208117C                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080EF8j
  CMP     R6, #0x20 ; ' '                 ; jumptable 02080EE8 case 2
  BCS     loc_20811A4

  loc_2081184                             ; CODE XREF: decode_unk_base_+344j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x20 ; ' '
  BCC     loc_2081184

  loc_20811A4                             ; CODE XREF: decode_unk_base_+324j
  LDR     R0, [R8,#0x10]
  TST     R0, #0x200
  BEQ     loc_20811EC
  ADD     R1, SP, #0x60+var_30
  SWPB    R0, R5, [R1]
  ADD     R2, SP, #0x60+var_2F
  MOV     R0, R5,LSR#8
  SWPB    R0, R0, [R2]
  ADD     R2, SP, #0x60+var_2E
  MOV     R0, R5,LSR#16
  SWPB    R0, R0, [R2]
  ADD     R2, SP, #0x60+var_2D
  MOV     R0, R5,LSR#24
  SWPB    R0, R0, [R2]
  MOV     R2, #4
  LDR     R0, [R8,#0x14]
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_20811EC                             ; CODE XREF: decode_unk_base_+350j
  MOV     R5, #0
  MOV     R0, #3
  MOV     R6, R5
  STR     R0, [R8]

  loc_20811FC                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080EFCj
  CMP     R6, #0x10                       ; jumptable 02080EE8 case 3
  BCS     loc_2081224

  loc_2081204                             ; CODE XREF: decode_unk_base_+3C4j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x10
  BCC     loc_2081204

  loc_2081224                             ; CODE XREF: decode_unk_base_+3A4j
  LDR     R0, [R8,#0x10]
  TST     R0, #0x200
  BEQ     loc_2081254
  ADD     R1, SP, #0x60+var_30
  SWPB    R0, R5, [R1]
  ADD     R2, SP, #0x60+var_2F
  MOV     R0, R5,LSR#8
  SWPB    R0, R0, [R2]
  MOV     R2, #2
  LDR     R0, [R8,#0x14]
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_2081254                             ; CODE XREF: decode_unk_base_+3D0j
  MOV     R5, #0
  MOV     R0, #4
  MOV     R6, R5
  STR     R0, [R8]

  loc_2081264                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F00j
  LDR     R0, [R8,#0x10]                  ; jumptable 02080EE8 case 4
  TST     R0, #0x400
  BEQ     loc_20812D4
  CMP     R6, #0x10
  BCS     loc_2081298

  loc_2081278                             ; CODE XREF: decode_unk_base_+438j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x10
  BCC     loc_2081278

  loc_2081298                             ; CODE XREF: decode_unk_base_+418j
  STR     R5, [R8,#0x38]
  LDR     R0, [R8,#0x10]
  TST     R0, #0x200
  BEQ     loc_20812CC
  ADD     R1, SP, #0x60+var_30
  SWPB    R0, R5, [R1]
  ADD     R2, SP, #0x60+var_2F
  MOV     R0, R5,LSR#8
  SWPB    R0, R0, [R2]
  MOV     R2, #2
  LDR     R0, [R8,#0x14]
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_20812CC                             ; CODE XREF: decode_unk_base_+448j
  MOV     R5, #0
  MOV     R6, R5

  loc_20812D4                             ; CODE XREF: decode_unk_base_+410j
  MOV     R0, #5
  STR     R0, [R8]

  loc_20812DC                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F04j
  LDR     R0, [R8,#0x10]                  ; jumptable 02080EE8 case 5
  TST     R0, #0x400
  BEQ     loc_2081338
  LDR     R10, [R8,#0x38]
  CMP     R10, R4
  MOVHI   R10, R4
  CMP     R10, #0
  BEQ     loc_208132C
  TST     R0, #0x200
  BEQ     loc_2081318
  LDR     R0, [R8,#0x14]
  MOV     R1, R7
  MOV     R2, R10
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_2081318                             ; CODE XREF: decode_unk_base_+4A4j
  LDR     R0, [R8,#0x38]
  SUB     R4, R4, R10
  SUB     R0, R0, R10
  STR     R0, [R8,#0x38]
  ADD     R7, R7, R10

  loc_208132C                             ; CODE XREF: decode_unk_base_+49Cj
  LDR     R0, [R8,#0x38]
  CMP     R0, #0
  BNE     close_quit

  loc_2081338                             ; CODE XREF: decode_unk_base_+488j
  MOV     R0, #6
  STR     R0, [R8]

  loc_2081340                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F08j
  LDR     R1, [R8,#0x10]                  ; jumptable 02080EE8 case 6
  TST     R1, #0x800
  BEQ     loc_20813A4
  CMP     R4, #0
  BEQ     close_quit
  MOV     R10, #0

  loc_2081358                             ; CODE XREF: decode_unk_base_+514j
  LDRB    R0, [R7,R10]
  ADD     R10, R10, #1
  STR     R0, [SP,#0x60+var_4C]
  CMP     R0, #0
  BEQ     loc_2081374
  CMP     R10, R4
  BCC     loc_2081358

  loc_2081374                             ; CODE XREF: decode_unk_base_+50Cj
  TST     R1, #0x2000
  BEQ     loc_2081390
  LDR     R0, [R8,#0x14]
  MOV     R1, R7
  MOV     R2, R10
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_2081390                             ; CODE XREF: decode_unk_base_+51Cj
  LDR     R0, [SP,#0x60+var_4C]
  SUB     R4, R4, R10
  CMP     R0, #0
  ADD     R7, R7, R10
  BNE     close_quit

  loc_20813A4                             ; CODE XREF: decode_unk_base_+4ECj
  MOV     R0, #7
  STR     R0, [R8]

  loc_20813AC                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F0Cj
  LDR     R1, [R8,#0x10]                  ; jumptable 02080EE8 case 7
  TST     R1, #0x1000
  BEQ     loc_2081410
  CMP     R4, #0
  BEQ     close_quit
  MOV     R10, #0

  loc_20813C4                             ; CODE XREF: decode_unk_base_+580j
  LDRB    R0, [R7,R10]
  ADD     R10, R10, #1
  STR     R0, [SP,#0x60+var_54]
  CMP     R0, #0
  BEQ     loc_20813E0
  CMP     R10, R4
  BCC     loc_20813C4

  loc_20813E0                             ; CODE XREF: decode_unk_base_+578j
  TST     R1, #0x2000
  BEQ     loc_20813FC
  LDR     R0, [R8,#0x14]
  MOV     R1, R7
  MOV     R2, R10
  BL      sub_20804BC
  STR     R0, [R8,#0x14]

  loc_20813FC                             ; CODE XREF: decode_unk_base_+588j
  LDR     R0, [SP,#0x60+var_54]
  SUB     R4, R4, R10
  CMP     R0, #0
  ADD     R7, R7, R10
  BNE     close_quit

  loc_2081410                             ; CODE XREF: decode_unk_base_+558j
  MOV     R0, #8
  STR     R0, [R8]

  loc_2081418                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F10j
  LDR     R0, [R8,#0x10]                  ; jumptable 02080EE8 case 8
  TST     R0, #0x200
  BEQ     loc_2081478
  CMP     R6, #0x10
  BCS     loc_208144C

  loc_208142C                             ; CODE XREF: decode_unk_base_+5ECj
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x10
  BCC     loc_208142C

  loc_208144C                             ; CODE XREF: decode_unk_base_+5CCj
  LDR     R0, [R8,#0x14]
  MOV     R0, R0,LSL#16
  CMP     R5, R0,LSR#16
  BEQ     loc_2081470
  LDR     R1, =aHeaderCrcMisma            ; "header crc mismatch"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081470                             ; CODE XREF: decode_unk_base_+5FCj
  MOV     R5, #0
  MOV     R6, R5

  loc_2081478                             ; CODE XREF: decode_unk_base_+5C4j
  MOV     R0, #0
  MOV     R1, R0
  MOV     R2, R0
  BL      sub_20804BC
  STR     R0, [R8,#0x14]
  STR     R0, [R9,#0x30]
  MOV     R0, #0xB
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_208149C                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F14j
  CMP     R6, #0x20 ; ' '                 ; jumptable 02080EE8 case 9
  BCS     loc_20814C4

  loc_20814A4                             ; CODE XREF: decode_unk_base_+664j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x20 ; ' '
  BCC     loc_20814A4

  loc_20814C4                             ; CODE XREF: decode_unk_base_+644j
  MOV     R1, R5,LSR#24
  MOV     R0, R5,LSR#8
  AND     R1, R1, #0xFF
  AND     R0, R0, #0xFF00
  AND     R2, R5, #0xFF00
  ADD     R0, R1, R0
  ADD     R0, R0, R2,LSL#8
  ADD     R0, R0, R5,LSL#24
  STR     R0, [R8,#0x14]
  MOV     R5, #0
  STR     R0, [R9,#0x30]
  MOV     R0, #0xA
  MOV     R6, R5
  STR     R0, [R8]

  loc_20814FC                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F18j
  LDR     R0, [R8,#0xC]                   ; jumptable 02080EE8 case 10
  CMP     R0, #0
  BNE     loc_2081530
  LDR     R0, [SP,#0x60+stru_10]
  STR     R11, [R9,#0xC]
  STR     R0, [R9,#0x10]
  STR     R7, [R9]
  STR     R4, [R9,#4]
  STR     R5, [R8,#0x30]
  ADD     SP, SP, #0x3C
  STR     R6, [R8,#0x34]
  MOV     R0, #2
  LDMFD   SP!, {R4-R11,PC}
  ; ---------------------------------------------------------------------------

  loc_2081530                             ; CODE XREF: decode_unk_base_+6A8j
  MOV     R0, #0
  MOV     R1, R0
  MOV     R2, R0
  BL      sub_20804C8
  STR     R0, [R8,#0x14]
  STR     R0, [R9,#0x30]
  MOV     R0, #0xB
  STR     R0, [R8]

  loc_2081550                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F1Cj
  LDR     R0, [SP,#0x60+arg1]           ; jumptable 02080EE8 case 11
  CMP     R0, #5
  BEQ     close_quit

  loc_208155C                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F20j
  LDR     R0, [R8,#4]                     ; jumptable 02080EE8 case 12
  CMP     R0, #0
  BEQ     loc_2081580
  AND     R1, R6, #7
  MOV     R0, #0x18
  STR     R0, [R8]
  MOV     R5, R5,LSR R1
  SUB     R6, R6, R1
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081580                             ; CODE XREF: decode_unk_base_+708j
  CMP     R6, #3
  BCS     loc_20815A8

  loc_2081588                             ; CODE XREF: decode_unk_base_+748j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #3
  BCC     loc_2081588

  loc_20815A8                             ; CODE XREF: decode_unk_base_+728j
  AND     R0, R5, #1
  MOV     R5, R5,LSR#1
  STR     R0, [R8,#4]
  AND     R0, R5, #3
  CMP     R0, #3                          ; switch 4 cases
  ADDLS   PC, PC, R0,LSL#2                ; switch jump
  B       loc_2081610                     ; jumptable 020815BC default case
  ; ---------------------------------------------------------------------------

  loc_20815C4                             ; CODE XREF: decode_unk_base_+760j
  B       loc_20815D4                     ; jumptable 020815BC case 0
  ; ---------------------------------------------------------------------------

  loc_20815C8                             ; CODE XREF: decode_unk_base_+760j
  B       loc_20815E0                     ; jumptable 020815BC case 1
  ; ---------------------------------------------------------------------------

  loc_20815CC                             ; CODE XREF: decode_unk_base_+760j
  B       loc_20815F4                     ; jumptable 020815BC case 2
  ; ---------------------------------------------------------------------------

  loc_20815D0                             ; CODE XREF: decode_unk_base_+760j
  B       loc_2081600                     ; jumptable 020815BC case 3
  ; ---------------------------------------------------------------------------

  loc_20815D4                             ; CODE XREF: decode_unk_base_+760j
                                          ; decode_unk_base_:loc_20815C4j
  MOV     R0, #0xD                        ; jumptable 020815BC case 0
  STR     R0, [R8]
  B       loc_2081610                     ; jumptable 020815BC default case
  ; ---------------------------------------------------------------------------

  loc_20815E0                             ; CODE XREF: decode_unk_base_+760j
                                          ; decode_unk_base_:loc_20815C8j
  MOV     R0, R8                          ; jumptable 020815BC case 1
  BL      sub_2080D00
  MOV     R0, #0x12
  STR     R0, [R8]
  B       loc_2081610                     ; jumptable 020815BC default case
  ; ---------------------------------------------------------------------------

  loc_20815F4                             ; CODE XREF: decode_unk_base_+760j
                                          ; decode_unk_base_:loc_20815CCj
  MOV     R0, #0xF                        ; jumptable 020815BC case 2
  STR     R0, [R8]
  B       loc_2081610                     ; jumptable 020815BC default case
  ; ---------------------------------------------------------------------------

  loc_2081600                             ; CODE XREF: decode_unk_base_+760j
                                          ; decode_unk_base_:loc_20815D0j
  LDR     R1, =aInvalidBlockTy            ; jumptable 020815BC case 3
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]

  loc_2081610                             ; CODE XREF: decode_unk_base_+760j
                                          ; decode_unk_base_+764j ...
  MOV     R5, R5,LSR#2                    ; jumptable 020815BC default case
  SUB     R6, R6, #3
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_208161C                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F24j
  AND     R0, R6, #7                      ; jumptable 02080EE8 case 13
  SUB     R6, R6, R0
  MOV     R5, R5,LSR R0
  CMP     R6, #0x20 ; ' '
  BCS     loc_2081650

  loc_2081630                             ; CODE XREF: decode_unk_base_+7F0j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x20 ; ' '
  BCC     loc_2081630

  loc_2081650                             ; CODE XREF: decode_unk_base_+7D0j
  LDR     R1, =0xFFFF
  MOV     R0, R5,LSL#16
  MOV     R2, R0,LSR#16
  EOR     R0, R1, R5,LSR#16
  CMP     R2, R0
  BEQ     loc_208167C
  LDR     R1, =aInvalidStoredB            ; "invalid stored block lengths"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_208167C                             ; CODE XREF: decode_unk_base_+808j
  MOV     R5, #0
  STR     R2, [R8,#0x38]
  MOV     R0, #0xE
  MOV     R6, R5
  STR     R0, [R8]

  loc_2081690                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F28j
  LDR     R10, [R8,#0x38]                 ; jumptable 02080EE8 case 14
  CMP     R10, #0
  BEQ     loc_20816F0
  LDR     R0, [SP,#0x60+stru_10]
  CMP     R10, R4
  MOVHI   R10, R4
  CMP     R10, R0
  MOVHI   R10, R0
  CMP     R10, #0
  BEQ     close_quit
  MOV     R0, R11
  MOV     R1, R7
  MOV     R2, R10
  BL      unk_1FF9B10
  LDR     R0, [R8,#0x38]
  SUB     R4, R4, R10
  SUB     R0, R0, R10
  STR     R0, [R8,#0x38]
  LDR     R0, [SP,#0x60+stru_10]
  ADD     R7, R7, R10
  SUB     R0, R0, R10
  STR     R0, [SP,#0x60+stru_10]
  ADD     R11, R11, R10
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_20816F0                             ; CODE XREF: decode_unk_base_+83Cj
  MOV     R0, #0xB
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_20816FC                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F2Cj
  CMP     R6, #0xE                        ; jumptable 02080EE8 case 15
  BCS     loc_2081724

  loc_2081704                             ; CODE XREF: decode_unk_base_+8C4j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0xE
  BCC     loc_2081704

  loc_2081724                             ; CODE XREF: decode_unk_base_+8A4j
  AND     R0, R5, #0x1F
  ADD     R0, R0, #1
  MOV     R1, R5,LSR#5
  ADD     R0, R0, #0x100
  STR     R0, [R8,#0x58]
  AND     R0, R1, #0x1F
  MOV     R2, R1,LSR#5
  ADD     R0, R0, #1
  STR     R0, [R8,#0x5C]
  AND     R0, R2, #0xF
  ADD     R0, R0, #4
  STR     R0, [R8,#0x54]
  LDR     R1, [R8,#0x58]
  LDR     R0, =0x11E
  MOV     R5, R2,LSR#4
  CMP     R1, R0
  LDRLS   R0, [R8,#0x5C]
  SUB     R6, R6, #0xE
  CMPLS   R0, #0x1E
  BLS     loc_2081788
  LDR     R1, =aTooManyLengthO            ; "too many length or distance symbols"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081788                             ; CODE XREF: decode_unk_base_+914j
  MOV     R0, #0
  STR     R0, [R8,#0x60]
  MOV     R0, #0x10
  STR     R0, [R8]

  loc_2081798                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F30j
  LDR     R2, =dword_20B71B0              ; jumptable 02080EE8 case 16
  B       loc_20817F0
  ; ---------------------------------------------------------------------------

  decode_first                            ; CODE XREF: decode_unk_base_+9A0j
  CMP     R6, #3
  BCS     loc_20817C8

  loc_20817A8                             ; CODE XREF: decode_unk_base_+968j
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R0, [R7],#1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #3
  BCC     loc_20817A8

  loc_20817C8                             ; CODE XREF: decode_unk_base_+948j
  MOV     R0, R1,LSL#1
  LDRH    R0, [R2,R0]
  LDR     R3, [R8,#0x60]
  AND     R1, R5, #7
  ADD     R3, R3, #1
  STR     R3, [R8,#0x60]
  ADD     R0, R8, R0,LSL#1
  STRH    R1, [R0,#0x68]
  MOV     R5, R5,LSR#3
  SUB     R6, R6, #3

  loc_20817F0                             ; CODE XREF: decode_unk_base_+940j
  LDR     R1, [R8,#0x60]
  LDR     R0, [R8,#0x54]
  CMP     R1, R0
  BCC     decode_first
  CMP     R1, #0x13
  BCS     loc_2081838
  LDR     R2, =dword_20B71B0
  MOV     R0, #0

  loc_2081810                             ; CODE XREF: decode_unk_base_+9D8j
  LDR     R3, [R8,#0x60]
  MOV     R1, R1,LSL#1
  ADD     R3, R3, #1
  STR     R3, [R8,#0x60]
  LDRH    R1, [R2,R1]
  ADD     R1, R8, R1,LSL#1
  STRH    R0, [R1,#0x68]
  LDR     R1, [R8,#0x60]
  CMP     R1, #0x13
  BCC     loc_2081810

  loc_2081838                             ; CODE XREF: decode_unk_base_+9A8j
  ADD     R0, R8, #0x128
  ADD     R0, R0, #0x400
  STR     R0, [R8,#0x64]
  STR     R0, [R8,#0x44]
  MOV     R0, #7
  STR     R0, [R8,#0x4C]
  ADD     R0, R8, #0x4C
  STR     R0, [SP,#0x60+var_60]
  ADD     R0, R8, #0x2E8
  STR     R0, [SP,#0x60+var_5C]
  ADD     R1, R8, #0x68
  ADD     R3, R8, #0x64
  MOV     R0, #0
  MOV     R2, #0x13
  BL      decode_unk_
  STR     R0, [SP,#0x60+var_50]
  CMP     R0, #0
  BEQ     loc_2081894
  LDR     R1, =aInvalidCodeLen            ; "invalid code lengths set"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081894                             ; CODE XREF: decode_unk_base_+A20j
  MOV     R0, #0
  STR     R0, [R8,#0x60]
  MOV     R0, #0x11
  STR     R0, [R8]

  loc_20818A4                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F34j
  LDR     R1, [R8,#0x58]                  ; jumptable 02080EE8 case 17
  LDR     R0, [R8,#0x5C]
  LDR     R2, [R8,#0x60]
  ADD     R3, R1, R0
  CMP     R2, R3
  BCS     loc_2081AE8
  MOV     LR, #0
  MOV     R12, #1

  loc_20818C4                             ; CODE XREF: decode_unk_base_+AB8j
                                          ; decode_unk_base_+C88j
  LDR     R1, [R8,#0x44]
  LDR     R0, [R8,#0x4C]
  MOV     R0, R12,LSL R0
  SUB     R0, R0, #1
  AND     R10, R5, R0
  MOV     R0, R10,LSL#2
  ADD     R10, R1, R10,LSL#2
  LDRH    R0, [R1,R0]
  LDRH    R1, [R10,#2]
  STRH    R0, [SP,#0x60+var_28]
  STRH    R1, [SP,#0x60+var_26]
  LDRB    R0, [SP,#0x60+var_28+1]
  CMP     R6, R0
  BCS     loc_2081918
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R0, [R7],#1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  B       loc_20818C4
  ; ---------------------------------------------------------------------------

  loc_2081918                             ; CODE XREF: decode_unk_base_+A9Cj
  LDRH    R1, [SP,#0x60+var_26]
  CMP     R1, #0x10
  BCS     loc_208196C
  CMP     R6, R0
  BCS     loc_208194C

  loc_208192C                             ; CODE XREF: decode_unk_base_+AECj
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R3, [R7],#1
  ADD     R5, R5, R3,LSL R6
  ADD     R6, R6, #8
  CMP     R6, R0
  BCC     loc_208192C

  loc_208194C                             ; CODE XREF: decode_unk_base_+ACCj
  ADD     R2, R8, R2,LSL#1
  MOV     R5, R5,LSR R0
  SUB     R6, R6, R0
  LDR     R0, [R8,#0x60]
  ADD     R0, R0, #1
  STR     R0, [R8,#0x60]
  STRH    R1, [R2,#0x68]
  B       loc_2081AD0
  ; ---------------------------------------------------------------------------

  loc_208196C                             ; CODE XREF: decode_unk_base_+AC4j
  BNE     loc_20819DC
  ADD     R10, R0, #2
  CMP     R6, R10
  BCS     loc_208199C

  loc_208197C                             ; CODE XREF: decode_unk_base_+B3Cj
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R1, [R7],#1
  ADD     R5, R5, R1,LSL R6
  ADD     R6, R6, #8
  CMP     R6, R10
  BCC     loc_208197C

  loc_208199C                             ; CODE XREF: decode_unk_base_+B1Cj
  CMP     R2, #0
  MOV     R5, R5,LSR R0
  SUB     R6, R6, R0
  BNE     loc_20819C0
  LDR     R1, =aInvalidBitLeng            ; "invalid bit length repeat"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       loc_2081AE8
  ; ---------------------------------------------------------------------------

  loc_20819C0                             ; CODE XREF: decode_unk_base_+B4Cj
  ADD     R0, R8, R2,LSL#1
  LDRH    R0, [R0,#0x66]
  AND     R1, R5, #3
  ADD     R1, R1, #3
  MOV     R5, R5,LSR#2
  SUB     R6, R6, #2
  B       loc_2081A78
  ; ---------------------------------------------------------------------------

  loc_20819DC                             ; CODE XREF: decode_unk_base_:loc_208196Cj
  CMP     R1, #0x11
  BNE     loc_2081A30
  ADD     R10, R0, #3
  CMP     R6, R10
  BCS     loc_2081A10

  loc_20819F0                             ; CODE XREF: decode_unk_base_+BB0j
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R1, [R7],#1
  ADD     R5, R5, R1,LSL R6
  ADD     R6, R6, #8
  CMP     R6, R10
  BCC     loc_20819F0

  loc_2081A10                             ; CODE XREF: decode_unk_base_+B90j
  MOV     R5, R5,LSR R0
  SUB     R0, R6, R0
  SUB     R6, R0, #3
  MOV     R0, LR
  AND     R1, R5, #7
  ADD     R1, R1, #3
  MOV     R5, R5,LSR#3
  B       loc_2081A78
  ; ---------------------------------------------------------------------------

  loc_2081A30                             ; CODE XREF: decode_unk_base_+B84j
  ADD     R10, R0, #7
  CMP     R6, R10
  BCS     loc_2081A5C

  loc_2081A3C                             ; CODE XREF: decode_unk_base_+BFCj
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R1, [R7],#1
  ADD     R5, R5, R1,LSL R6
  ADD     R6, R6, #8
  CMP     R6, R10
  BCC     loc_2081A3C

  loc_2081A5C                             ; CODE XREF: decode_unk_base_+BDCj
  MOV     R5, R5,LSR R0
  AND     R1, R5, #0x7F
  SUB     R0, R6, R0
  SUB     R6, R0, #7
  MOV     R0, #0
  ADD     R1, R1, #0xB
  MOV     R5, R5,LSR#7

  loc_2081A78                             ; CODE XREF: decode_unk_base_+B7Cj
                                          ; decode_unk_base_+BD0j
  ADD     R2, R2, R1
  CMP     R2, R3
  BLS     loc_2081A98
  LDR     R1, =aInvalidBitLeng            ; "invalid bit length repeat"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       loc_2081AE8
  ; ---------------------------------------------------------------------------

  loc_2081A98                             ; CODE XREF: decode_unk_base_+C24j
  CMP     R1, #0
  SUB     R1, R1, #1
  BEQ     loc_2081AD0
  MOV     R0, R0,LSL#16
  MOV     R2, R0,LSR#16

  loc_2081AAC                             ; CODE XREF: decode_unk_base_+C70j
  LDR     R0, [R8,#0x60]
  CMP     R1, #0
  MOV     R3, R0
  ADD     R3, R3, #1
  ADD     R0, R8, R0,LSL#1
  STR     R3, [R8,#0x60]
  STRH    R2, [R0,#0x68]
  SUB     R1, R1, #1
  BNE     loc_2081AAC

  loc_2081AD0                             ; CODE XREF: decode_unk_base_+B0Cj
                                          ; decode_unk_base_+C44j
  LDR     R1, [R8,#0x58]
  LDR     R0, [R8,#0x5C]
  LDR     R2, [R8,#0x60]
  ADD     R3, R1, R0
  CMP     R2, R3
  BCC     loc_20818C4

  loc_2081AE8                             ; CODE XREF: decode_unk_base_+A5Cj
                                          ; decode_unk_base_+B60j ...
  ADD     R0, R8, #0x128
  ADD     R0, R0, #0x400
  STR     R0, [R8,#0x64]
  STR     R0, [R8,#0x44]
  MOV     R0, #9
  STR     R0, [R8,#0x4C]
  ADD     R0, R8, #0x4C
  STR     R0, [SP,#0x60+var_60]
  ADD     R0, R8, #0x2E8
  STR     R0, [SP,#0x60+var_5C]
  LDR     R2, [R8,#0x58]
  ADD     R1, R8, #0x68
  ADD     R3, R8, #0x64
  MOV     R0, #1
  BL      decode_unk_
  STR     R0, [SP,#0x60+var_50]
  CMP     R0, #0
  BEQ     loc_2081B44
  LDR     R1, =aInvalidLiter_0            ; "invalid literal/lengths set"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081B44                             ; CODE XREF: decode_unk_base_+CD0j
  LDR     R1, [R8,#0x64]
  MOV     R0, #6
  STR     R1, [R8,#0x48]
  STR     R0, [R8,#0x50]
  ADD     R0, R8, #0x50
  STR     R0, [SP,#0x60+var_60]
  ADD     R0, R8, #0x2E8
  STR     R0, [SP,#0x60+var_5C]
  LDR     R0, [R8,#0x58]
  ADD     R1, R8, #0x68
  ADD     R1, R1, R0,LSL#1
  LDR     R2, [R8,#0x5C]
  ADD     R3, R8, #0x64
  MOV     R0, #2
  BL      decode_unk_
  STR     R0, [SP,#0x60+var_50]
  CMP     R0, #0
  BEQ     loc_2081BA0
  LDR     R1, =aInvalidDista_1            ; "invalid distances set"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081BA0                             ; CODE XREF: decode_unk_base_+D2Cj
  MOV     R0, #0x12
  STR     R0, [R8]

  loc_2081BA8                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F38j
  CMP     R4, #6                          ; jumptable 02080EE8 case 18
  LDRCS   R1, =0x102
  LDRCS   R0, [SP,#0x60+stru_10]
  CMPCS   R0, R1
  BCC     loc_2081C00
  STR     R11, [R9,#0xC]
  STR     R0, [R9,#0x10]
  STR     R7, [R9]
  STR     R4, [R9,#4]
  STR     R5, [R8,#0x30]
  LDR     R1, [SP,#0x60+stru_10_2]
  MOV     R0, R9
  STR     R6, [R8,#0x34]
  BL      decode_unk2
  LDR     R0, [R9,#0x10]
  LDR     R11, [R9,#0xC]
  STR     R0, [SP,#0x60+stru_10]
  LDR     R7, [R9]
  LDR     R4, [R9,#4]
  LDR     R5, [R8,#0x30]
  LDR     R6, [R8,#0x34]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081C00                             ; CODE XREF: decode_unk_base_+D5Cj
  LDR     R0, [R8,#0x4C]
  MOV     R1, #1
  MOV     R1, R1,LSL R0
  LDR     R0, [R8,#0x44]
  SUB     R1, R1, #1

  loc_2081C14                             ; CODE XREF: decode_unk_base_+DF8j
  AND     R2, R5, R1
  MOV     R3, R2,LSL#2
  ADD     R2, R0, R2,LSL#2
  LDRH    R3, [R0,R3]
  LDRH    R2, [R2,#2]
  STRH    R3, [SP,#0x60+var_38]
  STRH    R2, [SP,#0x60+var_36]
  LDRB    R3, [SP,#0x60+var_38+1]
  CMP     R6, R3
  BCS     loc_2081C58
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R2, [R7],#1
  ADD     R5, R5, R2,LSL R6
  ADD     R6, R6, #8
  B       loc_2081C14
  ; ---------------------------------------------------------------------------

  loc_2081C58                             ; CODE XREF: decode_unk_base_+DDCj
  LDRB    R1, [SP,#0x60+var_38]
  CMP     R1, #0
  BEQ     loc_2081CEC
  TST     R1, #0xF0
  BNE     loc_2081CEC
  LDRH    R2, [SP,#0x60+var_38]
  LDRH    R3, [SP,#0x60+var_36]
  MOV     R1, #1
  STRH    R2, [SP,#0x60+var_2C]
  LDRB    R2, [SP,#0x60+var_2C+1]
  LDRB    R10, [SP,#0x60+var_2C]
  STRH    R3, [SP,#0x60+var_2A]
  ADD     R0, R0, R3,LSL#2
  ADD     R10, R2, R10
  MOV     R1, R1,LSL R10
  SUB     R1, R1, #1

  loc_2081C98                             ; CODE XREF: decode_unk_base_+E84j
  AND     R3, R5, R1
  MOV     R10, R3,LSR R2
  MOV     R3, R10,LSL#2
  ADD     R10, R0, R10,LSL#2
  LDRH    R3, [R3,R0]
  LDRH    R10, [R10,#2]
  STRH    R3, [SP,#0x60+var_38]
  STRH    R10, [SP,#0x60+var_36]
  LDRB    R3, [SP,#0x60+var_38+1]
  ADD     R10, R2, R3
  CMP     R6, R10
  BCS     loc_2081CE4
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R3, [R7],#1
  ADD     R5, R5, R3,LSL R6
  ADD     R6, R6, #8
  B       loc_2081C98
  ; ---------------------------------------------------------------------------

  loc_2081CE4                             ; CODE XREF: decode_unk_base_+E68j
  MOV     R5, R5,LSR R2
  SUB     R6, R6, R2

  loc_2081CEC                             ; CODE XREF: decode_unk_base_+E04j
                                          ; decode_unk_base_+E0Cj
  LDRH    R0, [SP,#0x60+var_36]
  MOV     R5, R5,LSR R3
  STR     R0, [R8,#0x38]
  LDRB    R0, [SP,#0x60+var_38]
  SUB     R6, R6, R3
  CMP     R0, #0
  MOVEQ   R0, #0x17
  STREQ   R0, [R8]
  BEQ     state_switch
  TST     R0, #0x20
  MOVNE   R0, #0xB
  STRNE   R0, [R8]
  BNE     state_switch
  TST     R0, #0x40
  BEQ     loc_2081D3C
  LDR     R1, =aInvalidLiter_1            ; "invalid literal/length code"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081D3C                             ; CODE XREF: decode_unk_base_+EC8j
  AND     R0, R0, #0xF
  STR     R0, [R8,#0x40]
  MOV     R0, #0x13
  STR     R0, [R8]

  loc_2081D4C                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F3Cj
  LDR     R1, [R8,#0x40]                  ; jumptable 02080EE8 case 19
  CMP     R1, #0
  BEQ     loc_2081DA8
  CMP     R6, R1
  BCS     loc_2081D80

  loc_2081D60                             ; CODE XREF: decode_unk_base_+F20j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, R1
  BCC     loc_2081D60

  loc_2081D80                             ; CODE XREF: decode_unk_base_+F00j
  MOV     R0, #1
  MOV     R0, R0,LSL R1
  SUB     R0, R0, #1
  LDR     R1, [R8,#0x38]
  AND     R0, R5, R0
  ADD     R0, R1, R0
  STR     R0, [R8,#0x38]
  LDR     R0, [R8,#0x40]
  MOV     R5, R5,LSR R0
  SUB     R6, R6, R0

  loc_2081DA8                             ; CODE XREF: decode_unk_base_+EF8j
  MOV     R0, #0x14
  STR     R0, [R8]

  loc_2081DB0                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F40j
  LDR     R0, [R8,#0x50]                  ; jumptable 02080EE8 case 20
  MOV     R1, #1
  MOV     R1, R1,LSL R0
  LDR     R0, [R8,#0x48]
  SUB     R1, R1, #1

  loc_2081DC4                             ; CODE XREF: decode_unk_base_+FA8j
  AND     R2, R5, R1
  MOV     R3, R2,LSL#2
  ADD     R2, R0, R2,LSL#2
  LDRH    R3, [R0,R3]
  LDRH    R2, [R2,#2]
  STRH    R3, [SP,#0x60+var_34]
  STRH    R2, [SP,#0x60+var_32]
  LDRB    R3, [SP,#0x60+var_34+1]
  CMP     R6, R3
  BCS     loc_2081E08
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R2, [R7],#1
  ADD     R5, R5, R2,LSL R6
  ADD     R6, R6, #8
  B       loc_2081DC4
  ; ---------------------------------------------------------------------------

  loc_2081E08                             ; CODE XREF: decode_unk_base_+F8Cj
  LDRB    R1, [SP,#0x60+var_34]
  TST     R1, #0xF0
  BNE     loc_2081E94
  LDRH    R2, [SP,#0x60+var_34]
  LDRH    R3, [SP,#0x60+var_32]
  MOV     R1, #1
  STRH    R2, [SP,#0x60+var_3C]
  LDRB    R2, [SP,#0x60+var_3C+1]
  LDRB    R10, [SP,#0x60+var_3C]
  STRH    R3, [SP,#0x60+var_3A]
  ADD     R0, R0, R3,LSL#2
  ADD     R10, R2, R10
  MOV     R1, R1,LSL R10
  SUB     R1, R1, #1

  loc_2081E40                             ; CODE XREF: decode_unk_base_+102Cj
  AND     R3, R5, R1
  MOV     R10, R3,LSR R2
  MOV     R3, R10,LSL#2
  ADD     R10, R0, R10,LSL#2
  LDRH    R3, [R3,R0]
  LDRH    R10, [R10,#2]
  STRH    R3, [SP,#0x60+var_34]
  STRH    R10, [SP,#0x60+var_32]
  LDRB    R3, [SP,#0x60+var_34+1]
  ADD     R10, R2, R3
  CMP     R6, R10
  BCS     loc_2081E8C
  CMP     R4, #0
  BEQ     close_quit
  SUB     R4, R4, #1
  LDRB    R3, [R7],#1
  ADD     R5, R5, R3,LSL R6
  ADD     R6, R6, #8
  B       loc_2081E40
  ; ---------------------------------------------------------------------------

  loc_2081E8C                             ; CODE XREF: decode_unk_base_+1010j
  MOV     R5, R5,LSR R2
  SUB     R6, R6, R2

  loc_2081E94                             ; CODE XREF: decode_unk_base_+FB4j
  LDRB    R0, [SP,#0x60+var_34]
  MOV     R5, R5,LSR R3
  SUB     R6, R6, R3
  TST     R0, #0x40
  BEQ     loc_2081EBC
  LDR     R1, =aInvalidDista_2            ; "invalid distance code"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2081EBC                             ; CODE XREF: decode_unk_base_+1048j
  LDRH    R2, [SP,#0x60+var_32]
  AND     R1, R0, #0xF
  MOV     R0, #0x15
  STR     R2, [R8,#0x3C]
  STR     R1, [R8,#0x40]
  STR     R0, [R8]

  loc_2081ED4                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F44j
  LDR     R1, [R8,#0x40]                  ; jumptable 02080EE8 case 21
  CMP     R1, #0
  BEQ     loc_2081F30
  CMP     R6, R1
  BCS     loc_2081F08

  loc_2081EE8                             ; CODE XREF: decode_unk_base_+10A8j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, R1
  BCC     loc_2081EE8

  loc_2081F08                             ; CODE XREF: decode_unk_base_+1088j
  MOV     R0, #1
  MOV     R0, R0,LSL R1
  SUB     R0, R0, #1
  LDR     R1, [R8,#0x3C]
  AND     R0, R5, R0
  ADD     R0, R1, R0
  STR     R0, [R8,#0x3C]
  LDR     R0, [R8,#0x40]
  MOV     R5, R5,LSR R0
  SUB     R6, R6, R0

  loc_2081F30                             ; CODE XREF: decode_unk_base_+1080j
  LDR     R2, [R8,#0x24]
  LDR     R1, [SP,#0x60+stru_10_2]
  LDR     R0, [R8,#0x3C]
  ADD     R2, R2, R1
  LDR     R1, [SP,#0x60+stru_10]
  SUB     R1, R2, R1
  CMP     R0, R1
  BLS     loc_2081FB8
  LDR     R1, =aInvalidDista_3            ; "invalid distance too far back"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------
  dword_2081F64 DCD 0x8B1F                ; DATA XREF: decode_unk_base_+150r
  dword_2081F68 DCD 0x8421085             ; DATA XREF: decode_unk_base_+1C4r
  off_2081F6C DCD aIncorrectHeade         ; DATA XREF: decode_unk_base_:loc_2081044r
                                          ; "incorrect header check"
  off_2081F70 DCD aUnknownCompres         ; DATA XREF: decode_unk_base_+208r
                                          ; decode_unk_base_+2B4r
                                          ; "unknown compression method"
  off_2081F74 DCD aInvalidWindowS         ; DATA XREF: decode_unk_base_+238r
                                          ; "invalid window size"
  off_2081F78 DCD aUnknownHeaderF         ; DATA XREF: decode_unk_base_+2D0r
                                          ; "unknown header flags set"
  off_2081F7C DCD aHeaderCrcMisma         ; DATA XREF: decode_unk_base_+600r
                                          ; "header crc mismatch"
  off_2081F80 DCD aInvalidBlockTy         ; DATA XREF: decode_unk_base_:loc_2081600r
                                          ; "invalid block type"
  dword_2081F84 DCD 0xFFFF                ; DATA XREF: decode_unk_base_:loc_2081650r
  off_2081F88 DCD aInvalidStoredB         ; DATA XREF: decode_unk_base_+80Cr
                                          ; "invalid stored block lengths"
  dword_2081F8C DCD 0x11E                 ; DATA XREF: decode_unk_base_+8FCr
  off_2081F90 DCD aTooManyLengthO         ; DATA XREF: decode_unk_base_+918r
                                          ; "too many length or distance symbols"
  off_2081F94 DCD dword_20B71B0           ; DATA XREF: decode_unk_base_:loc_2081798r
                                          ; decode_unk_base_+9ACr
  off_2081F98 DCD aInvalidCodeLen         ; DATA XREF: decode_unk_base_+A24r
                                          ; "invalid code lengths set"
  off_2081F9C DCD aInvalidBitLeng         ; DATA XREF: decode_unk_base_+B50r
                                          ; decode_unk_base_+C28r
                                          ; "invalid bit length repeat"
  off_2081FA0 DCD aInvalidLiter_0         ; DATA XREF: decode_unk_base_+CD4r
                                          ; "invalid literal/lengths set"
  off_2081FA4 DCD aInvalidDista_1         ; DATA XREF: decode_unk_base_+D30r
                                          ; "invalid distances set"
  dword_2081FA8 DCD 0x102                 ; DATA XREF: decode_unk_base_+D50r
  off_2081FAC DCD aInvalidLiter_1         ; DATA XREF: decode_unk_base_+ECCr
                                          ; "invalid literal/length code"
  off_2081FB0 DCD aInvalidDista_2         ; DATA XREF: decode_unk_base_+104Cr
                                          ; "invalid distance code"
  off_2081FB4 DCD aInvalidDista_3         ; DATA XREF: decode_unk_base_+10F4r
                                          ; "invalid distance too far back"
  ; ---------------------------------------------------------------------------

  loc_2081FB8                             ; CODE XREF: decode_unk_base_+10F0j
  MOV     R0, #0x16
  STR     R0, [R8]

  loc_2081FC0                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F48j
  LDR     R0, [SP,#0x60+stru_10]           ; jumptable 02080EE8 case 22
  CMP     R0, #0
  BEQ     close_quit
  LDR     R1, [SP,#0x60+stru_10_2]
  LDR     R2, [R8,#0x3C]
  SUB     R0, R1, R0
  CMP     R2, R0
  BLS     loc_208201C
  SUB     R1, R2, R0
  LDR     R0, [R8,#0x28]
  CMP     R1, R0
  SUBLS   R0, R0, R1
  LDRLS   R2, [R8,#0x2C]
  BLS     loc_2082008
  SUB     R1, R1, R0
  LDR     R0, [R8,#0x20]
  LDR     R2, [R8,#0x2C]
  SUB     R0, R0, R1

  loc_2082008                             ; CODE XREF: decode_unk_base_+1198j
  ADD     R0, R2, R0
  LDR     R2, [R8,#0x38]
  CMP     R1, R2
  MOVHI   R1, R2
  B       loc_2082024
  ; ---------------------------------------------------------------------------

  loc_208201C                             ; CODE XREF: decode_unk_base_+1180j
  LDR     R1, [R8,#0x38]
  SUB     R0, R11, R2

  loc_2082024                             ; CODE XREF: decode_unk_base_+11BCj
  LDR     R2, [SP,#0x60+stru_10]
  CMP     R1, R2
  MOVHI   R1, R2
  LDR     R2, [SP,#0x60+stru_10]
  SUB     R2, R2, R1
  STR     R2, [SP,#0x60+stru_10]
  LDR     R2, [R8,#0x38]
  SUB     R2, R2, R1
  STR     R2, [R8,#0x38]

  loc_2082048                             ; CODE XREF: decode_unk_base_+11FCj
  LDRB    R2, [R0],#1
  SUBS    R1, R1, #1
  SWPB    R2, R2, [R11]
  ADD     R11, R11, #1
  BNE     loc_2082048
  LDR     R0, [R8,#0x38]
  CMP     R0, #0
  MOVEQ   R0, #0x12
  STREQ   R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_2082070                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F4Cj
  LDR     R0, [SP,#0x60+stru_10]           ; jumptable 02080EE8 case 23
  CMP     R0, #0
  BEQ     close_quit
  LDR     R0, [R8,#0x38]
  MOV     R1, #0x12
  SWPB    R0, R0, [R11]
  ADD     R11, R11, #1
  LDR     R0, [SP,#0x60+stru_10]
  STR     R1, [R8]
  SUB     R0, R0, #1
  STR     R0, [SP,#0x60+stru_10]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_20820A0                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F50j
  LDR     R0, [R8,#8]                     ; jumptable 02080EE8 case 24
  CMP     R0, #0
  BEQ     loc_2082184
  CMP     R6, #0x20 ; ' '
  BCS     loc_20820D4

  loc_20820B4                             ; CODE XREF: decode_unk_base_+1274j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x20 ; ' '
  BCC     loc_20820B4

  loc_20820D4                             ; CODE XREF: decode_unk_base_+1254j
  LDR     R1, [SP,#0x60+stru_10_2]
  LDR     R0, [SP,#0x60+stru_10]
  LDR     R3, [R9,#0x14]
  SUBS    R2, R1, R0
  ADD     R0, R3, R2
  STR     R0, [R9,#0x14]
  LDR     R0, [R8,#0x18]
  ADD     R0, R0, R2
  STR     R0, [R8,#0x18]
  BEQ     loc_2082124
  LDR     R0, [R8,#0x10]
  SUB     R1, R11, R2
  CMP     R0, #0
  LDR     R0, [R8,#0x14]
  BEQ     loc_2082118
  BL      sub_20804BC
  B       loc_208211C
  ; ---------------------------------------------------------------------------

  loc_2082118                             ; CODE XREF: decode_unk_base_+12B0j
  BL      sub_20804C8

  loc_208211C                             ; CODE XREF: decode_unk_base_+12B8j
  STR     R0, [R8,#0x14]
  STR     R0, [R9,#0x30]

  loc_2082124                             ; CODE XREF: decode_unk_base_+129Cj
  LDR     R1, [R8,#0x10]
  LDR     R0, [SP,#0x60+stru_10]
  CMP     R1, #0
  STR     R0, [SP,#0x60+stru_10_2]
  MOVNE   R1, R5
  BNE     loc_208215C
  MOV     R1, R5,LSR#24
  MOV     R0, R5,LSR#8
  AND     R1, R1, #0xFF
  AND     R0, R0, #0xFF00
  ADD     R0, R1, R0
  AND     R1, R5, #0xFF00
  ADD     R0, R0, R1,LSL#8
  ADD     R1, R0, R5,LSL#24

  loc_208215C                             ; CODE XREF: decode_unk_base_+12DCj
  LDR     R0, [R8,#0x14]
  CMP     R0, R1
  BEQ     loc_208217C
  LDR     R1, =aIncorrectDataC            ; "incorrect data check"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_208217C                             ; CODE XREF: decode_unk_base_+1308j
  MOV     R5, #0
  MOV     R6, R5

  loc_2082184                             ; CODE XREF: decode_unk_base_+124Cj
  MOV     R0, #0x19
  STR     R0, [R8]

  loc_208218C                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F54j
  LDR     R0, [R8,#8]                     ; jumptable 02080EE8 case 25
  CMP     R0, #0
  LDRNE   R0, [R8,#0x10]
  CMPNE   R0, #0
  BEQ     loc_20821F0
  CMP     R6, #0x20 ; ' '
  BCS     loc_20821C8

  loc_20821A8                             ; CODE XREF: decode_unk_base_+1368j
  CMP     R4, #0
  BEQ     close_quit
  LDRB    R0, [R7],#1
  SUB     R4, R4, #1
  ADD     R5, R5, R0,LSL R6
  ADD     R6, R6, #8
  CMP     R6, #0x20 ; ' '
  BCC     loc_20821A8

  loc_20821C8                             ; CODE XREF: decode_unk_base_+1348j
  LDR     R0, [R8,#0x18]
  CMP     R5, R0
  BEQ     loc_20821E8
  LDR     R1, =aIncorrectLengt            ; "incorrect length check"
  MOV     R0, #0x1B
  STR     R1, [R9,#0x18]
  STR     R0, [R8]
  B       state_switch
  ; ---------------------------------------------------------------------------

  loc_20821E8                             ; CODE XREF: decode_unk_base_+1374j
  MOV     R5, #0
  MOV     R6, R5

  loc_20821F0                             ; CODE XREF: decode_unk_base_+1340j
  MOV     R0, #0x1A
  STR     R0, [R8]

  loc_20821F8                             ; CODE XREF: decode_unk_base_+8Cj
                                          ; decode_unk_base_:loc_2080F58j
  MOV     R0, #1                          ; jumptable 02080EE8 case 26
  STR     R0, [SP,#0x60+var_50]
  B       close_quit
  ; ---------------------------------------------------------------------------

error3_quit:
  MOV     R0, 0xFFFFFFFD
  STR     R0, [SP,#0x60+var_50]
  B       close_quit

error4_quit:
  ADD     SP, SP, #0x3C
  MOV     R0, 0xFFFFFFFC
  LDMFD   SP!, {R4-R11,PC}

error2_quit:
  ADD     SP, SP, #0x3C
  MOV     R0, 0xFFFFFFFE
  LDMFD   SP!, {R4-R11,PC}

close_quit:
  LDR     R0, [SP,#0x60+stru_10]
  STR     R11, [R9,#0xC]
  STR     R0, [R9,#0x10]
  STR     R7, [R9]
  STR     R4, [R9,#4]
  STR     R5, [R8,#0x30]
  STR     R6, [R8,#0x34]
  LDR     R0, [R8,#0x20]
  CMP     R0, #0
  BNE     loc_208226C
  LDR     R0, [R8]
  CMP     R0, #0x18
  BGE     loc_2082294
  LDR     R1, [R9,#0x10]
  LDR     R0, [SP,#0x60+stru_10_2]
  CMP     R0, R1
  BEQ     loc_2082294

  loc_208226C                             ; CODE XREF: decode_unk_base_+13F0j
  LDR     R1, [SP,#0x60+stru_10_2]
  MOV     R0, R9
  BL      sub_2080D2C
  CMP     R0, #0
  BEQ     loc_2082294
  MOV     R0, #0x1C
  STR     R0, [R8]
  ADD     SP, SP, #0x3C
  SUB     R0, R0, #0x20
  LDMFD   SP!, {R4-R11,PC}
  ; ---------------------------------------------------------------------------

  loc_2082294                             ; CODE XREF: decode_unk_base_+13FCj
                                          ; decode_unk_base_+140Cj ...
  LDR     R2, [R9,#4]
  LDR     R0, [SP,#0x60+inSize]
  LDR     R1, [R9,#8]
  SUB     R0, R0, R2
  STR     R0, [SP,#0x60+inSize]
  LDR     R2, [R9,#0x10]
  ADD     R0, R1, R0
  STR     R0, [R9,#8]
  LDR     R0, [SP,#0x60+stru_10_2]
  LDR     R1, [R9,#0x14]
  SUB     R0, R0, R2
  STR     R0, [SP,#0x60+stru_10_2]
  ADD     R0, R1, R0
  STR     R0, [R9,#0x14]
  LDR     R1, [R8,#0x18]
  LDR     R0, [SP,#0x60+stru_10_2]
  ADD     R0, R1, R0
  STR     R0, [R8,#0x18]
  LDR     R0, [R8,#8]
  CMP     R0, #0
  LDRNE   R0, [SP,#0x60+stru_10_2]
  CMPNE   R0, #0
  BEQ     loc_2082330
  LDR     R0, [R8,#0x10]
  LDR     R3, [R9,#0xC]
  CMP     R0, #0
  LDR     R0, [R8,#0x14]
  BEQ     loc_2082318
  LDR     R2, [SP,#0x60+stru_10_2]
  MOV     R1, R2
  SUB     R1, R3, R1
  BL      sub_20804BC
  B       loc_2082328
  ; ---------------------------------------------------------------------------

  loc_2082318                             ; CODE XREF: decode_unk_base_+14A4j
  LDR     R2, [SP,#0x60+stru_10_2]
  MOV     R1, R2
  SUB     R1, R3, R1
  BL      sub_20804C8

  loc_2082328                             ; CODE XREF: decode_unk_base_+14B8j
  STR     R0, [R8,#0x14]
  STR     R0, [R9,#0x30]

  loc_2082330                             ; CODE XREF: decode_unk_base_+1490j
  LDR     R0, [R8]
  LDR     R1, [R8,#0x34]
  CMP     R0, #0xB
  MOVEQ   R2, #0x80 ; 'Ç'
  LDR     R0, [R8,#4]
  MOVNE   R2, #0
  CMP     R0, #0
  MOVNE   R3, #0x40 ; '@'
  LDR     R0, [SP,#0x60+inSize]
  MOVEQ   R3, #0
  CMP     R0, #0
  ADD     R0, R1, R3
  ADD     R0, R0, R2
  STR     R0, [R9,#0x2C]
  LDREQ   R0, [SP,#0x60+stru_10_2]
  CMPEQ   R0, #0
  BEQ     loc_2082380
  LDR     R0, [SP,#0x60+arg1]
  CMP     R0, #4
  BNE     loc_2082390

  loc_2082380                             ; CODE XREF: decode_unk_base_+1514j
  LDR     R0, [SP,#0x60+var_50]
  CMP     R0, #0
  MOVEQ   R0, 0xFFFFFFFB
  STREQ   R0, [SP,#0x60+var_50]

  loc_2082390                             ; CODE XREF: decode_unk_base_+1520j
  LDR     R0, [SP,#0x60+var_50]
  ADD     SP, SP, #0x3C
  LDMFD   SP!, {R4-R11,PC}
  ; End of function decode_unk_base_

  ; ---------------------------------------------------------------------------
  off_208239C DCD aIncorrectDataC         ; DATA XREF: decode_unk_base_+130Cr
                                          ; "incorrect data check"
  off_20823A0 DCD aIncorrectLengt         ; DATA XREF: decode_unk_base_+1378r
                                          ; "incorrect length check"
