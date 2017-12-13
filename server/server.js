    var http = require('http');
    var qs = require('querystring');
    var fs = require('fs');

    var lineReader = require('line-reader');

    var scores = [];

    lineReader.eachLine('scores.txt', function(line, last) {
      var cells = line.split(';');
      var score = {
        name: cells[0].replace(/\"/g, ''),
        time: parseFloat(cells[1]),
        date: parseFloat(cells[2])
      }
      scores.push(score);
      if(last) {
        console.log('fini');
      }
    });

    var server = http.createServer ( function(request,response){

    response.writeHead(200,{"Content-Type":"text\plain"});
    if(request.method == "GET") {
        /*var json = JSON.stringify(
            [
                { 
                    'name': 'Epo',
                    'time': 52.12145,
                    'date': Date.now()
                }, { 
                    'name': 'Lulu',
                    'time': 53.21,
                    'date': Date.now()
                }, { 
                    'name': 'nul',
                    'time': 1,
                    'date': Date.now()
                }, { 
                    'name': 'fort',
                    'time': 100,
                    'date': Date.now()
                }, { 
                    'name': 'bof-egalite',
                    'time': 20,
                    'date': Date.now()
                }, { 
                    'name': 'bof-egalite-prems',
                    'time': 20,
                    'date': Date.now() - 100000
                }
            ]
            );*/
            var json = JSON.stringify(scores);
            //console.log(json);
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
            //console.log(post);
            // use post['blah'], etc.
            var jsonObj = JSON.parse(body);
            console.log(jsonObj);
            console.log(jsonObj.name);
            console.log(jsonObj.time);
            console.log(jsonObj.date);

            scores.push(jsonObj);

            fs.appendFile('scores.txt', '"' + jsonObj.name.replace(/\"/, '') + '";' + jsonObj.time + ';' + jsonObj.date + '\r\n', function (err) {
            if (err) throw err;
                console.log('Saved!');
            });
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