function publishNews() {
    var news = tables.getTable("noticias");
    console.log('News Obtained');
    
    news.where({ disponible: true, estado_publicado: false})
        .read({ success: function(results) {

            console.log('We obtain published news that they are not visible.');

            if (results.length > 0) {
                for (var i = 0; i < results.length; i++) {

                    results[i].estado_publicado = true;
                    news.update(results[i]);
                    console.log('Updating new: ' + results[i].title + ' | Texto -> ' +  results[i].text);

                }
            } else {
                console.log('There are no visible published news.');
            }


        }});

}