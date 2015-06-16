Fue desarrollado por *Game Freak* en el año 2009. Es de género *RPG* corresponde a la quinta generación de los juegos de *Pokémon*. Se lanzó exclusivamente para *NDS* y se localizó a todos los idiomas de la consola.

## Textos
Mismo formato, cifrado y claves que en [Pokémon Perla y Diamante](Pokémon-Perla-y-Diamante#textos). Hasta se mantiene el fallo de seguridad.

Protección por nombre de ficheros. Los primeros textos (¿todos?) están en *a/0/2/7*.

## Fuentes
Mismo formato que en [Pokémon Perla y Diamante](Pokémon-Perla-y-Diamante#fuentes)

Protección por nombre de ficheros. Los primeros textos (¿todos?) están en *a/0/1/6*. También en *pbr/font.arc*.

## Imágenes
Están cifradas.

## Audio
No está cifrado, son secuencias (MIDI).

## Acceso a ficheros
Este juego se protege poniéndo todos los ficheros con nombres numéricos dentro de carpetas numéricas. La forma que internamente se accede a los ficheros es mediante IDs. De esta forma existe una tabla con todas las rutas a las ficheros. El acceso a esta tabla es mediante un ID, por ejemplo a *a/0/2/7* le corresponde *0x1B*.

Los desarrolladores posiblemente se facilitaron la tarea creando un archivo genérico como el siguiente

**filepaths.h**
```c
#define MESSAGE_FILE_ID 0x1B
```

Sabiendo que hay 10 carpetas y ficheros en cada carpeta. Se comprueba que:
```
0*9 + 2*10 + 7 = 27 = 0x1B
```
De forma que el *software* que más tarde usaron para **ofuscar** el nombre de los ficheros solo tuvo que coger el ID interno y clasificar los archivos. Si bien no hay rastro del nombre original de esta forma se puede saber de qué arcihvo se está cargando en el juego cuando se llama a la función:

```asm
0x0200BAF8: load_file
Argument 0: Unknown
Argument 1: File ID
```
