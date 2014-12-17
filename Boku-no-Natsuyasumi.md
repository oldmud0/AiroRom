**Boku no Natsuyasumi** es un juego para la *Play Station 1* (PS1 / PSX). Fue desarrollado por *Millennium Kitchenx* en el año 2000. Es de género *aventura* y a partir de él se generó una serie de hasta 3 juegos llevados a otras consolas como *PS3* y *PSP*. Todos los juegos de la saga están disponibles solo en **japonés**. No he encontrado ningún intento ni deseo de traducción. Para este caso me he concrentado en la versión más reciente para *PSP* dejando la de *PS1* para un posible futuro.

Más información y herramientas se pueden encontrar en [este repositorio](https://github.com/pleonex/Boku-no-Natsuyasumi).

# Archivos
Todos los archivos del juego están comprimidos en un archivo de tipo **paquete** con jerarquía por carpetas: *cdimg0.img*. Las referencias / punteros a dichos archivos están guardados en otro ficher: *cdimg.idx*. La información detalla del formato se puede encontrar en [esta wiki](https://github.com/pleonex/Boku-no-Natsuyasumi/wiki/Pack-file-cdimg).

Una parte de los archivos están comprimidos con **GZip**.
 * _Extensión `.gz`_: archivos con compresión *GZip* normal. Se pueden descomprimir con:
``` shell
# Remplaza "file" por el nombre del fichero.
gzip -d file.bin.gz
```

 * _Extensión `.gzx`_: tienen un cabecera de *4 bytes* indicando el tamaño descomprimido final, para descomprimirlos con herramientas estándares hay que quitarla. Se pueden descomprimir con:
``` shell
# Remplaza "file" por el nombre del fichero.
dd if=file.bin.gzx bs=512k | { dd bs=4 count=1 of=/dev/null; dd bs=512k of=file.bin.gz; }
gzip -d file.bin.gz
```

# Textos
Están dentro de los archivos comprimidos con *GZip* de la carpeta `map/gz`. Estos archivos son paquetes que agrupan varios diálogos. Todavía no se ha investigado ese formato de fichero. Los textos siguen una tabla no estándar que se está generando actualmente y que coincide con la fuente del juego.