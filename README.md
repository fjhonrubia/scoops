# scoops
Práctica de cloud computing

Se ha incluido el código fuente de la práctica, así como los scripts que se han creado para las operaciones en el servidor (carpeta server). 

Se trata de una aplicación creada para iphone cuyo funcionamiento es el siguiente:

Cuando se entra por primera vez, se tiene que seleccionar el modo en el que se desea entrar (escritor o lector). En ambos modos se pedirá autentificarse directamente contra facebook para poder acceder a la aplicación. Cada uno de estos modos funciona de la siguiente manera:

Escritor: Se listan por defectao todas las noticias viendo la valoración para cada una de ellas (si no tienen valoraciones, estas aparecen como 0), pudiendo filtrar aquellas que están disponibles(publicadas) o no disponibles(no publicadas). Cuando se agrega una noticia, si se tiene el GPS activo y se le dan permisos se obtiene la información de latitud y longitud actual. También se tiene que cumplimentar la información del autor, título y texto de la noticia. Para agregar la imagen, hay que pulsar directamente sobre la foto de "no imagen" y, si se detecta que el dispositivo tiene cámara se accederá a ella. En caso contrario se accederá a la librería de fotos del dispositivo. para seleccionar una imagen ya almacenada.

Cuando se pulsa en el botón añadir se crea la noticia y cuando se pulsa en el botón disponible esta pasa a un nuevo estado (disponible = true) que hace que el script programado en el servidor sea capaz de hacer la publicación visible para los lectores.

Es posible modificar el autor, título y texto de las noticias pero no la imagen. Tampoco es posible eliminar una noticia ya creada. 

Lector: Se listarán todas las noticias y su autor. Si se selecciona una noticia es posible visualizar y valorar la misma. Esto hace incrementar el contador de valoraciones y caluclar la media de la valoración en el servidor antes de actualizar la noticia.


