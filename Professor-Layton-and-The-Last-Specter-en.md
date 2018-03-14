***Professor Layton and the Last Specter*** is a game for the Nintendo DS (NDS). It was developed
by Level-5 in 2009. It is an adventure and puzzle game, being the fourth installment of the saga
for the Nintendo DS. It was localized to [the most common] languages: Japanese, English, and
Multi-5 (European). The UK version includes the **London Life** minigame.

# London Life
More information about this minigame can be found on the [London Life](London-Life) page.

# The Last Specter
The main game is divided into three archives:

Filename       | Description
---------------|-----------------
lt4_main_sp.fa | General archives
lt4_seq.fa     | 3D animations
lt4_sub.fa     | Subtitles

## Package
The archives have the `.fa` extension and the `GFSA` header.

| Offset | Size   | Description |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | `GFSA` header; verified by game |
| 0x04   | 0x04   | Block 1 pointer |
| 0x08   | 0x04   | Block 2 pointer |
| 0x0C   | 0x04   | Block 3 pointer |
| 0x10   | 0x04   | Block 4 pointer |
| 0x14   | 0x04   | Pointer to data (`dataPtr`) |
| 0x18   | 0x04   | Number of folders |
| 0x1C   | 0x04   | Number of files |
| 0x20   | 0x04   | Size of block 1 + size of block 2 |
| 0x24   | 0x04   | ?? |
| 0x28   | ....   | Encoded blocks |

*Note:* I still do not know why, but it calculates an offset: `i*[0x24] + ([0x20]+0x48)`
Perhaps it is the space to be reserved in RAM? What is that `i`?

### Encoding
The first word is for configuration, with the following information:
* Bits 0-2: Encoding method
  * 0: No encoding?
  * 1: LZSS
  * 2: Huffman 4 bits
  * 3: Huffman 8 bits
  * 4: RLE 8 bits
* Bits 3-31: Size of decompressed block

From this data, the header can be converted to one that is used in BIOS
compression, and thus the same
[programs](http://romxhack.esforos.com/compresiones-para-las-consolas-gba-ds-de-nintendo-t117)
can be used to decompress these blocks.


### Block 1: Folder Info Table
In this block, the information about each folder contained in an archive can be found.
Each entry is 8 bytes long and corresponds to one folder.

| Offset | Size   | Description |
| ------ | ------ | ----------- |
| 0x00   | 0x02   | Hash of name |
| 0x02   | 0x02   | Number of files |
| 0x04   | 0x02   | FatOffset[0:15] |
| 0x06   | 0x02   | FatOffset[15:31] |

To locate a file, the folder must first be located by obtaining the relative position
in the FAT. In the name hash calculation, the entire (relative) path must be included.

#### Hash algorithm
[Located in memory]

``` asm
01FF852C sub_1FF852C
01FF852C CMP     R0, #0
01FF8530 LDR     R3, =0xFFFF
01FF8534 BEQ     loc_1FF8570
01FF8538 ADD     R12, R0, R1
01FF853C CMP     R0, R12
01FF8540 BCS     loc_1FF8570
01FF8544 LDR     R2, =0x20B3F84
01FF8548
01FF8548 loc_1FF8548
01FF8548 LDRB    R1, [R0],#1
01FF854C CMP     R0, R12
01FF8550 EOR     R1, R3, R1
01FF8554 MOV     R1, R1,LSL#24
01FF8558 MOV     R1, R1,LSR#23
01FF855C LDRH    R1, [R2,R1]
01FF8560 EOR     R1, R1, R3,ASR#8
01FF8564 MOV     R1, R1,LSL#16
01FF8568 MOV     R3, R1,LSR#16
01FF856C BCC     loc_1FF8548
01FF8570
01FF8570 loc_1FF8570
01FF8570 MVN     R0, R3
01FF8574 MOV     R0, R0,LSL#16
01FF8578 MOV     R0, R0,LSR#16
01FF857C BX      LR
```

### Block 2: File Allocation Table (FAT)
This table contains the information necessary to recover one file in the archive.
Each entry in the list contains 8 bytes and corresponds to one file.

| Offset | Size   | Description |
| ------ | ------ | ----------- |
| 0x00   | 0x02   | Hash of name |
| 0x02   | 0x02   | Offset[0:15] |
| 0x04   | 0x02   | Size[0:15] |
| 0x06   | 0x02   | `0-11: Offset[16:27]`, `12-15: Size[16:18]` |

The file pointer must be multiplied by 4 (there is a 4-byte padding) and is relative
to `dataPtr` found in the header.

As can be seen by the specification, this container has a **maximum size** of
`2^28 = 268435456 bytes = 256 MB`, being the maximum size of its files
`2^19 = 524288 bytes = 512 KB`.

#### Hash algorithm
``` asm
01FF8588 sub_1FF8588
01FF8588 CMP     R0, #0
01FF858C LDRNEB  R12, [R0]
01FF8590 LDR     R3, =0xFFFF
01FF8594 CMPNE   R12, #0
01FF8598 BEQ     loc_1FF85C8
01FF859C LDR     R2, =0x20B3F84
01FF85A0
01FF85A0 loc_1FF85A0
01FF85A0 EOR     R1, R3, R12
01FF85A4 MOV     R1, R1,LSL#24
01FF85A8 MOV     R1, R1,LSR#23
01FF85AC LDRH    R1, [R2,R1]
01FF85B0 LDRB    R12, [R0,#1]!
01FF85B4 EOR     R1, R1, R3,ASR#8
01FF85B8 MOV     R1, R1,LSL#16
01FF85BC CMP     R12, #0
01FF85C0 MOV     R3, R1,LSR#16
01FF85C4 BNE     loc_1FF85A0
01FF85C8
01FF85C8 loc_1FF85C8
01FF85C8 MVN     R0, R3
01FF85CC MOV     R0, R0,LSL#16
01FF85D0 MOV     R0, R0,LSR#16
01FF85D4 BX      LR
```

### Block 3: Unknown (Null?)
Apart from having an unknown '0' encoding, it does not appear that it is used
and does not contain any relevant information.

### Block 4: File & Folder Name Table
This block contains directory and file names. Given the folder name and the hash,
the number of files and their hashes in the FAT can be obtained. To obtain their complete
paths, the following procedure can be used:

1. Take the number of files and create a dictionary with the FAT.
2. Take the number of folders and create a dictionary with its FIT (Folder Info Table).
  1. For each file, find it by its dictionary entry and prepend its actual folder
    name.
