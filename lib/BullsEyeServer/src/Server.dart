part of softhai.bulls_eye.Server;

class Server {
  
  bool _debugMode = false;
  List<Route> _routes = new List<Route>();
  
  Server({bool debug: false}) : this._debugMode = debug;
  
  void RegisterRoute(Route route){
    this._routes.add(route);
    
    route.registerExceptionHandler(this._handleRoutingException);
  }
  
  void start() {
    HttpServer.bind('127.0.0.1', 8080).then((server) {
      server.listen((HttpRequest request) {
        
        this._debugOutput("New call recived: " + request.uri.toString());
        this._debugOutput("Search for matching route...");
        
        for(int i = 0; i < this._routes.length; i++)
        {
          var route = this._routes[i];
          if(route.match(request))
          {
            this._debugOutput("route '$route' matched! Executing...");
            
            // Results: true = successful, null = executing async, false = npt executed - try next route
            var result = route.execute(request);
            
            this._debugOutput("route '$route' finished with '$result'");
            
            if(result == true || result == null)
            {
              this._debugOutput();
              return;
            }
          }
        }
        
        // No match found
        this._debugOutput("No route Matched!");
        
        this._handleRoutingException(new NotFoundException(request, request.uri.path, "Route for"));
        
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
  
  void _handleRoutingException(HttpRequestException ex)
  {
    if(ex is NotFoundException)
    {
      this._debugOutput(ex.toString());
      
      ex.request.response.statusCode = HttpStatus.NOT_FOUND;
      ex.request.response.close();
    }
  }
  
  void _debugOutput([String message = ""])
  {
    if(this._debugMode) 
    {
      print(message);
    }
  }
  
}