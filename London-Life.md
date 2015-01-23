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

# Formato textos MSG
