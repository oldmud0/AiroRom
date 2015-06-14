;; Function to decode script files
;; Arguments:
;;   + R0: Struct
;;   + R1: ??
;;   + arg1: ??
;;
;; Stack variables:
;;  + var_88= -0x88
;;  + var_84= -0x84
;;  + structPtr= -0x80
;;  + arg1= -0x7C
;;  + var_78= -0x78
;;  + var_74= -0x74
;;  + var_70= -0x70
;;  + var_6C= -0x6C
;;  + var_68= -0x68
;;  + var_64= -0x64
;;  + var_60= -0x60
;;  + var_5C= -0x5C
;;  + isFinished= -0x58
;;  + bytesToDec2= -0x54
;;  + inputSize= -0x50
;;  + bytesToDec= -0x4C
;;  + var_48= -0x48
;;  + var_44= -0x44
;;  + var_40= -0x40
;;  + var_3C= -0x3C
;;  + var_38= -0x38
;;  + var_37= -0x37
;;  + unByteDec= -0x36
;;  + var_34= -0x34
;;  + var_30= -0x30
;;  + var_2C= -0x2C
;;  + var_2B= -0x2B
;;  + var_2A= -0x2A
;;  + var_28= -0x28
;;  + var_27= -0x27
;;  + var_26= -0x26
;;
;; Struct of R0
;;  + 0x0000 -> Pointer to encoded data
;;  + 0x0004 -> Encoded size
;;  + 0x000C -> R11
;;  + 0x0010 -> Bytes to decode
;;  + 0x8018 -> State
;;  + 0x801C -> Set from token at 5 [bool]
;;  + 0x8024 -> Set to 0 at init
;;  + 0x8028 -> Set to size at init
;;  + 0x8038 -> Token
;;  + 0x803C -> Token bit size
;;  + 0x805C -> Something in case 8 with token
;;  + 0x8060 -> Something in case 8 with token
;;  + 0x8064 -> Something in case 8 with token
;;  + 0x8068 -> Something in case 8
;;  + 0xA534 -> Set to size at init
;;
;; State enum
;;  + 0 ->
;;  + 1 ->
;;  + 2 ->
;;  + 3 ->
;;  + 4 -> check at the init and set to 5
;;  + 5 -> set at init if it's 4

  ; Start, save registers and parameters
  STMFD   SP!, {R4-R11,LR}
  SUB     SP, SP, #0x64
  STR     R0, [SP,#0x88+structPtr]
  STR     R1, [SP,#0x88+arg1]

  ; Set R5 to the start of important data?
  ADD     R5, R0, #0x18

  ; If state is "4" set to "5"
  ADD     R0, R5, #0x8000
  LDR     R2, [R0]
  CMP     R2, #4
  MOVEQ   R1, #5
  STREQ   R1, [R0]

  ; Copy bytes to decode
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R0, [R0,#0x10]
  STR     R0, [SP,#0x88+bytesToDec]

  ; Get current decode vars
  ADD     R1, R5, #0x8000
  LDR     R7, [R1,#0x20]                ; Get token
  LDR     R8, [R1,#0x24]                ; Get token bits unprocessed

  LDR     R0, [SP,#0x88+structPtr]
  LDR     R9, [R0]                      ; Get input pointer
  LDR     R6, [R0,#4]                   ; Get input size
  LDR     R11, [R0,#0xC]

  STR     R6, [SP,#0x88+inputSize]
  LDR     R0, [SP,#0x88+bytesToDec]
  STR     R0, [SP,#0x88+bytesToDec2]

  ; Set is finished to true
  MOV     R0, #0
  STR     R0, [SP,#0x88+isFinished]

main_loop:
  ; Get state
  ADD     R1, R5, #0x8000
  LDR     R0, [R1]

  ; Switch for state (23 cases)
  CMP     R0, #0x16
  ADDLS   PC, PC, R0,LSL#2                ; Jump!
  B       caseDefault_error               ; default: error
  B       case0                           ; case 0: init
  B       caseDefault_error               ; case 1: error
  B       caseDefault_error               ; case 2: error
  B       caseDefault_error               ; case 3: error
  B       case4                           ; case 4: jump over 5
  B       case5                           ; case 5
  B       loc_2026204                     ; case 6
  B       loc_2026270                     ; case 7
  B       case8                           ; case 8
  B       case9                           ; case 9
  B       loc_20264B4                     ; case 10
  B       loc_20267F8                     ; case 11
  B       loc_2026E94                     ; case 12
  B       loc_2026F04                     ; case 13
  B       loc_2027028                     ; case 14
  B       loc_20270C0                     ; case 15
  B       loc_202716C                     ; case 16
  B       loc_2027194                     ; case 17: If 0x801C not 0 at 5
  B       loc_20272A8                     ; case 18
  B       loc_202730C                     ; case 19
  B       loc_2027318                     ; case 20: not divisible by 31 or not 8
  B       case21_error                    ; case 21
  B       caseDefault_error               ; case 22: error

case0:
  ; Get a 16-bits token
  CMP     R8, #0x10
  BCS     case0_init

readToken:
  CMP     R6, #0                        ; Check if we have still data
  BEQ     ranOutData_                   ; ...
  LDRB    R0, [R9],#1                   ; Read byte
  ADD     R7, R7, R0,LSL R8             ; ... and or it to the token
  SUB     R6, R6, #1                    ; Decrease input size
  ADD     R8, R8, #8                    ; Increase token size
  CMP     R8, #0x10                     ; Check for 16 bits
  BCC     readToken                     ; ...

case0_init:
  ; Swap token bytes
  MOV     R1, R7,LSL#24
  MOV     R0, R7,LSR#8
  ADD     R0, R0, R1,LSR#16

  ; Get the modulo of token swapped and 31 (token swapped % 31)
  LDR     R1, =0x8421085                ; Divide by 0x1F
  UMULL   R1, R3, R0, R1                ; ... 0x8421085 == -(0xFFFFFFFF/0x1F)
  SUB     R2, R0, R3                    ; ...
  ADD     R3, R3, R2,LSR#1              ; ...
  MOV     R3, R3,LSR#4                  ; ...
  MOV     R4, #0x1F                     ; Multiply by 0x1F the quotient
  UMULL   R2, R3, R4, R3                ; ... to substract with the original
  SUBS    R3, R0, R2                    ; ... and get the modulo

  MOV     R2, #0
  ADD     R1, R5, #0x8000
  STR     R2, [R1,#0xC]

  ; If it's not divisible by 31, set state to 20
  MOVNE   R0, #20
  STRNE   R0, [R1]
  BNE     main_loop

  ; If token 4 bits is not 8, set state to 20
  AND     R0, R7, #0xF
  CMP     R0, #8
  MOVNE   R0, #20
  STRNE   R0, [R1]
  BNE     main_loop

  ; Remove 4 bits from token
  MOV     R7, R7,LSR#4
  SUB     R8, R8, #4

  ; Get a size
  AND     R0, R7, #0xF
  ADD     R0, R0, #8

  ; If size > 32 KB, set state to 20
  CMP     R0, #0xF
  MOVHI   R0, #0x14
  STRHI   R0, [R1]
  BHI     main_loop

  ; Store size value
  MOV     R2, #1
  MOV     R0, R2,LSL R0
  STR     R0, [R1,#0x10]

  LDR     R0, [SP,#0x88+structPtr]
  ADD     R0, R0, #0xA000
  STR     R2, [R0,#0x534]

  ; If bit 9 is set, error, otherwise set state 4
  TST     R7, #0x200
  MOVNE   R1, #2
  MOVEQ   R1, #4
  ADD     R0, R5, #0x8000
  STR     R1, [R0]

  ; Clean token and jump
  MOV     R7, #0
  MOV     R8, R7
  B       main_loop

case4:
  LDR     R0, [SP,#0x88+arg1]
  CMP     R0, #5
  BEQ     ranOutData_

case5:
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#4]
  CMP     R1, #0
  BEQ     loc_2026000

  ; Token size must be multiple of 8, make it
  AND     R1, R8, #7
  MOV     R7, R7,LSR R1
  SUB     R8, R8, R1

  ; Jump to state 17
  MOV     R1, #17
  STR     R1, [R0]
  B       main_loop

loc_2026000
  ; Check if we have 3 bits in the token, otherwise read a new
  CMP     R8, #3
  BCS     loc_2026028

case5_readToken:
  ; Check for input data
  CMP     R6, #0
  BEQ     ranOutData_

  ; Add 8 bits to the token (this is probably inline)
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, #3
  BCC     case5_readToken

loc_2026028
  ; Get a bit from the token and store it
  AND     R1, R7, #1                    ; Get token bit
  MOV     R7, R7,LSR#1                  ; Remove it from token
  ADD     R0, R5, #0x8000               ; Store it
  STR     R1, [R0,#4]                   ; ...

  ; Switch with the following 2 bits
  AND     R1, R7, #3                    ; Get token bit
  CMP     R1, #3
  ADDLS   PC, PC, R1,LSL#2              ; Jump!
  B       case5_updateToken             ; default case
  B       case5_0_state6                ; case0
  B       loc_2026064                   ; case1
  B       case5_2_state8                ; case2
  B       case5_3_state20               ; case3

case5_0_state6:
  ; Set state to 6
  MOV     R1, #6
  STR     R1, [R0]
  B       case5_updateToken

loc_2026064:
  LDR     R0, =0x209BBDC
  LDR     R0, [R0]
  CMP     R0, #0
  BEQ     loc_20261AC
  MOV     R0, #0
  MOV     R2, #8

  loc_202607C
  ADD     R1, R5, R0,LSL#1
  ADD     R1, R1, #0xA000
  ADD     R0, R0, #1
  STRH    R2, [R1,#0x58]
  CMP     R0, #0x90
  BCC     loc_202607C
  CMP     R0, #0x100
  BCS     loc_20260B8
  MOV     R2, #9

  loc_20260A0
  ADD     R1, R5, R0,LSL#1
  ADD     R1, R1, #0xA000
  ADD     R0, R0, #1
  STRH    R2, [R1,#0x58]
  CMP     R0, #0x100
  BCC     loc_20260A0

  loc_20260B8
  CMP     R0, #0x118
  BCS     loc_20260DC
  MOV     R2, #7

  loc_20260C4
  ADD     R1, R5, R0,LSL#1
  ADD     R1, R1, #0xA000
  ADD     R0, R0, #1
  STRH    R2, [R1,#0x58]
  CMP     R0, #0x118
  BCC     loc_20260C4

  loc_20260DC                             ; CODE XREF: decode_block+29Cj
  CMP     R0, #0x120
  BCS     loc_2026100
  MOV     R2, #8

  loc_20260E8                             ; CODE XREF: decode_block+2DCj
  ADD     R1, R5, R0,LSL#1
  ADD     R1, R1, #0xA000
  ADD     R0, R0, #1
  STRH    R2, [R1,#0x58]
  CMP     R0, #0x120
  BCC     loc_20260E8

  loc_2026100                             ; CODE XREF: decode_block+2C0j
  MOV     R0, #9
  LDR     R3, =dword_215FF48
  STR     R0, [SP,#0x88+var_30]
  ADD     R0, R5, #0x2D8
  ADD     R1, R0, #0xA000
  LDR     R0, =dword_215E134
  STR     R3, [SP,#0x88+var_34]
  STR     R3, [R0]
  ADD     R2, SP, #0x88+var_30
  STR     R2, [SP,#0x88+var_88]
  ADD     R0, R5, #0x58
  STR     R1, [SP,#0x88+var_84]
  ADD     R1, R0, #0xA000
  ADD     R3, SP, #0x88+var_34
  MOV     R0, #1
  MOV     R2, #0x120
  BL      sub_2027570
  MOV     R2, #0
  MOV     R1, #5

  loc_202614C                             ; CODE XREF: decode_block+340j
  ADD     R0, R5, R2,LSL#1
  ADD     R0, R0, #0xA000
  ADD     R2, R2, #1
  STRH    R1, [R0,#0x58]
  CMP     R2, #0x20 ; ' '
  BCC     loc_202614C
  LDR     R2, [SP,#0x88+var_34]
  LDR     R0, =dword_215E138
  STR     R1, [SP,#0x88+var_30]
  STR     R2, [R0]
  ADD     R1, SP, #0x88+var_30
  ADD     R0, R5, #0x2D8
  STR     R1, [SP,#0x88+var_88]
  ADD     R1, R5, #0x58
  ADD     R0, R0, #0xA000
  STR     R0, [SP,#0x88+var_84]
  ADD     R3, SP, #0x88+var_34
  ADD     R1, R1, #0xA000
  MOV     R0, #2
  MOV     R2, #0x20 ; ' '
  BL      sub_2027570
  LDR     R0, =dword_209BBDC
  MOV     R1, #0
  STR     R1, [R0]

  loc_20261AC                             ; CODE XREF: decode_block+250j
  LDR     R1, =dword_215E134
  LDR     R0, =dword_215E138
  LDR     R2, [R1]
  LDR     R1, [R0]
  ADD     R0, R5, #0x8000
  STR     R2, [R0,#0x34]
  MOV     R2, #9
  STR     R2, [R0,#0x3C]
  STR     R1, [R0,#0x38]
  MOV     R1, #5
  STR     R1, [R0,#0x40]
  MOV     R1, #0xB
  STR     R1, [R0]
  B       case5_updateToken                     ; jumptable 02026040 default case
  ; ---------------------------------------------------------------------------

case5_2_state8:
  ; Set state to 8
  MOV     R1, #8
  STR     R1, [R0]
  B       case5_updateToken

case5_3_state20:
  ; Set state to 20
  MOV     R1, #0x14
  STR     R1, [R0]

case5_updateToken:
  ; Remove the switch 2 bits from token and update token size
  MOV     R7, R7,LSR#2
  SUB     R8, R8, #3
  B       main_loop

  loc_2026204                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EB0j
  AND     R0, R8, #7                      ; jumptable 02025E90 case 6
  SUB     R8, R8, R0
  MOV     R7, R7,LSR R0
  CMP     R8, #0x20 ; ' '
  BCS     loc_2026238

  loc_2026218                             ; CODE XREF: decode_block+414j
  CMP     R6, #0
  BEQ     ranOutData_
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, #0x20 ; ' '
  BCC     loc_2026218

  loc_2026238                             ; CODE XREF: decode_block+3F4j
  LDR     R1, =0xFFFF
  MOV     R0, R7,LSL#16
  MOV     R2, R0,LSR#16
  EOR     R0, R1, R7,LSR#16
  CMP     R2, R0
  ADD     R0, R5, #0x8000
  MOVNE   R1, #0x14
  STRNE   R1, [R0]
  BNE     main_loop
  MOV     R7, #0
  STR     R2, [R0,#0x28]
  MOV     R1, #7
  MOV     R8, R7
  STR     R1, [R0]

  loc_2026270                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EB4j
  ADD     R0, R5, #0x8000                 ; jumptable 02025E90 case 7
  LDR     R4, [R0,#0x28]
  CMP     R4, #0
  BEQ     loc_20262D8
  LDR     R0, [SP,#0x88+bytesToDec]
  CMP     R4, R6
  MOVHI   R4, R6
  CMP     R4, R0
  MOVHI   R4, R0
  CMP     R4, #0
  BEQ     ranOutData_
  MOV     R0, R11
  MOV     R1, R9
  MOV     R2, R4
  BL      api_mem_copy
  LDR     R0, [SP,#0x88+bytesToDec]
  ADD     R1, R5, #0x8000
  SUB     R0, R0, R4
  STR     R0, [SP,#0x88+bytesToDec]
  LDR     R0, [R1,#0x28]
  SUB     R6, R6, R4
  SUB     R0, R0, R4
  ADD     R9, R9, R4
  ADD     R11, R11, R4
  STR     R0, [R1,#0x28]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_20262D8                             ; CODE XREF: decode_block+45Cj
  MOV     R1, #4
  STR     R1, [R0]
  B       main_loop
  ; ---------------------------------------------------------------------------

case8:
  ; We need 14 bits in the token
  CMP     R8, #0xE
  BCS     case8_tokenFull

case8_readToken:
  ; Read 14 bits in the token
  CMP     R6, #0
  BEQ     ranOutData_
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, #0xE
  BCC     case8_readToken

case8_tokenFull:
  ; Get 5 bits from the token
  AND     R0, R7, #0x1F

  ; Add 0x101 and store
  ADD     R0, R0, #1
  ADD     R1, R0, #0x100
  ADD     R0, R5, #0x8000
  STR     R1, [R0,#0x48]

  ; Update token to R2
  MOV     R2, R7,LSR#5

  ; Get 5 bits from token
  AND     R1, R2, #0x1F
  MOV     R2, R2,LSR#5

  ; Add 1 and store
  ADD     R1, R1, #1
  STR     R1, [R0,#0x4C]

  ; Get 4 bits from token and update our global token
  AND     R1, R2, #0xF
  MOV     R7, R2,LSR#4
  SUB     R8, R8, #0xE

  ; Add 4 and store
  ADD     R1, R1, #4
  STR     R1, [R0,#0x44]

  ; Get the first value and if > 0x11E && second value > 0x1E go to state 20
  LDR     R2, [R0,#0x48]
  LDR     R1, =0x11E
  CMP     R2, R1
  LDRLS   R1, [R0,#0x4C]
  CMPLS   R1, #0x1E
  BLS     loc_2026370

  ; Go to state 20
  ADD     R0, R5, #0x8000
  MOV     R1, #20
  STR     R1, [R0]
  B       main_loop

  loc_2026370
  MOV     R1, #0
  STR     R1, [R0,#0x50]

  ; Direct jump to state 9
  MOV     R1, #9
  STR     R1, [R0]

case9:
  ADD     R0, R5, #0x50
  ADD     R2, R0, #0x8000       ; 0x8068
  ADD     R3, R5, #0x8000       ; 0x8018
  LDR     R1, =0x2086BF0
  B       loc_20263E8

  loc_2026394
  ; We need 3 bits
  CMP     R8, #3
  BCS     loc_20263BC

case9_readToken:
  ; Read 3 bits
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R4, [R9],#1
  ADD     R7, R7, R4,LSL R8
  ADD     R8, R8, #8
  CMP     R8, #3
  BCC     case9_readToken

  loc_20263BC                             ; CODE XREF: decode_block+578j
  MOV     R0, R0,LSL#1
  LDRH    R4, [R1,R0]
  LDR     R10, [R2]
  AND     R0, R7, #7
  ADD     R10, R10, #1
  STR     R10, [R2]
  ADD     R4, R5, R4,LSL#1
  ADD     R4, R4, #0xA000
  STRH    R0, [R4,#0x58]
  MOV     R7, R7,LSR#3
  SUB     R8, R8, #3

  loc_20263E8                             ; CODE XREF: decode_block+570j
  LDR     R0, [R3,#0x50]
  LDR     R4, [R3,#0x44]
  CMP     R0, R4
  BCC     loc_2026394
  CMP     R0, #0x13
  BCS     loc_2026440
  ADD     R1, R5, #0x50
  ADD     R10, R1, #0x8000
  LDR     R2, =(dword_20869D0+0x220)
  ADD     R1, R5, #0x8000
  MOV     R3, #0

  loc_2026414                             ; CODE XREF: decode_block+61Cj
  LDR     R4, [R10]
  MOV     R0, R0,LSL#1
  ADD     R4, R4, #1
  STR     R4, [R10]
  LDRH    R0, [R2,R0]
  ADD     R0, R5, R0,LSL#1
  ADD     R0, R0, #0xA000
  STRH    R3, [R0,#0x58]
  LDR     R0, [R1,#0x50]
  CMP     R0, #0x13
  BCC     loc_2026414

  loc_2026440                             ; CODE XREF: decode_block+5DCj
  ADD     R1, R5, #0x58
  ADD     R2, R1, #0x8000
  ADD     R0, R5, #0x8000
  STR     R2, [R0,#0x54]
  STR     R2, [R0,#0x34]
  ADD     R2, R5, #0x3C
  MOV     R3, #7
  STR     R3, [R0,#0x3C]
  ADD     R2, R2, #0x8000
  ADD     R0, R5, #0x2D8
  STR     R2, [SP,#0x88+var_88]
  ADD     R2, R5, #0x54
  ADD     R0, R0, #0xA000
  STR     R0, [SP,#0x88+var_84]
  ADD     R3, R2, #0x8000
  ADD     R1, R1, #0xA000
  MOV     R0, #0
  MOV     R2, #0x13
  BL      sub_2027570
  CMP     R0, #0
  STR     R0, [SP,#0x88+isFinished]
  ADD     R0, R5, #0x8000
  MOVNE   R1, #0x14
  STRNE   R1, [R0]
  BNE     main_loop
  MOV     R1, #0
  STR     R1, [R0,#0x50]
  MOV     R1, #0xA
  STR     R1, [R0]

  loc_20264B4                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EC0j
  ADD     R10, R5, #0x8000                ; jumptable 02025E90 case 10
  LDR     R1, [R10,#0x48]
  LDR     R2, [R10,#0x50]
  LDR     R0, [R10,#0x4C]
  ADD     R0, R1, R0
  CMP     R2, R0
  BCS     loc_2026714
  ADD     R0, R5, #0x50
  ADD     R4, R0, #0x8000

  loc_20264D8                             ; CODE XREF: decode_block+700j
                                          ; decode_block+8F0j
  LDR     R3, [R10,#0x3C]
  MOV     R2, #1
  MOV     R2, R2,LSL R3
  SUB     R2, R2, #1
  LDR     R1, [R10,#0x34]
  AND     R2, R7, R2
  ADD     R0, SP, #0x88+var_28
  ADD     R1, R1, R2,LSL#2
  BL      sub_2027BE8
  LDRB    R1, [SP,#0x88+var_27]
  CMP     R8, R1
  BCS     loc_2026524
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  B       loc_20264D8
  ; ---------------------------------------------------------------------------

  loc_2026524                             ; CODE XREF: decode_block+6E4j
  LDRH    R0, [SP,#0x88+var_26]
  CMP     R0, #0x10
  BCS     loc_2026584
  CMP     R8, R1
  BCS     loc_2026558

  loc_2026538                             ; CODE XREF: decode_block+734j
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R1
  BCC     loc_2026538

  loc_2026558                             ; CODE XREF: decode_block+714j
  MOV     R7, R7,LSR R1
  SUB     R8, R8, R1
  LDR     R0, [R10,#0x50]
  LDR     R1, [R4]
  ADD     R0, R5, R0,LSL#1
  ADD     R1, R1, #1
  STR     R1, [R4]
  ADD     R0, R0, #0xA000
  LDRH    R1, [SP,#0x88+var_26]
  STRH    R1, [R0,#0x58]
  B       loc_20266FC
  ; ---------------------------------------------------------------------------

  loc_2026584                             ; CODE XREF: decode_block+70Cj
  BNE     loc_20265F8
  ADD     R2, R1, #2
  CMP     R8, R2
  BCS     loc_20265B4

  loc_2026594                             ; CODE XREF: decode_block+790j
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R2
  BCC     loc_2026594

  loc_20265B4                             ; CODE XREF: decode_block+770j
  MOV     R7, R7,LSR R1
  SUB     R8, R8, R1
  LDR     R0, [R10,#0x50]
  CMP     R0, #0
  BNE     loc_20265D8
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       loc_2026714
  ; ---------------------------------------------------------------------------

  loc_20265D8                             ; CODE XREF: decode_block+7A4j
  ADD     R0, R5, R0,LSL#1
  ADD     R0, R0, #0xA000
  LDRH    R2, [R0,#0x56]
  AND     R0, R7, #3
  ADD     R3, R0, #3
  MOV     R7, R7,LSR#2
  SUB     R8, R8, #2
  B       loc_2026694
  ; ---------------------------------------------------------------------------

  loc_20265F8                             ; CODE XREF: decode_block:loc_2026584j
  CMP     R0, #0x11
  BNE     loc_202664C
  ADD     R2, R1, #3
  CMP     R8, R2
  BCS     loc_202662C

  loc_202660C                             ; CODE XREF: decode_block+808j
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R2
  BCC     loc_202660C

  loc_202662C                             ; CODE XREF: decode_block+7E8j
  MOV     R0, R7,LSR R1
  SUB     R1, R8, R1
  SUB     R8, R1, #3
  AND     R1, R0, #7
  MOV     R2, #0
  ADD     R3, R1, #3
  MOV     R7, R0,LSR#3
  B       loc_2026694
  ; ---------------------------------------------------------------------------

  loc_202664C                             ; CODE XREF: decode_block+7DCj
  ADD     R2, R1, #7
  CMP     R8, R2
  BCS     loc_2026678

  loc_2026658                             ; CODE XREF: decode_block+854j
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R2
  BCC     loc_2026658

  loc_2026678                             ; CODE XREF: decode_block+834j
  MOV     R0, R7,LSR R1
  SUB     R1, R8, R1
  SUB     R8, R1, #7
  AND     R1, R0, #0x7F
  MOV     R2, #0
  ADD     R3, R1, #0xB
  MOV     R7, R0,LSR#7

  loc_2026694                             ; CODE XREF: decode_block+7D4j
                                          ; decode_block+828j
  LDR     R0, [R10,#0x50]
  LDR     R12, [R10,#0x48]
  ADD     R1, R0, R3
  LDR     R0, [R10,#0x4C]
  ADD     R0, R12, R0
  CMP     R1, R0
  BLS     loc_20266C0
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       loc_2026714
  ; ---------------------------------------------------------------------------

  loc_20266C0                             ; CODE XREF: decode_block+88Cj
  CMP     R3, #0
  SUB     R3, R3, #1
  BEQ     loc_20266FC
  MOV     R0, R2,LSL#16
  MOV     R1, R0,LSR#16

  loc_20266D4                             ; CODE XREF: decode_block+8D8j
  LDR     R0, [R10,#0x50]
  LDR     R2, [R4]
  ADD     R0, R5, R0,LSL#1
  ADD     R2, R2, #1
  CMP     R3, #0
  STR     R2, [R4]
  ADD     R0, R0, #0xA000
  STRH    R1, [R0,#0x58]
  SUB     R3, R3, #1
  BNE     loc_20266D4

  loc_20266FC                             ; CODE XREF: decode_block+760j
                                          ; decode_block+8A8j
  LDR     R2, [R10,#0x50]
  LDR     R1, [R10,#0x48]
  LDR     R0, [R10,#0x4C]
  ADD     R0, R1, R0
  CMP     R2, R0
  BCC     loc_20264D8

  loc_2026714                             ; CODE XREF: decode_block+6ACj
                                          ; decode_block+7B4j ...
  ADD     R2, R5, #0x8000
  LDR     R0, [R2]
  CMP     R0, #0x14
  BEQ     main_loop
  ADD     R0, R5, #0x58
  ADD     R3, R0, #0x8000
  STR     R3, [R2,#0x54]
  ADD     R1, R0, #0xA000
  STR     R3, [R2,#0x34]
  ADD     R0, R5, #0x3C
  MOV     R3, #9
  ADD     R0, R0, #0x8000
  STR     R3, [R2,#0x3C]
  STR     R0, [SP,#0x88+var_88]
  ADD     R0, R5, #0x2D8
  ADD     R0, R0, #0xA000
  STR     R0, [SP,#0x88+var_84]
  ADD     R0, R5, #0x54
  ADD     R3, R0, #0x8000
  LDR     R2, [R2,#0x48]
  MOV     R0, #1
  BL      sub_2027570
  STR     R0, [SP,#0x88+isFinished]
  CMP     R0, #0
  BEQ     loc_2026788
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_2026788                             ; CODE XREF: decode_block+954j
  ADD     R1, R5, #0x8000
  LDR     R2, [R1,#0x54]
  ADD     R0, R5, #0x40
  STR     R2, [R1,#0x38]
  MOV     R2, #6
  STR     R2, [R1,#0x40]
  ADD     R2, R0, #0x8000
  ADD     R0, R5, #0x2D8
  STR     R2, [SP,#0x88+var_88]
  ADD     R0, R0, #0xA000
  STR     R0, [SP,#0x88+var_84]
  ADD     R0, R5, #0x58
  ADD     R2, R5, #0x54
  ADD     R4, R0, #0xA000
  ADD     R3, R2, #0x8000
  LDR     R10, [R1,#0x48]
  LDR     R2, [R1,#0x4C]
  MOV     R0, #2
  ADD     R1, R4, R10,LSL#1
  BL      sub_2027570
  CMP     R0, #0
  STR     R0, [SP,#0x88+isFinished]
  ADD     R0, R5, #0x8000
  MOVNE   R1, #0x14
  STRNE   R1, [R0]
  BNE     main_loop
  MOV     R1, #0xB
  STR     R1, [R0]

  loc_20267F8                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EC4j
  CMP     R6, #6                          ; jumptable 02025E90 case 11
  LDRCS   R1, =0x102
  LDRCS   R0, [SP,#0x88+bytesToDec]
  CMPCS   R0, R1
  BCC     loc_2026D2C
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R2, [SP,#0x88+bytesToDec]
  STR     R11, [R0,#0xC]
  STR     R2, [R0,#0x10]
  STR     R9, [R0]
  ADD     R2, R5, #0x8000
  STR     R6, [R0,#4]
  STR     R7, [R2,#0x20]
  STR     R8, [R2,#0x24]
  LDR     R2, [SP,#0x88+structPtr]
  ADD     R5, R0, #0x18
  LDR     R7, [R2,#4]
  LDR     R4, [R2,#0xC]
  LDR     R8, [R2]
  LDR     R6, [R2,#0x10]
  SUB     R2, R8, #1
  RSB     R3, R1, #1
  ADD     R0, R5, #0x8000
  SUB     R7, R7, #5
  STR     R2, [SP,#0x88+var_5C]
  ADD     R2, R2, R7
  STR     R2, [SP,#0x88+var_60]
  LDR     R2, [SP,#0x88+bytesToDec2]
  SUB     R4, R4, #1
  SUB     R2, R2, R6
  ADD     R3, R6, R3
  SUB     R2, R4, R2
  STR     R2, [SP,#0x88+var_64]
  ADD     R2, R4, R3
  STR     R2, [SP,#0x88+var_68]
  LDR     R2, [R0,#0x18]
  LDR     R1, [R0,#0x3C]
  STR     R2, [SP,#0x88+var_6C]
  LDR     R2, [R0,#0x1C]
  LDR     R6, [R0,#0x20]
  STR     R2, [SP,#0x88+var_70]
  MOV     R2, #1
  LDR     R8, [R0,#0x24]
  LDR     R10, [R0,#0x34]
  LDR     R7, [R0,#0x38]
  LDR     R0, [R0,#0x40]
  MOV     R3, R2,LSL R1
  MOV     R1, R2,LSL R0
  SUB     R0, R3, #1
  STR     R0, [SP,#0x88+var_74]
  SUB     R0, R1, #1
  STR     R0, [SP,#0x88+var_78]
  SUB     R0, R5, #1
  STR     R0, [SP,#0x88+var_48]
  LDR     R0, [SP,#0x88+var_70]
  ADD     R11, SP, #0x88+var_38
  ADD     R0, R0, #0x8000
  STR     R0, [SP,#0x88+var_44]

  loc_20268E0                             ; CODE XREF: decode_block+E50j
  CMP     R8, #0xF
  BCS     loc_2026908
  LDR     R0, [SP,#0x88+var_5C]
  LDRB    R2, [R0,#1]
  LDRB    R1, [R0,#2]!
  STR     R0, [SP,#0x88+var_5C]
  ADD     R2, R6, R2,LSL R8
  ADD     R0, R8, #8
  ADD     R6, R2, R1,LSL R0
  ADD     R8, R8, #0x10

  loc_2026908                             ; CODE XREF: decode_block+AC4j
  LDR     R1, [SP,#0x88+var_74]
  MOV     R0, R11
  AND     R1, R6, R1
  ADD     R1, R10, R1,LSL#2
  BL      sub_2027BE8

  loc_202691C                             ; CODE XREF: decode_block+E1Cj
  LDRB    R0, [SP,#0x88+var_37]
  LDRB    R1, [SP,#0x88+var_38]
  MOV     R6, R6,LSR R0
  SUB     R8, R8, R0
  CMP     R1, #0
  LDREQH  R0, [SP,#0x88+unByteDec]
  STREQB  R0, [R4,#1]!
  BEQ     loc_2026C5C
  TST     R1, #0x10
  BEQ     loc_2026C10
  ANDS    R0, R1, #0xF
  LDRH    R9, [SP,#0x88+unByteDec]
  BEQ     loc_2026988
  CMP     R8, R0
  BCS     loc_202696C
  LDR     R1, [SP,#0x88+var_5C]
  LDRB    R2, [R1,#1]!
  STR     R1, [SP,#0x88+var_5C]
  ADD     R6, R6, R2,LSL R8
  ADD     R8, R8, #8

  loc_202696C                             ; CODE XREF: decode_block+B34j
  MOV     R1, #1
  MOV     R1, R1,LSL R0
  SUB     R1, R1, #1
  AND     R1, R6, R1
  MOV     R6, R6,LSR R0
  ADD     R9, R9, R1
  SUB     R8, R8, R0

  loc_2026988                             ; CODE XREF: decode_block+B2Cj
  CMP     R8, #0xF
  BCS     loc_20269B0
  LDR     R0, [SP,#0x88+var_5C]
  LDRB    R2, [R0,#1]
  LDRB    R1, [R0,#2]!
  STR     R0, [SP,#0x88+var_5C]
  ADD     R2, R6, R2,LSL R8
  ADD     R0, R8, #8
  ADD     R6, R2, R1,LSL R0
  ADD     R8, R8, #0x10

  loc_20269B0                             ; CODE XREF: decode_block+B6Cj
  LDR     R1, [SP,#0x88+var_78]
  MOV     R0, R11
  AND     R1, R6, R1
  ADD     R1, R7, R1,LSL#2
  BL      sub_2027BE8

  loc_20269C4                             ; CODE XREF: decode_block+DDCj
  LDRB    R0, [SP,#0x88+var_37]
  LDRB    R1, [SP,#0x88+var_38]
  MOV     R6, R6,LSR R0
  SUB     R8, R8, R0
  TST     R1, #0x10
  BEQ     loc_2026BD0
  AND     R1, R1, #0xF
  CMP     R8, R1
  LDRH    R0, [SP,#0x88+unByteDec]
  BCS     loc_2026A18
  LDR     R2, [SP,#0x88+var_5C]
  LDRB    R3, [R2,#1]!
  STR     R2, [SP,#0x88+var_5C]
  ADD     R6, R6, R3,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R1
  BCS     loc_2026A18
  LDRB    R3, [R2,#1]!
  STR     R2, [SP,#0x88+var_5C]
  ADD     R6, R6, R3,LSL R8
  ADD     R8, R8, #8

  loc_2026A18                             ; CODE XREF: decode_block+BC8j
                                          ; decode_block+BE4j
  MOV     R2, #1
  MOV     R2, R2,LSL R1
  SUB     R2, R2, #1
  AND     R2, R6, R2
  MOV     R6, R6,LSR R1
  SUB     R8, R8, R1
  LDR     R1, [SP,#0x88+var_64]
  ADD     R0, R0, R2
  SUB     R1, R4, R1
  CMP     R0, R1
  BLS     loc_2026B88
  SUB     R2, R0, R1
  LDR     R1, [SP,#0x88+var_6C]
  CMP     R2, R1
  BLS     loc_2026A64
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       loc_2026C74
  ; ---------------------------------------------------------------------------

  loc_2026A64                             ; CODE XREF: decode_block+C30j
  LDR     R1, [SP,#0x88+var_70]
  CMP     R1, #0
  BNE     loc_2026AA0
  LDR     R1, [SP,#0x88+var_48]
  RSB     R3, R2, #0x8000
  CMP     R2, R9
  ADD     R1, R1, R3
  BCS     loc_2026B3C
  SUB     R9, R9, R2

  loc_2026A88                             ; CODE XREF: decode_block+C74j
  LDRB    R3, [R1,#1]!
  SUBS    R2, R2, #1
  STRB    R3, [R4,#1]!
  BNE     loc_2026A88
  SUB     R1, R4, R0
  B       loc_2026B3C
  ; ---------------------------------------------------------------------------

  loc_2026AA0                             ; CODE XREF: decode_block+C4Cj
  CMP     R1, R2
  BCS     loc_2026B10
  LDR     R1, [SP,#0x88+var_44]
  SUB     R3, R1, R2
  LDR     R1, [SP,#0x88+var_48]
  ADD     R1, R1, R3
  LDR     R3, [SP,#0x88+var_70]
  SUB     R2, R2, R3
  CMP     R2, R9
  BCS     loc_2026B3C
  SUB     R9, R9, R2

  loc_2026ACC                             ; CODE XREF: decode_block+CB8j
  LDRB    R3, [R1,#1]!
  SUBS    R2, R2, #1
  STRB    R3, [R4,#1]!
  BNE     loc_2026ACC
  LDR     R1, [SP,#0x88+var_70]
  CMP     R1, R9
  LDR     R1, [SP,#0x88+var_48]
  BCS     loc_2026B3C
  LDR     R2, [SP,#0x88+var_70]
  MOV     R3, R2
  SUB     R9, R9, R3

  loc_2026AF8                             ; CODE XREF: decode_block+CE4j
  LDRB    R3, [R1,#1]!
  SUBS    R2, R2, #1
  STRB    R3, [R4,#1]!
  BNE     loc_2026AF8
  SUB     R1, R4, R0
  B       loc_2026B3C
  ; ---------------------------------------------------------------------------

  loc_2026B10                             ; CODE XREF: decode_block+C84j
  SUB     R3, R1, R2
  LDR     R1, [SP,#0x88+var_48]
  CMP     R2, R9
  ADD     R1, R1, R3
  BCS     loc_2026B3C
  SUB     R9, R9, R2

  loc_2026B28                             ; CODE XREF: decode_block+D14j
  LDRB    R3, [R1,#1]!
  SUBS    R2, R2, #1
  STRB    R3, [R4,#1]!
  BNE     loc_2026B28
  SUB     R1, R4, R0

  loc_2026B3C                             ; CODE XREF: decode_block+C60j
                                          ; decode_block+C7Cj ...
  CMP     R9, #2
  BLS     loc_2026B68

  loc_2026B44                             ; CODE XREF: decode_block+D44j
  LDRB    R0, [R1,#1]
  SUB     R9, R9, #3
  CMP     R9, #2
  STRB    R0, [R4,#1]
  LDRB    R0, [R1,#2]
  STRB    R0, [R4,#2]
  LDRB    R0, [R1,#3]!
  STRB    R0, [R4,#3]!
  BHI     loc_2026B44

  loc_2026B68                             ; CODE XREF: decode_block+D20j
  CMP     R9, #0
  BEQ     loc_2026C5C
  LDRB    R0, [R1,#1]
  CMP     R9, #1
  STRB    R0, [R4,#1]!
  LDRHIB  R0, [R1,#2]
  STRHIB  R0, [R4,#1]!
  B       loc_2026C5C
  ; ---------------------------------------------------------------------------

  loc_2026B88                             ; CODE XREF: decode_block+C20j
  SUB     R0, R4, R0

  loc_2026B8C                             ; CODE XREF: decode_block+D8Cj
  LDRB    R1, [R0,#1]
  SUB     R9, R9, #3
  CMP     R9, #2
  STRB    R1, [R4,#1]
  LDRB    R1, [R0,#2]
  STRB    R1, [R4,#2]
  LDRB    R1, [R0,#3]!
  STRB    R1, [R4,#3]!
  BHI     loc_2026B8C
  CMP     R9, #0
  BEQ     loc_2026C5C
  LDRB    R1, [R0,#1]
  CMP     R9, #1
  STRB    R1, [R4,#1]!
  LDRHIB  R0, [R0,#2]
  STRHIB  R0, [R4,#1]!
  B       loc_2026C5C
  ; ---------------------------------------------------------------------------

  loc_2026BD0                             ; CODE XREF: decode_block+BB8j
  TST     R1, #0x40
  BNE     loc_2026C00
  MOV     R0, #1
  MOV     R0, R0,LSL R1
  SUB     R0, R0, #1
  AND     R1, R6, R0
  LDRH    R2, [SP,#0x88+unByteDec]
  MOV     R0, R11
  ADD     R1, R2, R1
  ADD     R1, R7, R1,LSL#2
  BL      sub_2027BE8
  B       loc_20269C4
  ; ---------------------------------------------------------------------------

  loc_2026C00                             ; CODE XREF: decode_block+DB4j
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       loc_2026C74
  ; ---------------------------------------------------------------------------

  loc_2026C10                             ; CODE XREF: decode_block+B20j
  TST     R1, #0x40
  BNE     loc_2026C40
  MOV     R0, #1
  MOV     R0, R0,LSL R1
  SUB     R0, R0, #1
  AND     R1, R6, R0
  LDRH    R2, [SP,#0x88+unByteDec]
  MOV     R0, R11
  ADD     R1, R2, R1
  ADD     R1, R10, R1,LSL#2
  BL      sub_2027BE8
  B       loc_202691C
  ; ---------------------------------------------------------------------------

  loc_2026C40                             ; CODE XREF: decode_block+DF4j
  TST     R1, #0x20
  ADD     R0, R5, #0x8000
  MOVNE   R1, #4
  STRNE   R1, [R0]
  MOVEQ   R1, #0x14
  STREQ   R1, [R0]
  B       loc_2026C74
  ; ---------------------------------------------------------------------------

  loc_2026C5C                             ; CODE XREF: decode_block+B18j
                                          ; decode_block+D4Cj ...
  LDR     R1, [SP,#0x88+var_5C]
  LDR     R0, [SP,#0x88+var_60]
  CMP     R1, R0
  LDRCC   R0, [SP,#0x88+var_68]
  CMPCC   R4, R0
  BCC     loc_20268E0

  loc_2026C74                             ; CODE XREF: decode_block+C40j
                                          ; decode_block+DECj ...
  LDR     R0, [SP,#0x88+var_5C]
  MOV     R1, R8,LSR#3
  SUB     R0, R0, R8,LSR#3
  SUB     R8, R8, R1,LSL#3
  MOV     R1, #1
  MOV     R1, R1,LSL R8
  SUB     R1, R1, #1
  AND     R6, R6, R1
  LDR     R1, [SP,#0x88+var_60]
  ADD     R2, R0, #1
  CMP     R0, R1
  LDR     R1, [SP,#0x88+structPtr]
  STR     R2, [R1]
  ADD     R2, R4, #1
  STR     R2, [R1,#0xC]
  LDRCS   R1, [SP,#0x88+var_60]
  SUBCS   R0, R0, R1
  RSBCS   R1, R0, #5
  BCS     loc_2026CCC
  LDR     R1, [SP,#0x88+var_60]
  SUB     R0, R1, R0
  ADD     R1, R0, #5

  loc_2026CCC                             ; CODE XREF: decode_block+E9Cj
  LDR     R0, [SP,#0x88+structPtr]
  STR     R1, [R0,#4]
  LDR     R0, [SP,#0x88+var_68]
  CMP     R4, R0
  LDRCS   R1, =0x101
  SUBCS   R0, R4, R0
  SUBCS   R1, R1, R0
  BCS     loc_2026CF8
  SUB     R0, R0, R4
  ADD     R0, R0, #1
  ADD     R1, R0, #0x100

  loc_2026CF8                             ; CODE XREF: decode_block+EC8j
  LDR     R0, [SP,#0x88+structPtr]
  STR     R1, [R0,#0x10]
  ADD     R1, R5, #0x8000
  STR     R6, [R1,#0x20]
  STR     R8, [R1,#0x24]
  LDR     R11, [R0,#0xC]
  LDR     R0, [R0,#0x10]
  LDR     R7, [R1,#0x20]
  STR     R0, [SP,#0x88+bytesToDec]
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R9, [R0]
  LDR     R6, [R0,#4]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_2026D2C                             ; CODE XREF: decode_block+9E8j
  ADD     R4, R5, #0x8000
  MOV     R10, #1

  loc_2026D34                             ; CODE XREF: decode_block+F58j
  LDR     R2, [R4,#0x3C]
  LDR     R1, [R4,#0x34]
  MOV     R2, R10,LSL R2
  SUB     R2, R2, #1
  AND     R2, R7, R2
  ADD     R0, SP, #0x88+var_28
  ADD     R1, R1, R2,LSL#2
  BL      sub_2027BE8
  LDRB    R0, [SP,#0x88+var_27]
  CMP     R8, R0
  BCS     loc_2026D7C
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  B       loc_2026D34
  ; ---------------------------------------------------------------------------

  loc_2026D7C                             ; CODE XREF: decode_block+F3Cj
  LDRB    R1, [SP,#0x88+var_28]
  CMP     R1, #0
  BEQ     loc_2026E3C
  TST     R1, #0xF0
  BNE     loc_2026E3C
  ADD     R0, SP, #0x88+var_2C
  ADD     R1, SP, #0x88+var_28
  BL      sub_2027BE8
  ADD     R0, R5, #0x8000
  STR     R0, [SP,#0x88+var_40]

  loc_2026DA4                             ; CODE XREF: decode_block+FE8j
  LDRB    R3, [SP,#0x88+var_2B]
  LDRB    R4, [SP,#0x88+var_2C]
  LDR     R1, [SP,#0x88+var_40]
  ADD     R0, SP, #0x88+var_28
  ADD     R10, R3, R4
  MOV     R4, #1
  MOV     R4, R4,LSL R10
  LDR     R2, [R1,#0x34]
  SUB     R4, R4, #1
  LDRH    R1, [SP,#0x88+var_2A]
  AND     R4, R7, R4
  ADD     R1, R1, R4,LSR R3
  ADD     R1, R2, R1,LSL#2
  BL      sub_2027BE8
  LDRB    R0, [SP,#0x88+var_27]
  LDRB    R2, [SP,#0x88+var_2B]
  ADD     R1, R2, R0
  CMP     R8, R1
  BCS     loc_2026E34
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  B       loc_2026DA4
  ; ---------------------------------------------------------------------------
  dword_2026E0C DCD 0x8421085             ; DATA XREF: decode_block+108r
  off_2026E10 DCD dword_209BBDC           ; DATA XREF: decode_block:loc_2026064r
                                          ; decode_block+380r
  off_2026E14 DCD dword_215FF48           ; DATA XREF: decode_block+2E4r
  off_2026E18 DCD dword_215E134           ; DATA XREF: decode_block+2F4r
                                          ; decode_block:loc_20261ACr
  off_2026E1C DCD dword_215E138           ; DATA XREF: decode_block+348r
                                          ; decode_block+390r
  dword_2026E20 DCD 0xFFFF                ; DATA XREF: decode_block:loc_2026238r
  dword_2026E24 DCD 0x11E                 ; DATA XREF: decode_block+528r
  off_2026E28 DCD dword_20869D0+0x220     ; DATA XREF: decode_block+56Cr
                                          ; decode_block+5E8r
  dword_2026E2C DCD 0x102                 ; DATA XREF: decode_block+9DCr
  dword_2026E30 DCD 0x101                 ; DATA XREF: decode_block+EBCr
  ; ---------------------------------------------------------------------------

  loc_2026E34                             ; CODE XREF: decode_block+FCCj
  MOV     R7, R7,LSR R2
  SUB     R8, R8, R2

  loc_2026E3C                             ; CODE XREF: decode_block+F64j
                                          ; decode_block+F6Cj
  LDRH    R1, [SP,#0x88+var_26]
  MOV     R7, R7,LSR R0
  SUB     R8, R8, R0
  ADD     R0, R5, #0x8000
  STR     R1, [R0,#0x28]
  LDRB    R1, [SP,#0x88+var_28]
  CMP     R1, #0
  MOVEQ   R1, #0x10
  STREQ   R1, [R0]
  BEQ     main_loop
  TST     R1, #0x20
  MOVNE   R1, #4
  STRNE   R1, [R0]
  BNE     main_loop
  TST     R1, #0x40
  MOVNE   R1, #0x14
  STRNE   R1, [R0]
  BNE     main_loop
  AND     R1, R1, #0xF
  STR     R1, [R0,#0x30]
  MOV     R1, #0xC
  STR     R1, [R0]

  loc_2026E94                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EC8j
  ADD     R0, R5, #0x8000                 ; jumptable 02025E90 case 12
  LDR     R1, [R0,#0x30]
  CMP     R1, #0
  BEQ     loc_2026EF8
  CMP     R8, R1
  BCS     loc_2026ECC

  loc_2026EAC                             ; CODE XREF: decode_block+10A8j
  CMP     R6, #0
  BEQ     ranOutData_
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R1
  BCC     loc_2026EAC

  loc_2026ECC                             ; CODE XREF: decode_block+1088j
  MOV     R0, #1
  MOV     R1, R0,LSL R1
  ADD     R0, R5, #0x8000
  SUB     R1, R1, #1
  AND     R1, R7, R1
  LDR     R2, [R0,#0x28]
  ADD     R1, R2, R1
  STR     R1, [R0,#0x28]
  LDR     R0, [R0,#0x30]
  MOV     R7, R7,LSR R0
  SUB     R8, R8, R0

  loc_2026EF8                             ; CODE XREF: decode_block+1080j
  ADD     R0, R5, #0x8000
  MOV     R1, #0xD
  STR     R1, [R0]

  loc_2026F04                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025ECCj
  ADD     R4, R5, #0x8000                 ; jumptable 02025E90 case 13
  MOV     R10, #1

  loc_2026F0C                             ; CODE XREF: decode_block+1130j
  LDR     R2, [R4,#0x40]
  LDR     R1, [R4,#0x38]
  MOV     R2, R10,LSL R2
  SUB     R2, R2, #1
  AND     R2, R7, R2
  ADD     R0, SP, #0x88+var_28
  ADD     R1, R1, R2,LSL#2
  BL      sub_2027BE8
  LDRB    R0, [SP,#0x88+var_27]
  CMP     R8, R0
  BCS     loc_2026F54
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  B       loc_2026F0C
  ; ---------------------------------------------------------------------------

  loc_2026F54                             ; CODE XREF: decode_block+1114j
  LDRB    R1, [SP,#0x88+var_28]
  TST     R1, #0xF0
  BNE     loc_2026FE4
  ADD     R0, SP, #0x88+var_2C
  ADD     R1, SP, #0x88+var_28
  BL      sub_2027BE8
  ADD     R0, R5, #0x8000
  STR     R0, [SP,#0x88+var_3C]

  loc_2026F74                             ; CODE XREF: decode_block+11B8j
  LDRB    R3, [SP,#0x88+var_2B]
  LDRB    R4, [SP,#0x88+var_2C]
  LDR     R1, [SP,#0x88+var_3C]
  ADD     R0, SP, #0x88+var_28
  ADD     R10, R3, R4
  MOV     R4, #1
  MOV     R4, R4,LSL R10
  LDR     R2, [R1,#0x38]
  SUB     R4, R4, #1
  LDRH    R1, [SP,#0x88+var_2A]
  AND     R4, R7, R4
  ADD     R1, R1, R4,LSR R3
  ADD     R1, R2, R1,LSL#2
  BL      sub_2027BE8
  LDRB    R0, [SP,#0x88+var_27]
  LDRB    R2, [SP,#0x88+var_2B]
  ADD     R1, R2, R0
  CMP     R8, R1
  BCS     loc_2026FDC
  CMP     R6, #0
  BEQ     ranOutData_
  SUB     R6, R6, #1
  LDRB    R0, [R9],#1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  B       loc_2026F74
  ; ---------------------------------------------------------------------------

  loc_2026FDC                             ; CODE XREF: decode_block+119Cj
  MOV     R7, R7,LSR R2
  SUB     R8, R8, R2

  loc_2026FE4                             ; CODE XREF: decode_block+113Cj
  LDRB    R1, [SP,#0x88+var_28]
  MOV     R7, R7,LSR R0
  TST     R1, #0x40
  SUB     R8, R8, R0
  BEQ     loc_2027008
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_2027008                             ; CODE XREF: decode_block+11D4j
  LDRH    R2, [SP,#0x88+var_26]
  ADD     R0, R5, #0x8000
  MOV     R1, #0xE
  STR     R2, [R0,#0x2C]
  LDRB    R2, [SP,#0x88+var_28]
  AND     R2, R2, #0xF
  STR     R2, [R0,#0x30]
  STR     R1, [R0]

  loc_2027028                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025ED0j
  ADD     R0, R5, #0x8000                 ; jumptable 02025E90 case 14
  LDR     R1, [R0,#0x30]
  CMP     R1, #0
  BEQ     loc_202708C
  CMP     R8, R1
  BCS     loc_2027060

  loc_2027040                             ; CODE XREF: decode_block+123Cj
  CMP     R6, #0
  BEQ     ranOutData_
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, R1
  BCC     loc_2027040

  loc_2027060                             ; CODE XREF: decode_block+121Cj
  MOV     R0, #1
  MOV     R1, R0,LSL R1
  ADD     R0, R5, #0x8000
  SUB     R1, R1, #1
  AND     R1, R7, R1
  LDR     R2, [R0,#0x2C]
  ADD     R1, R2, R1
  STR     R1, [R0,#0x2C]
  LDR     R0, [R0,#0x30]
  MOV     R7, R7,LSR R0
  SUB     R8, R8, R0

  loc_202708C                             ; CODE XREF: decode_block+1214j
  ADD     R2, R5, #0x8000
  LDR     R3, [R2,#0x18]
  LDR     R1, [SP,#0x88+bytesToDec2]
  LDR     R0, [R2,#0x2C]
  ADD     R3, R3, R1
  LDR     R1, [SP,#0x88+bytesToDec]
  SUB     R1, R3, R1
  CMP     R0, R1
  MOVHI   R0, #0x14
  STRHI   R0, [R2]
  BHI     main_loop
  MOV     R0, #0xF
  STR     R0, [R2]

  loc_20270C0                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025ED4j
  LDR     R0, [SP,#0x88+bytesToDec]           ; jumptable 02025E90 case 15
  CMP     R0, #0
  BEQ     ranOutData_
  ADD     R2, R5, #0x8000
  LDR     R1, [SP,#0x88+bytesToDec2]
  LDR     R3, [R2,#0x2C]
  SUB     R0, R1, R0
  CMP     R3, R0
  BLS     loc_2027114
  SUB     R1, R3, R0
  LDR     R0, [R2,#0x1C]
  ADD     R2, R5, #0x8000
  CMP     R1, R0
  SUBHI   R1, R1, R0
  RSBHI   R0, R1, #0x8000
  SUBLS   R0, R0, R1
  LDR     R2, [R2,#0x28]
  ADD     R0, R5, R0
  CMP     R1, R2
  MOVHI   R1, R2
  B       loc_202711C
  ; ---------------------------------------------------------------------------

  loc_2027114                             ; CODE XREF: decode_block+12C0j
  SUB     R0, R11, R3
  LDR     R1, [R2,#0x28]

  loc_202711C                             ; CODE XREF: decode_block+12F0j
  LDR     R2, [SP,#0x88+bytesToDec]
  CMP     R1, R2
  MOVHI   R1, R2
  LDR     R2, [SP,#0x88+bytesToDec]
  SUB     R2, R2, R1
  STR     R2, [SP,#0x88+bytesToDec]
  ADD     R2, R5, #0x8000
  LDR     R3, [R2,#0x28]
  SUB     R3, R3, R1
  STR     R3, [R2,#0x28]

  loc_2027144                             ; CODE XREF: decode_block+1330j
  LDRB    R2, [R0],#1
  SUBS    R1, R1, #1
  STRB    R2, [R11],#1
  BNE     loc_2027144
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#0x28]
  CMP     R1, #0
  MOVEQ   R1, #0xB
  STREQ   R1, [R0]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_202716C                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025ED8j
  LDR     R0, [SP,#0x88+bytesToDec]           ; jumptable 02025E90 case 16
  CMP     R0, #0
  BEQ     ranOutData_
  LDR     R2, [R1,#0x28]
  SUB     R0, R0, #1
  STR     R0, [SP,#0x88+bytesToDec]
  STRB    R2, [R11],#1
  MOV     R0, #0xB
  STR     R0, [R1]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_2027194                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EDCj
  CMP     R8, #0x20 ; ' '                 ; jumptable 02025E90 case 17
  BCS     loc_20271BC

  loc_202719C                             ; CODE XREF: decode_block+1398j
  CMP     R6, #0
  BEQ     ranOutData_
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, #0x20 ; ' '
  BCC     loc_202719C

  loc_20271BC                             ; CODE XREF: decode_block+1378j
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R1, [SP,#0x88+bytesToDec2]
  LDR     R3, [R0,#0x14]
  LDR     R0, [SP,#0x88+bytesToDec]
  SUBS    R2, R1, R0
  LDR     R0, [SP,#0x88+structPtr]
  ADD     R1, R3, R2
  STR     R1, [R0,#0x14]
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#0x14]
  ADD     R1, R1, R2
  STR     R1, [R0,#0x14]
  BEQ     loc_2027234
  LDR     R0, [R0,#0xC]
  CMP     R0, #0
  BEQ     loc_2027214
  LDR     R0, [SP,#0x88+structPtr]
  SUB     R1, R11, R2
  ADD     R0, R0, #0xA000
  LDR     R0, [R0,#0x534]
  BL      sub_2027C20
  B       loc_2027228
  ; ---------------------------------------------------------------------------

  loc_2027214                             ; CODE XREF: decode_block+13D8j
  LDR     R0, [SP,#0x88+structPtr]
  SUB     R1, R11, R2
  ADD     R0, R0, #0xA000
  LDR     R0, [R0,#0x534]
  BL      some_hash

  loc_2027228                             ; CODE XREF: decode_block+13F0j
  LDR     R1, [SP,#0x88+structPtr]
  ADD     R1, R1, #0xA000
  STR     R0, [R1,#0x534]

  loc_2027234                             ; CODE XREF: decode_block+13CCj
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#0xC]
  LDR     R0, [SP,#0x88+bytesToDec]
  CMP     R1, #0
  STR     R0, [SP,#0x88+bytesToDec2]
  MOVNE   R1, R7
  BNE     loc_2027270
  MOV     R1, R7,LSR#24
  MOV     R0, R7,LSR#8
  AND     R1, R1, #0xFF
  AND     R0, R0, #0xFF00
  ADD     R0, R1, R0
  AND     R1, R7, #0xFF00
  ADD     R0, R0, R1,LSL#8
  ADD     R1, R0, R7,LSL#24

  loc_2027270                             ; CODE XREF: decode_block+142Cj
  LDR     R0, [SP,#0x88+structPtr]
  ADD     R0, R0, #0xA000
  LDR     R0, [R0,#0x534]
  CMP     R0, R1
  BEQ     loc_2027294
  ADD     R0, R5, #0x8000
  MOV     R1, #0x14
  STR     R1, [R0]
  B       main_loop
  ; ---------------------------------------------------------------------------

  loc_2027294                             ; CODE XREF: decode_block+1460j
  MOV     R7, #0
  ADD     R0, R5, #0x8000
  MOV     R1, #0x12
  MOV     R8, R7
  STR     R1, [R0]

  loc_20272A8                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EE0j
  ADD     R0, R5, #0x8000                 ; jumptable 02025E90 case 18
  LDR     R0, [R0,#0xC]
  CMP     R0, #0
  BEQ     loc_2027300
  CMP     R8, #0x20 ; ' '
  BCS     loc_20272E0

  loc_20272C0                             ; CODE XREF: decode_block+14BCj
  CMP     R6, #0
  BEQ     ranOutData_
  LDRB    R0, [R9],#1
  SUB     R6, R6, #1
  ADD     R7, R7, R0,LSL R8
  ADD     R8, R8, #8
  CMP     R8, #0x20 ; ' '
  BCC     loc_20272C0

  loc_20272E0                             ; CODE XREF: decode_block+149Cj
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#0x14]
  CMP     R7, R1
  MOVNE   R1, #0x14
  STRNE   R1, [R0]
  BNE     main_loop
  MOV     R7, #0
  MOV     R8, R7

  loc_2027300                             ; CODE XREF: decode_block+1494j
  ADD     R0, R5, #0x8000
  MOV     R1, #0x13
  STR     R1, [R0]

  loc_202730C                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EE4j
  MOV     R0, #1                          ; jumptable 02025E90 case 19
  STR     R0, [SP,#0x88+isFinished]
  B       ranOutData_
  ; ---------------------------------------------------------------------------

  loc_2027318                             ; CODE XREF: decode_block+70j
                                          ; decode_block:loc_2025EE8j
  MOV     R0, 0xFFFFFFFD                  ; jumptable 02025E90 case 20
  STR     R0, [SP,#0x88+isFinished]
  B       ranOutData_
  ; ---------------------------------------------------------------------------

case21_error:
  ADD     SP, SP, #0x64
  MOV     R0, 0xFFFFFFFC
  LDMFD   SP!, {R4-R11,PC}

caseDefault_error:
  ADD     SP, SP, #0x64
  MOV     R0, 0xFFFFFFFE
  LDMFD   SP!, {R4-R11,PC}

  ranOutData_                             ; CODE XREF: decode_block+E0j
                                          ; decode_block+1B4j ...
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R1, [SP,#0x88+bytesToDec]
  STR     R11, [R0,#0xC]
  STR     R1, [R0,#0x10]
  STR     R9, [R0]
  STR     R6, [R0,#4]
  ADD     R1, R5, #0x8000
  STR     R7, [R1,#0x20]
  STR     R8, [R1,#0x24]
  LDR     R2, [R0,#0x10]
  LDR     R0, [SP,#0x88+bytesToDec2]
  SUB     R6, R0, R2
  CMP     R6, #0x8000
  BCC     loc_20273A4
  LDR     R0, [SP,#0x88+structPtr]
  MOV     R2, #0x8000
  LDR     R1, [R0,#0xC]
  MOV     R0, R5
  SUB     R1, R1, #0x8000
  BL      api_mem_copy
  ADD     R0, R5, #0x8000
  MOV     R1, #0
  STR     R1, [R0,#0x1C]
  MOV     R1, #0x8000
  STR     R1, [R0,#0x18]
  B       loc_2027430
  ; ---------------------------------------------------------------------------

  loc_20273A4                             ; CODE XREF: decode_block+1550j
  LDR     R3, [R1,#0x1C]
  LDR     R0, [SP,#0x88+structPtr]
  RSB     R4, R3, #0x8000
  LDR     R1, [R0,#0xC]
  CMP     R4, R6
  MOVHI   R4, R6
  MOV     R2, R4
  ADD     R0, R5, R3
  SUB     R1, R1, R6
  BL      api_mem_copy
  SUBS    R6, R6, R4
  BEQ     loc_2027400
  LDR     R0, [SP,#0x88+structPtr]
  MOV     R2, R6
  LDR     R1, [R0,#0xC]
  MOV     R0, R5
  SUB     R1, R1, R6
  BL      api_mem_copy
  ADD     R0, R5, #0x8000
  STR     R6, [R0,#0x1C]
  MOV     R1, #0x8000
  STR     R1, [R0,#0x18]
  B       loc_2027430
  ; ---------------------------------------------------------------------------

  loc_2027400                             ; CODE XREF: decode_block+15B0j
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#0x1C]
  ADD     R1, R1, R4
  STR     R1, [R0,#0x1C]
  CMP     R1, #0x8000
  MOVEQ   R1, #0
  STREQ   R1, [R0,#0x1C]
  ADD     R0, R5, #0x8000
  LDR     R1, [R0,#0x18]
  CMP     R1, #0x8000
  ADDCC   R1, R1, R4
  STRCC   R1, [R0,#0x18]

  loc_2027430                             ; CODE XREF: decode_block+1580j
                                          ; decode_block+15DCj
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R2, [R0,#4]
  LDR     R1, [R0,#8]
  LDR     R0, [SP,#0x88+inputSize]
  SUB     R0, R0, R2
  STR     R0, [SP,#0x88+inputSize]
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R2, [R0,#0x10]
  LDR     R0, [SP,#0x88+inputSize]
  ADD     R1, R1, R0
  LDR     R0, [SP,#0x88+structPtr]
  STR     R1, [R0,#8]
  LDR     R1, [R0,#0x14]
  LDR     R0, [SP,#0x88+bytesToDec2]
  SUBS    R0, R0, R2
  STR     R0, [SP,#0x88+bytesToDec2]
  ADD     R1, R1, R0
  LDR     R0, [SP,#0x88+structPtr]
  STR     R1, [R0,#0x14]
  ADD     R1, R5, #0x8000
  LDR     R2, [R1,#0x14]
  LDR     R0, [SP,#0x88+bytesToDec2]
  ADD     R0, R2, R0
  STR     R0, [R1,#0x14]
  BEQ     loc_20274F0
  LDR     R0, [R1,#0xC]
  CMP     R0, #0
  BEQ     loc_20274C4
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R2, [SP,#0x88+bytesToDec2]
  ADD     R1, R0, #0xA000
  LDR     R3, [R0,#0xC]
  LDR     R0, [R1,#0x534]
  MOV     R1, R2
  SUB     R1, R3, R1
  BL      sub_2027C20
  B       loc_20274E4
  ; ---------------------------------------------------------------------------

  loc_20274C4                             ; CODE XREF: decode_block+167Cj
  LDR     R0, [SP,#0x88+structPtr]
  LDR     R2, [SP,#0x88+bytesToDec2]
  ADD     R1, R0, #0xA000
  LDR     R3, [R0,#0xC]
  LDR     R0, [R1,#0x534]
  MOV     R1, R2
  SUB     R1, R3, R1
  BL      some_hash

  loc_20274E4                             ; CODE XREF: decode_block+16A0j
  LDR     R1, [SP,#0x88+structPtr]
  ADD     R1, R1, #0xA000
  STR     R0, [R1,#0x534]

  loc_20274F0                             ; CODE XREF: decode_block+1670j
  ADD     R0, R5, #0x8000
  LDR     R0, [R0]
  CMP     R0, #4
  ADD     R0, R5, #0x8000
  MOVEQ   R2, #0x80 ; 'Ç'
  LDR     R0, [R0,#4]
  MOVNE   R2, #0
  CMP     R0, #0
  ADD     R0, R5, #0x8000
  MOVNE   R3, #0x40 ; '@'
  LDR     R1, [R0,#0x24]
  MOVEQ   R3, #0
  LDR     R0, [SP,#0x88+structPtr]
  ADD     R1, R1, R3
  ADD     R0, R0, #0xA000
  ADD     R1, R1, R2
  STR     R1, [R0,#0x530]
  LDR     R0, [SP,#0x88+inputSize]
  CMP     R0, #0
  LDREQ   R0, [SP,#0x88+bytesToDec2]
  CMPEQ   R0, #0
  BEQ     loc_2027554
  LDR     R0, [SP,#0x88+arg1]
  CMP     R0, #4
  BNE     quit

  loc_2027554
  LDR     R0, [SP,#0x88+isFinished]
  CMP     R0, #0
  MOVEQ   R0, 0xFFFFFFFB
  STREQ   R0, [SP,#0x88+isFinished]

quit:
  LDR     R0, [SP,#0x88+isFinished]
  ADD     SP, SP, #0x64
  LDMFD   SP!, {R4-R11,PC}
