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

Para descifrar basta una operación XOR. Cabe destacar un fallo de seguridad pues los valores de offset y tamaño son de 32 bits pero en la mayoría de los casos sólo se usan 16-bits. Esto hace que los dos últimos bytes suelan ser 0. Como la clave es de 16-bits para hacerla de 32-bits simplemente se concatena dos veces, esto hace que al cifrar esos valores, se queda almacenada la clave en texto plano en esos dos bytes.

| Offset | Tamaño | Descripción |
| ------ | ------ | ----------- |
| 0x00   | 0x04   | Offset cifrado |
| 0x04   | 0x04   | Tamaño cifrado |

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
| 0x0C   | 0x01   | Ancho |
| 0x0D   | 0x01   | Alto  |
| 0x0E   | 0x01   | BPP ancho |
| 0x0F   | 0x01   | BPP alto |

### Datos
Cada entrada es de `64 bytes`.
Está codificado de forma horizontal con 2 BPP. El primer color es el fondo del cuadrado. El segundo color el fondo del caracter, y los dos siguientes para el caracter en sí. Con Tinke se puede ver.

### Variable Width Table (VWT)
Aquí se especifica el ancho de cada caracter.
Por cada caracter hay una entrada de `un byte` indicando el ancho.


## Imágenes
Están cifradas.


## Audio
No está cifrado, son secuencias (MIDI).
