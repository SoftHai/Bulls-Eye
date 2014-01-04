part of softhai.bulls_eye.Server;

class Server {
  
  List<Route> _routes = new List<Route>();
  
  void RegisterRoute(Route route){
    this._routes.add(route);
    
    route.registerExceptionHandler(this._handleException);
  }
  
  void start() {
    HttpServer.bind('127.0.0.1', 8080).then((server) {
      server.listen((HttpRequest request) {
        
        for(int i = 0; i < this._routes.length; i++)
        {
          var route = this._routes[i];
          if(route.match(request))
          {
            route.execute(request);
            
            return;
          }
        }
        
        // No match found
        print('NOT FOUND: ' + request.uri.path);
        request.response.statusCode = HttpStatus.NOT_FOUND;
        request.response.close();
        
        /*
        print("");
        print("Call in - Method:" + request.method + 
            " | Path:" + request.uri.path);
        print("----------Header-Data---------");
        request.headers.forEach((a,b) { print(a + ": " + b.join(" | "));});
        print("------------------------------");
        request.response.write('Hello, world');
        request.response.close();
        print("Call out");
        */
      });
    });
  }
  
  void _handleException(Route route, HttpRequest request, Exception ex)
  {
    if(ex is NotFoundException)
    {
      print(ex.toString());
      
      request.response.statusCode = HttpStatus.NOT_FOUND;
      request.response.close();
    }
  }
  
}