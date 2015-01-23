**London Life** es un minijuego para la *Nintendo DS* (NDS). Fue desarrollado por *Level-5* e incluído solo en la versión para Reino Unido de [El profesor Layton y la llamada del espectro](Professor-Layton-and-The-Last-Specter). Está solo disponible en inglés.

# Estructura
Los archivos están dentro de la carpeta `ll`, siendo dos de ellos los más importantes:
* *ll/common/ll_common.darc*: Contiene las fuentes, textos y audios.
* *ll/kihira/kihira.archive*: Contiene todas las imágenes y sprites.

Hace dos años terminé un [plug-in](https://github.com/pleonex/tinke/tree/master/Plugins/LAYTON) para [Tinke](https://github.com/pleonex/tinke) que permite descomprimir y extraer la mayoría de estos archivos. Para el caso del archivo de textos MSG hice un programa a parte que pronto estará disponible.

# Contenedor DARC
Contiene archivos `DENC` en su interior.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Cabecera `DARC` |
| 0x04   | 0x04   | Número de archivos |
| 0x08   | 0x04*i | Offset de cada archivo relativo a la posición actual |

Además sobre cada archivo, 4 bytes antes del mismo, está su tamaño.

# Contenedor ARCHIVE
Contiene archivos comprimidos con las compresiones de la BIOS (LZSS, HUFFMAN y RLE).

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Tamaño del FAT |
| 0x04   | [0x00] | FAT |

Por cada archivo hay 8 bytes de información:
1. 4 bytes: Offset absoluto al archivo.
2. 4 bytes: Tamaño del archivo.

# Compresión DENC
Encapsula un archivo para determinar su algoritmo de compresión.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Cabecear `DENC` |
| 0x04   | 0x04   | Tamaño decodificado |
| 0x08   | 0x04   | Codificación, ver más abajo |
| 0x0C   | 0x04   | Tamaño codificado |

Los valores posibles de codificación son:
* `NULL`: No está codificado.
* `LZSS`: Codificado con variante de LZSS.

## Variante LZSS
Se trata de una variante de LZSS muy sencilla que sigue el siguiente esquema.
Una implementación en C# se puede encontrar [aquí](https://github.com/pleonex/tinke/blob/master/Plugins/LAYTON/LAYTON/DARC.cs#L177).

1. Leer el token (1 byte).
2. Comprobar el primer bit del token
  1. Si es '1' => está codificado, hay que repetir un byte X veces.
    1. El nuevo token se compone de dos bytes, leer un byte y juntarlo con el token antiguo.
    2. Los siguientes 11 bits del nuevo token indican cuantas posiciones hay que retroceder para encontrar el valor a repetir.
    3. Los 4 bits restantes indican cuantas veces hay que repetir el byte.
  2. Si es '0' => no está codificado, copiar X bytes
    1. El número de bytes a copiar serán los 7 bits restantes del token.

# Formato textos MSG
