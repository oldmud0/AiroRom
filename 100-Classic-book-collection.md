**100 Classic book collection** es un *juego* para la *Nintendo DS* desarrollado por *HarperCollins* en 2008. No se trata de un juego en sí, si no de una librearía de *ebooks*. Se distribuyó en Japón, América y Europa posiblemente con diferentes libros. Además de los libros que incluye, también se pueden descargar gratuitamente hasta 10 como DLC.

# Libros
Están estructurados en *23 bloques*, pudiendo estar algunos vacíos.
Excepto el primer bloque, el resto están codificados con la compresión
de la *BIOS* *LZSS*. No hay mayor protección.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x10   | Seguramente algún *hash* |
| 0x10   | 0x04   | Desconocido, parece ser constante a `0x0F` |
| 0x14   | 0x04*23| Por cada bloque hay `4 bytes` con el puntero absoluto |
| 0x70   | 0x04*23| Por cada bloque hay `4 bytes` con el tamaño |