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
| 0x0014 | 0x04   | Puntero a bloque 5 |
| 0x0018 | 0x04   | ?? |
| 0x001C | 0x04   | ?? |
| 0x0020 | 0x04   | ?? |
| 0x0024 | 0x04   | ?? |
| 0x0028 | ....   | Bloques codificados |

*Nota:* Todavía no sé para qué, pero calcula un offset: `i*[0x24] + ([0x20]+0x48)`

### Codificación
La primera palabra es de control con la siguiente información:
* Bits 0-2: Tipo de algoritmo.
  * 0: ¿Quizás "no codificado"?
  * 1: Por confirmar LZSS
  * 2: Huffman 4 bits
  * 3: Huffman 8 bits
  * 4: RLE 8 bits
* Bits 3-31: Tamaño del bloque descomprimido.
