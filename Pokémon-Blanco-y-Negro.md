Fue desarrollado por *Game Freak* en el a�o 2012. Es de g�nero *RPG* corresponde a la sexta generaci�n de los juegos de *Pok�mon*. Se lanz� exclusivamente para *NDS* y se localiz� a todos los idiomas de la consola.

## Textos
Protecci�n por nombre de ficheros. Los primeros textos (�todos?) est�n en *a/0/0/2*.

El texto se descifra usando la operaci�n XOR sobre una clave que va cambiando. La clave inicial es igual a `clave = (i + 3) * 0x2983` siendo `i` el bloque de texto a descifrar. La clave va cambiando moviendo los 3 bits m�s significativos a la posici�n menos significativa de la siguiente forma:
```
temp  = clave & 0x1FFF; // Elimina bits m�s significativos
clave = (temp << 3) | (clave >> 13); // Los a�ade al principio
```

## Fuentes
No hace falta estudiar pues la codificaci�n es UTF-16.

## Im�genes
No est�n cifradas. Pero el formato es bastante diferente pues se divide el pok�mon en partes para formar animaciones y se usan formatos propietarios para esto.

## Audio
No est� cifrado, son secuencias (MIDI).

## Acceso a ficheros
De igual manera que en [Pok�mon Perla y Diamante](Pok�mon-Perla-y-Diamante#acceso-a-ficheros).
