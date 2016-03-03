function update(item, user, request) {
    
    //Se ha procedido a valorar una noticia desde la app del lector
    if (item.valorado == true) {
        
        var news = tables.getTable("noticias");
        
        news.where({ id: item.id })
        .read({ success: function(results) {
            //Solamente hay un registro con el id, por lo tanto se coge el primero
            console.log('BEGIN')
            
            console.log('Item id: ', item.id);
            console.log('Number of ratings before: ', results[0].num_valoraciones);
            item.num_valoraciones = results[0].num_valoraciones + 1;
            console.log('Number of ratings after: ', item.num_valoraciones);
            console.log('Rating before: ', results[0].valoracion);
            item.valoracion = (parseFloat(results[0].valoracion) + parseFloat(item.valoracion_individual))/item.num_valoraciones;
            console.log('Rating after: ', item.valoracion);
            
            //se vuelve a poner el atributo de valorado a false
            item.valorado = false;
            console.log('The new have been rating')
            console.log('END')
            request.execute();
        }});
    } else {
        request.execute();
    }
}