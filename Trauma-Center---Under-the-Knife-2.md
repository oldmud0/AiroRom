**Trauma Center - Under the Knife 2** es un juego para la *Nintendo DS* (NDS). Fue desarrollado por *Atlus* en el año 2008. Es de género simulación médica y corresponde a una saga para varias plataformas. El juego salío en japón y américo.

Su mayor problema es la falta de una jerarquía de archivos (casi todos los archivos están en el directorio raíz), la falta de nombre a los archivos (su nombre son número hexadecimales) y el estar los textos codificados.

# Textos
Están codificados de forma propietaría siguiendo la tabla de la fuente.
Los caracteres siguen en su mayoría el orden ASCII, siendo por ejemplo
la `i = 0x104`.

El primer bloque de texto mostrado en el juego corresponde al archivo `013E`.

# Fuente
Se encuentra en el archivo `0178`.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x01   | Flags (posiblemente si los bloques están codificados) |
| 0x01   | 0x03   | Desconocido |
| 0x04   | 0x02   | Puntero a la tabla |
| 0x06   | 0x02   | Tamaño de la tabla |
| 0x08   | 0x02   | Puntero a bloque de datos |
| 0x0A   | 0x02   | Tamaño del bloque de datos |
| 0x0C   | 0x02   | Puntero a último bloque |
| 0x0E   | 0x02   | Tamaño del último bloque |

## Bloque de datos
Está codificado con LZSS