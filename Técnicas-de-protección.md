*Técnicas de protección de datos encontradas durante el estudio
de videojuegos.*

* Comprimir en lugar de cifrar.
* No tener sistema de ficheros.
* No ponerle nombre a los ficheros -> Acceso por hash del nombre.
* Codificaciones distintas en cada sección de archivos de paquete.
* Paquetes no inmediatos (punteros como múltiplos y suma).
* Borrar en seguida ficheros de memoria para difícil localización.
* Empaquetar archivos para acceso no inmediato de archivos.
* Posibles tipos de algoritmos de cifrado:
  1. Se descifra todo el fichero aunque no se vaya a usar parte de él.
    * Se podría localizar en la RAM.
  2. Solo se descifra algún bloque o se escribe a 0 el resto.
    * Se podría buscar el texto que aparezca en pantalla en la RAM.
  3. Solo lo que se ve en la pantalla, desperdigado y con otro formato.


* **Requisitos algoritmo óptimo**
  * Soporte para *todos* los archivos del juego.
    * Acceso rápido -> cabecera decodificada en RAM.
  * Acceso a archivos por nombre (*Ni no kuni*).
  * Codificar cabecera [XOR con string].
  * Bytes aleatorios para despistar.
  * Compresión y cifrado de archivos individuales.
