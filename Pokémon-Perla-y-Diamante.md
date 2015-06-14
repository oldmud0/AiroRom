# Fuentes

### Cabecera
| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Puntero a datos |
| 0x04   | 0x04   | Puntero a VWT |
| 0x08   | 0x04   | Tamaño sección VWT |

### Datos
Cada entrada es de `64 bytes`.

### Variable Width Table (VWT)
Aquí se especifica el ancho de cada caracter.
Por cada caracter hay una entrada de `un byte` indicando el ancho.