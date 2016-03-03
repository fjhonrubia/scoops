var azure = require('azure');
var qs = require('querystring');

exports.get = function(request, response) {
    
    // en el parametro nos llega el nombre del blob
    var blobName = request.query.blobName;
    var containerName = request.query.ContainerName;
    
    var accountName = "fjhonru";
    
    var accountKey =  "6R2KEYoyN+G27KCi70S8FQttUASSas+NFyJR78C06oQORP24pOh/uZgSrTDxpMQFejQxXSmN/h+VmsstbJW84A==";
    
    var host = accountName + '.blob.core.windows.net/';
    
    console.log("La URL antes de la SAS es -> " + host );
    
    var blobService = azure.createBlobService(accountName, accountKey, host);
    
    // creamos o validamos el contenedor
    blobService.createContainerIfNotExists(containerName, {publicAccessLevel : 'blob'},function(error, result, response){
       
       if (!error){
           var sharedAccessPolicy;
           sharedAccessPolicy = {
               AccessPolicy: {
                   Permissions: 'rw',
                   Expiry: minutesFromNow(15)
               }
           };
           var sasURL = blobService.generateSharedAccessSignature(containerName, '', sharedAccessPolicy);
           //console.log('SAS ->' + String.stringify(sasURL));
           var sasQueryString = { 'sasUrl' : sasURL.path + '?' + qs.stringify(sasURL.queryString) };
           console.log('resultado -> ' + sasQueryString);
           request.respond(200, sasQueryString);
       } else {
           request.respond(200, {'error' : error});
       }
    });
};
function formatDate(date) {
    var raw = date.toJSON();
    // Blob service does not like milliseconds on the end of the time so strip
    return raw.substr(0, raw.lastIndexOf('.')) + 'Z';
}
function minutesFromNow(minutes) {
    var date = new Date()
    date.setMinutes(date.getMinutes() + minutes);
    return date;
}