    var http = require('http');
    var qs = require('querystring');

    var server = http.createServer ( function(request,response){

    response.writeHead(200,{"Content-Type":"text\plain"});
    if(request.method == "GET") {
        var json = JSON.stringify(
            [
                { 
                    'name': 'Epo',
                    'time': 52.12145,
                    'date': Date.now()
                }, { 
                    'name': 'Lulu',
                    'time': 53.21,
                    'date': Date.now()
                }
            ]
            );
        response.end(json)
    }
    else if(request.method == "POST") {
        var body = '';

        request.on('data', function (data) {
            body += data;

            // Too much POST data, kill the connection!
            // 1e6 === 1 * Math.pow(10, 6) === 1 * 1000000 ~~~ 1MB
            if (body.length > 1e6)
                request.connection.destroy();
        });

        request.on('end', function () {
            var post = qs.parse(body);
            console.log(post);
            // use post['blah'], etc.
        });
        response.end("received POST request.");
    }
    else
        {
            response.end("Undefined request .");
        }
});

server.listen(8000);
console.log("Server running on port 8000");