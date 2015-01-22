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
| 0x0000 | 0x04   | Cabecera: `GFSA`, se verifica |
| 0x0004 | 0x04   | Puntero a bloque 1 |
| 0x0008 | 0x04   | Puntero a bloque 2 |
| 0x000C | 0x04   | Puntero a bloque 3 |
| 0x0010 | 0x04   | Puntero a bloque 4 |
| 0x0014 | 0x04   | Puntero a datos (`dataPtr`) |
| 0x0018 | 0x04   | Número de carpetas |
| 0x001C | 0x04   | Número de archivos |
| 0x0020 | 0x04   | `([0x18]+[0x1C]) * 8` |
| 0x0024 | 0x04   | ?? |
| 0x0028 | ....   | Bloques codificados |

*Nota:* Todavía no sé para qué, pero calcula un offset: `i*[0x24] + ([0x20]+0x48)`

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
obtener la posición relativa en el FAT.

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

### Bloque 3: Desconocido (¿Nulo?)

### Bloque 4: File & Folder Name Table
En este bloque están los nombres de directores y nombres por separado.
Todavía no sé una relación para unir nombre de fichero a directorio que lo
contiene.
