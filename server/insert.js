function insert(item, user, request) {

    var message;
    var insert = true;

    if (item.autor.length == 0){
        insert = false;
        message = 'Author is required.\n';
    }

    if (item.titulo.length == 0){
        insert = false;
        message = 'Title is required.\n';
    }
    
    if (item.texto_noticia.length == 0){
        insert = false;
        message = 'New text is required.\n';
    }
    
    if (!insert){
        console.log('A problem ocurred with the fields');
        request.respond(statusCodes.BAD_REQUEST, message);        
    } else {
        console.log('The news will be saved');
        item.valoracion = 0;
        item.num_valoraciones = 0;
        item.valorado = false;
        item.valoracion_individual = 0;
        request.execute();
    }

}