## Cabecera
Ocupa `32 bytes`.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x08   | `MESGbmg1` constante |
| 0x08   | 0x04   | Tamaño de archivo |
| 0x0C   | 0x04   | Número de secciones |
| 0x10   | 0x04   | Desconocido |

## Secciones
Estructura general:

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Nombre |
| 0x04   | 0x04   | Tamaño (incluye cabecera) |

### INF1
Tabla de punteros hacia el texto.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x08   | Cabecera estandar |
| 0x08   | 0x02   | Número de entradas |
| 0x0A   | 0x02   | Tamaño de cada entrada |
| 0x0C   | 0x04   | ¿Relleno? |
| 0x10   | ....   | Entradas |

Cada entrada son por defecto `8 bytes`:
* `4 bytes`: Puntero relativo a la sección `DAT1` sin contar cabecera.
* `2 bytes`: Primer puntero relativo a la sección `STR1` sin contar cabecera.
* `2 bytes`: Segundo puntero relativo a la sección `STR1` sin contar cabecera.

### DAT1
Entradas de texto. Tiene la cabecera estándar de `8 bytes` y a continuación cada una de los textos que contiene codificados y terminados con el caracter nulo `\0`.

### STR1
Entrada de texto a los que se apunta también desde `INF1`. Tiene cabecera estándar de `8 bytes` y cada entrada termina con el caracter nulo `\0`.

### FLW1
Cada entrada son `8 bytes` con una cabecera de `16 bytes`. En la posición `0x02` hay un valor de 16-bits que indica el índice a otra entrada de texto. Se desconce el objetivo.
