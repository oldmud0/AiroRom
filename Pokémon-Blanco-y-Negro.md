Fue desarrollado por *Game Freak* en el año 2012. Es de género *RPG* corresponde a la sexta generación de los juegos de *Pokémon*. Se lanzó exclusivamente para *NDS* y se localizó a todos los idiomas de la consola.

## Textos
Protección por nombre de ficheros. Los primeros textos (¿todos?) están en *a/0/0/2*.

El texto se descifra usando la operación XOR sobre una clave que va cambiando. La clave inicial es igual a `clave = (i + 3) * 0x2983` siendo `i` el bloque de texto a descifrar. La clave va cambiando moviendo los 3 bits más significativos a la posición menos significativa de la siguiente forma:
```
temp  = clave & 0x1FFF; // Elimina bits más significativos
clave = (temp << 3) | (clave >> 13); // Los añade al principio
```

## Fuentes
No hace falta estudiar pues la codificación es UTF-16.

## Imágenes
No están cifradas. Pero el formato es bastante diferente pues se divide el pokémon en partes para formar animaciones y se usan formatos propietarios para esto.

## Audio
No está cifrado, son secuencias (MIDI).

## Acceso a ficheros
De igual manera que en [Pokémon Perla y Diamante](Pokémon-Perla-y-Diamante#acceso-a-ficheros).
