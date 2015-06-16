Fue desarrollado por *Game Freak* en el año 2006. Es de género *RPG* corresponde a la cuarta generación de los juegos de *Pokémon*. Se lanzó exclusivamente para *NDS* y se localizó a todos los idiomas de la consola.

## Textos
Haciendo una busqueda diferenciada de dos bytes en ASCII sobre un RAM dump se encuentra en la posición 0x2954F0 una de las primeras palabras 'there' del juego. Es importante que sea todo del mismo rango: letras y minúsculas. A partir de ahí, se mira depurando el juego como se ha escrito esos bytes para saber de qué fichero y después de qué trasnformaciones se obtienen. Esta posición cambia dinámicamente de sitio.

### Cabecera
| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x02   | Número de entradas |
| 0x02   | 0x02   | Clave base de entradas |
| 0x04   | ....   | Entradas |

### Entradas
La clave de la i-ésima entrada se forma de la siguiente manera:
```
clave = (ushort)(clave_base * 0x2FD * (i + 1))
```

Además es redundante pues se incluye la clave del offset y del tamaño junto a él (son iguales). Para descifrar basta una operación XOR.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x02   | Offset cifrado |
| 0x02   | 0x02   | Clave del offset |
| 0x04   | 0x02   | Tamaño cifrado |
| 0x06   | 0x02   | Clave del tamaño |

### Texto
El texto se encontrará en el offset indicado con el tamaño indicado.
Para descifrarlo se utilizaa la operación XOR con un clave cambiante.
La clave inicial será:
```
clave_texto = (ushort)(0x91BD3 * (i + 1))
```

Y después de aplicar la operación XOR sobre un byte cambiará de la siguiente forma
```
clave_texto = (ushort)(clave_texto + 0x493D)
```

La salida será un texto con una codificación propia. Para hallar esta se puede o estudiar el formato de la fuente y comparar cada caracter con su valor o apartir de los textos del juego. El primer texto del juego está en el sub-archivo 0x155.

## Fuentes
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
