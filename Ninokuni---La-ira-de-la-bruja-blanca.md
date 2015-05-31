*Ninokuni - La Ira de la Bruja Blanca* es un juego para la *PS3*. Fue desarrollado por Level-5 en el año 2011. Es de género RPG siendo una versión modificada de la disponible para la *Nintendo DS*. Fue localizado a la mayoría de los idiomas: japonés, inglés y multi-5 (europeos) e incluye en su edición coleccionista un libro impreso.

# Libro
En esta edición del juego, el libro se ha digitalizado y está dentro del juego en formato `TGDT0100`.

## Cabecera
| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x08   | Identificador `TGDT0100` |
| 0x08   | 0x04   | Número de páginas |
| 0x0C   | 0x04   | Posición de los datos: `entradas * 0x10 + padding` |
| 0x10   | ....   | Bloques `GVD` |
| ....   | ....   | Datos |

## Bloque GVD
Cada bloque contiene información una página del libro.

### Cabecera
| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Posición del nombre. Relativo al bloque de datos. |
| 0x04   | 0x04   | Tamaño del nombre de la página. |
| 0x08   | 0x04   | Posición de los datos. Relativo al bloque de datos. |
| 0x0C   | 0x04   | Tamaño de los datos de la página. |

### Nombre
La codificación del nombre de las páginas es ASCII y viene con extensión.

### Datos
| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x10   | Identificador `GVEW0100JPEG0100` |
| 0x10   | 0x04   | Ancho de la versión con mayor calidad |
| 0x14   | 0x04   | Alto de la versión con mayor calidad |
| 0x18   | 0x04   | Identificador `BLK_` |
| 0x1C   | 0x04   | Tamaño del bloque |
| 0x20   | 0x04   | ID |
| 0x24   | 0x04   | Reservado |
| 0x28   | 0x04   | Desconocido. Costante `0x20` |
| 0x2C   | 0x04   | Desconocido. Constante `0x04` |
| 0x30   | ....   | Bloques de páginas |

#### Páginas
Cada página está dividia en diferentes segmentos de diferente calidad que unidos forman la página. Cada segmento es una imagen JPEG.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Posición X del segmento |
| 0x04   | 0x04   | Posición Y del segmento |
| 0x08   | 0x04   | Calidad |
| 0x0C   | 0x04   | Tamaño de los datos |
| 0x10   | 0x04   | Desconocido |
| 0x14   | 0x04   | Desconocido |
| 0x18   | 0x04   | Ancho |
| 0x1C   | 0x04   | Alto |
| 0x20   | ....   | Datos |

Si los datos empiezan por `GVMP` entonces se deben leer esta estructura y coger solo el primer bloques de datos que contiene.

#### GVMP
| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Identificador `GVMP` |
| 0x04   | 0x04   | Número de bloques. El primero es la imagen JPEG |

Por cada bloque:

| 0ffset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Posición de los datos del bloque dentro de `GVMP` |
| 0x04   | 0x04   | Tamaño del bloque |

# Escenas animadas
El juego también incluye escenas animadas realizadas usando el motor 3D o mediante escenas de anime. La extensión del archivo es `.pam` pero están codificadas en `MPG` teniendo una cabecera de `0x800` bytes innecesaria para la reproducción normal.
