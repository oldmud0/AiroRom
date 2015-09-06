**Brave fencer Musashi** es un juego para la *Play Station 1* (PS1 / PSX) desarrollado por *Square Enix* en 1998. Es de género *rol de acción* y solo está disponible en **japonés** e **inglés**. Según *Lord Raptor* ha habido varios intentos de traducción pero todos fracasaron al no poder encontrar los textos.

# Textos
Los textos se encuentran **comprimidos** con una variante de **LZSS** dentro de algunos archivos del juego. A continuación se incluye el código en ensamblador (MIPS R3000) para descomprimirlos:

``` nasm
;; Start
80018730 00803821 mov     r7,r4             ; Set read ptr
80018734 24080800 mov     r8,800h           ; Bytes to decompress
80018738 3C098007 movp    r9,[800747B0h]    ; Current lineal buffer
80018740 3C0B8007 movbp   r11,[800747A0h]   ; Current mask
80018748 3C0D8007 movbp   r13,[800747A4h]   ; Current token ring
80018750 3C0A8007 movp    r10,[800747ACh]   ; Output pointer
80018758 3C03800C movp    r3,[800C7D24h]    ; State / Entry
80018760 3C0C8007 movhp   r12,[800747B4h]   ; Current status / index buffer
80018768 2C620005 setb    r2,r3,5h          ; If (r3 >= 0x5) ...
8001876C 10400068 jz      r2,80018910h      ; ... quit, error
80018770 3C0E1F80 + mov   r14,1F800000h     ; Buffer (2^10=1024 bytes)
80018774 00031080 shl     r2,r3,2h          ; Get entry point pointer
80018778 3C018007 mov     r1,80070000h      ; Get entry point (r1  = 0x80070000)
8001877C 00220821 add     r1,r2             ; ... r1 += r2
80018780 8C222A38 mov     r2,[r1+2A38h]     ; ... r2 = [0x80072A38+r2]
80018784 00000000 nop
80018788 00400008 jmp     r2                ; ... jump to entry point

;; -- Entry 1 -- Initialize token ring ;;
80018790 24090001 mov     r9,1h             ; r9  = 0x01
80018794 240B0001 mov     r11,1h            ; Initialize mask (r11 = 0x01)
80018798 90ED0000 movb    r13,[r7]          ; Get token ring (r13 = [r7])
8001879C 24E70001 add     r7,1h             ; ... Increase pointer (r7++)
800187A0 2508FFFF sub     r8,1h             ; ... Decrement bytes to decompress

;; -- Entry 2 -- Check token bit ;;
800187A4 016D1024 and     r2,r11,r13        ; If (tonken ring bit is 0) ..
800187A8 1040000A jz      r2,800187D4h      ; .. jump case 2
;; When token ring bit is 1 ;;
800187AC 01C91821 + add   r3,r14,r9         ; r3  = r14 + r9
800187B0 90E40000 movb    r4,[r7]           ; Read byte (r4  = [r7])
800187B4 24E70001 add     r7,1h             ; ... Increase pointer (r7++)
800187B8 25220001 add     r2,r9,1h          ; r2   = r9 + 0x01
800187BC 304903FF and     r9,r2,3FFh        ; r9   = r2 & 0x3FF
800187C0 2508FFFF sub     r8,1h             ; ... Decrement bytes to decompress
800187C4 A0640000 movb    [r3],r4           ; Store in buffer ([r3]  = r4)
800187C8 A1440000 movb    [r10],r4          ; Store in output ([r10] = r4)
800187CC 0800621B jmp     8001886Ch         ; Go to
800187D0 254A0001 + add   r10,1h            ; r10++

;; When token ring bit is 0 ;;
800187D4 90E30000 movb    r3,[r7]           ; Read byte (r3  = [r7])
800187D8 24E70001 add     r7,1h             ; ... Increase pointer (r7++)
800187DC 2508FFFF sub     r8,1h             ; ... Decrement bytes to decompress
800187E0 3182FF00 and     r2,r12,0FF00h     ; Mix data lower part with value
800187E4 15000004 jnz     r8,800187F8h      ; If there is no more bytes... quit
800187E8 00626025 + or    r12,r3,r2         ; ... r12 = (r12 & 0xFF00) | r3
800187EC 24020001 mov     r2,1h             ; r2  = 0x01
800187F0 0800621F jmp     8001887Ch         ; Go to save state and quit
800187F4 24030003 + mov   r3,3h             ; r3  = 0x03

;; -- Entry 3 -- Token ring bit is 0 ;;
800187F8 90E30000 movb    r3,[r7]           ; Read byte (r3  = [r7])
800187FC 24E70001 add     r7,1h             ; ... Increment pointer (r7++)
80018800 2508FFFF sub     r8,1h             ; ... Decrement bytes to decompress
80018804 318200FF and     r2,r12,0FFh       ; Mix high part with value
80018808 00031A00 shl     r3,8h             ; ... shift new value to high part
8001880C 00431025 or      r2,r3             ; ... mix it!
80018810 304603FF and     r6,r2,3FFh        ; ... cut it for 10 bits
80018814 14C00005 jnz     r6,8001882Ch      ; If it's 0 => finished
80018818 00406021 + mov   r12,r2            ; Store it in r12
8001881C 3C01800C mov     r1,800C0000h      ; [0x800C7D24] = 0 (state/entry 0)
80018820 AC207D24 mov     [r1+7D24h],0      ; ...

;; -- Entry 0 -- Finish ;;
80018824 08006244 jmp     80018910h         ; Quit
80018828 00001021 + mov   r2,0              ; r2  = 0 => Finish, done!

;; Token ring bit is 0, process, loop start ;;
8001882C 000C1282 shr     r2,r12,0Ah        ; Get high 6 bits => iterations
80018830 24450002 add     r5,r2,2h          ; r5  = (r12 >> 0xA) + 0x02
80018834 10A0000D jz      r5,8001886Ch      ; Do not write

;; Token ring bit is 0, write, loop body ;;
8001883C 01C62021 add     r4,r14,r6         ; Go to previous value (buffer)
80018840 24C20001 add     r2,r6,1h          ; Increase buffer index
80018844 304603FF and     r6,r2,3FFh        ; ... max 10 bits, remember
80018848 01C91821 add     r3,r14,r9         ; Get lineal buffer address
8001884C 25220001 add     r2,r9,1h          ; Increase lineal buffer index
80018850 304903FF and     r9,r2,3FFh        ; ... max 10 bits, remember
80018854 90820000 movb    r2,[r4]           ; Read previous value (r2  = [r4])
80018858 24A5FFFF sub     r5,1h             ; Decrease loop iteration
8001885C A0620000 movb    [r3],r2           ; Set it in lineal buffer
80018860 A1420000 movb    [r10],r2          ; Write in output
80018864 14A0FFF5 jnz     r5,8001883Ch      ; Loop condition
80018868 254A0001 + add   r10,1h            ; Increase output pointer

8001886C 15000012 jnz     r8,800188B8h      ; Check for next token bit if not end
80018870 316300FF + and   r3,r11,0FFh       ; Get next token bit
80018874 24020001 mov     r2,1h             ; Return unfinished
80018878 24030004 mov     r3,4h             ; Set status / entry next token bit

;; Save state and quit ;;
8001887C 3C01800C mov     r1,800C0000h      ; Save status [0x800C7D24]
80018880 AC237D24 mov     [r1+7D24h],r3     ; ...
80018884 3C018007 mov     r1,80070000h      ; Save lineal buffer [0x800747B0]
80018888 AC2947B0 mov     [r1+47B0h],r9     ; ...
8001888C 3C018007 mov     r1,80070000h      ; Save mask [0x800747A0]
80018890 A02B47A0 movb    [r1+47A0h],r11    ; ...
80018894 3C018007 mov     r1,80070000h      ; Save token ring [0x800747A4]
80018898 A02D47A4 movb    [r1+47A4h],r13    ; ...
8001889C 3C018007 mov     r1,80070000h      ; Save output pointer [0x800747AC]
800188A0 AC2A47AC mov     [r1+47ACh],r10    ; ...
800188A4 3C018007 mov     r1,80070000h      ; Save buffer status [0x800747B4]
800188A8 A42C47B4 movh    [r1+47B4h],r12    ; ...
800188AC 08006244 jmp     80018910h         ; Quit

;; -- Entry 4 -- Next token bit ;;
800188B4 316300FF and     r3,r11,0FFh       ; Get mask

800188B8 24020080 mov     r2,80h            ; Check if mask end
800188BC 1462FFB9 jne     r3,r2,800187A4h   ; If not, go next token
800188C0 000B5840 + shl   r11,1h            ; Increase mask (r11 <<= 1)
800188C4 240B0001 mov     r11,1h            ; Initialize mask (r11 = 0x01)
800188C8 90ED0000 movb    r13,[r7]          ; Get new token ring ([r7] = r13)
800188CC 2508FFFF sub     r8,1h             ; ... Decrement bytes to decompress
800188D0 1500FFB4 jnz     r8,800187A4h      ; If there is no more bytes... quit
800188D4 24E70001 + add   r7,1h             ; ... Increment pointer
;; Save state ;;
800188D8 24020001 mov     r2,1h             ; Set unfinished
800188DC 24030002 mov     r3,2h             ; Set entry / status 2
800188E0 3C01800C mov     r1,800C0000h      ; Save status [0x800C7D24]
800188E4 AC237D24 mov     [r1+7D24h],r3     ; ...
800188E8 3C018007 mov     r1,80070000h      ; Save lineal buffer [0x800747B0]
800188EC AC2947B0 mov     [r1+47B0h],r9     ; ...
800188F0 3C018007 mov     r1,80070000h      ; Save mask [0x800747A0]
800188F4 A02B47A0 movb    [r1+47A0h],r11    ; ...
800188F8 3C018007 mov     r1,80070000h      ; Save token ring [0x800747A4]
800188FC A02D47A4 movb    [r1+47A4h],r13    ; ...
80018900 3C018007 mov     r1,80070000h      ; Save output pointer [0x800747AC]
80018904 AC2A47AC mov     [r1+47ACh],r10    ; ...
80018908 3C018007 mov     r1,80070000h      ; Save buffer status [0x800747B4]
8001890C A42C47B4 movh    [r1+47B4h],r12    ; ...

;; Quit ;;
80018910 03E00008 ret                       ; Return


;; Entry point table
;; 80072A30 00 00 00 00 FF FF FF FF 24 88 01 80 90 87 01 80  ........$.......
;; 80072A40 A4 87 01 80 F8 87 01 80 B4 88 01 80
;;
;; 0 -> 80018824
;; 1 -> 80018790
;; 2 -> 800187A4
;; 3 -> 800187F8
;; 4 -> 800188B4
``` 