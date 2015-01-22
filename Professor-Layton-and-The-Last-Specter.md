**El profesor Layton y la llamada del espectro** es un juego para la *Nintendo DS* (NDS). Fue desarrollado por *Level-5* en el año 2009. Es de género aventura y puzzles siendo la cuarta entrega de la saga para la Nintendo DS. Fue localizado a la mayoría de los idiomas: japonés, inglés y multi-5 (europeos). La versión para Reino Unido incluye el minijuego **London Life**.

# London Life

# La llamada del espectro
Los archivos del juego principal se dividen en tres contenedos:
* lt4_main_sp.fa ¿Archivos generales?
* lt4_seq.fa ¿Contiene las secuencias animadas 3D?
* lt4_sub.fa: ¿Contiene los subtítulos?

## Paquete
Los archivos principales del juego tienen la extensión `.fa` y una cabecera `GFSA`.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Cabecera: `GFSA`, se verifica |
| 0x04   | 0x04   | Puntero a bloque 1 |
| 0x08   | 0x04   | Puntero a bloque 2 |
| 0x0C   | 0x04   | Puntero a bloque 3 |
| 0x10   | 0x04   | Puntero a bloque 4 |
| 0x14   | 0x04   | Puntero a datos (`dataPtr`) |
| 0x18   | 0x04   | Número de carpetas |
| 0x1C   | 0x04   | Número de archivos |
| 0x20   | 0x04   | Tamaño bloque 1 + Tamaño bloque 2 |
| 0x24   | 0x04   | ?? |
| 0x28   | ....   | Bloques codificados |

*Nota:* Todavía no sé para qué, pero calcula un offset: `i*[0x24] + ([0x20]+0x48)`
¿Quizás el espacio a reservar en la RAM? ¿Qué es ese `i`?

### Codificación
La primera palabra es de control con la siguiente información:
* Bits 0-2: Tipo de algoritmo.
  * 0: ¿Quizás "no codificado"?
  * 1: LZSS
  * 2: Huffman 4 bits
  * 3: Huffman 8 bits
  * 4: RLE 8 bits
* Bits 3-31: Tamaño del bloque descomprimido.

A partir de estos datos se puede convertir la cabecera a la utilizada en las
compresiones de la BIOS y poder utilizar los mismos [programas](http://romxhack.esforos.com/compresiones-para-las-consolas-gba-ds-de-nintendo-t117).

### Bloque 1: Folder Info Table
En este bloque se encuentra una lista con información sobre cada una de las carpetas
que el contenedor tiene. Cada entrada son 8 bytes y corresponden a una carpeta.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x02   | Hash del nombre |
| 0x02   | 0x02   | Número de archivos |
| 0x04   | 0x02   | FatOffset[0:15] |
| 0x06   | 0x02   | FatOffset[15:31] |

Para localizar un archivo primero hay que localizar la carpeta para
obtener la posición relativa en el FAT. A la hora de calcular el hash a partir
del nombre, se incluye toda la ruta relativa, es decir las subcarpetas también.

#### Algoritmo hash
``` asm
MEMORY:01FF852C sub_1FF852C
MEMORY:01FF852C CMP     R0, #0
MEMORY:01FF8530 LDR     R3, =0xFFFF
MEMORY:01FF8534 BEQ     loc_1FF8570
MEMORY:01FF8538 ADD     R12, R0, R1
MEMORY:01FF853C CMP     R0, R12
MEMORY:01FF8540 BCS     loc_1FF8570
MEMORY:01FF8544 LDR     R2, =0x20B3F84
MEMORY:01FF8548
MEMORY:01FF8548 loc_1FF8548
MEMORY:01FF8548 LDRB    R1, [R0],#1
MEMORY:01FF854C CMP     R0, R12
MEMORY:01FF8550 EOR     R1, R3, R1
MEMORY:01FF8554 MOV     R1, R1,LSL#24
MEMORY:01FF8558 MOV     R1, R1,LSR#23
MEMORY:01FF855C LDRH    R1, [R2,R1]
MEMORY:01FF8560 EOR     R1, R1, R3,ASR#8
MEMORY:01FF8564 MOV     R1, R1,LSL#16
MEMORY:01FF8568 MOV     R3, R1,LSR#16
MEMORY:01FF856C BCC     loc_1FF8548
MEMORY:01FF8570
MEMORY:01FF8570 loc_1FF8570
MEMORY:01FF8570 MVN     R0, R3
MEMORY:01FF8574 MOV     R0, R0,LSL#16
MEMORY:01FF8578 MOV     R0, R0,LSR#16
MEMORY:01FF857C BX      LR
```

### Bloque 2: File Allocation Table (FAT)
Esta tabla contiene la información necesaria para recuperar un fichero del paquete.
Cada entrada de la lista son 8 bytes y corresponden a un fichero.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x02   | Hash del nombre |
| 0x02   | 0x02   | Offset[0:15] |
| 0x04   | 0x02   | Tamaño[0:15] |
| 0x06   | 0x02   | `0-11: Offset[16:27]`, `12-15: Tamaño[16:18]` |

El puntero al fichero tiene que ser multiplicado por 4 (hay un relleno de 4 bytes)
y es relativo al valor `dataPtr` de la cabecera.

Como se puede ver por las direcciones, este contenedor tiene un **tamaño máximo** de
`2^28 = 268435456 bytes = 256 MB`, siendo el tamaño máximo de sus subarchivos
`2^19 = 524288 bytes = 512 KB`

#### Algoritmo hash
``` asm
MEMORY:01FF8588 sub_1FF8588
MEMORY:01FF8588 CMP     R0, #0
MEMORY:01FF858C LDRNEB  R12, [R0]
MEMORY:01FF8590 LDR     R3, =0xFFFF
MEMORY:01FF8594 CMPNE   R12, #0
MEMORY:01FF8598 BEQ     loc_1FF85C8
MEMORY:01FF859C LDR     R2, =0x20B3F84
MEMORY:01FF85A0
MEMORY:01FF85A0 loc_1FF85A0
MEMORY:01FF85A0 EOR     R1, R3, R12
MEMORY:01FF85A4 MOV     R1, R1,LSL#24
MEMORY:01FF85A8 MOV     R1, R1,LSR#23
MEMORY:01FF85AC LDRH    R1, [R2,R1]
MEMORY:01FF85B0 LDRB    R12, [R0,#1]!
MEMORY:01FF85B4 EOR     R1, R1, R3,ASR#8
MEMORY:01FF85B8 MOV     R1, R1,LSL#16
MEMORY:01FF85BC CMP     R12, #0
MEMORY:01FF85C0 MOV     R3, R1,LSR#16
MEMORY:01FF85C4 BNE     loc_1FF85A0
MEMORY:01FF85C8
MEMORY:01FF85C8 loc_1FF85C8
MEMORY:01FF85C8 MVN     R0, R3
MEMORY:01FF85CC MOV     R0, R0,LSL#16
MEMORY:01FF85D0 MOV     R0, R0,LSR#16
MEMORY:01FF85D4 BX      LR
```

### Bloque 3: Desconocido (¿Nulo?)
Aparte de tener la codificación desconocida '0', parece no ser utilizado y no
tener información relevate.

### Bloque 4: File & Folder Name Table
En este bloque están los nombres de directores y nombres por separado.
Dado que sabiendo el nombre del fichero y en concreto su hash se puede obtener
el número de subarchivos en el FAT y por tanto sus hash. Para obtener las rutas
completas se puede seguir el siguiente procedimiento.

1. Coger los nombres de archivos y crear un diccionario junto con el FAT.
2. Coger los nombres de carpetas y crear un diccionario junto con su FIT.
  1. Por cada subarchivo, ir a por su entrada en el diccionario y añadirle
  el nombre de la carpeta actual.
