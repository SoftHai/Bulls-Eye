part of softhai.bulls_eye.Server;

class Server {
  
  bool _debugMode = false;
  List<_RouteManager> _routes = new List<_RouteManager>();
  Map<String, _MiddlewareImpl> _middlewares = new Map<String, _MiddlewareImpl>();
  
  Server({bool debug: false}) : this._debugMode = debug;
  
  Middleware middleware(String name) {
    var middleware = new _MiddlewareImpl(name, this._handleMiddlewareException);
    _middlewares[name] = middleware;
    
    return middleware;
  }
  
  void route(String method, common.Url url, RouteLogic logic, {List<String> contentTypes, String middleware}) {
    this._routes.add(new _RouteManager(method, url, logic, contentTypes, middleware));
    
    logic.onError(this._handleRoutingException);
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
            var context = route.createContext(request);
            if(route.middleware != null)
            {
              // execute with middleware
              var middleware = this._middlewares[route.middleware];
              middleware.execute(context, route.logic.execute);
            }
            else
            {
              // execute only logic
              var future = new Future.sync(() => route.logic.execute(context));
              future.catchError((ex) {
                  if(ex is HttpRequestException) {
                    this._handleRoutingException(ex);
                  }
                  else {
                    this._debugOutput("Unhandled Exception $ex");
                  }
                });
            }
            
            return;
            /*
            this._debugOutput("route '$route' finished with '$result'");
            
            if(result == true || result == null)
            {
              this._debugOutput();
              return;
            }
            */
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
  
  bool _handleMiddlewareException(ReqResContext context, MiddlewareError error)
  {
    if(error.catchedError is HttpRequestException)
    {
      this._handleRoutingException(error.catchedError);
    }
    else {
      context.request.response.statusCode = HttpStatus.BAD_REQUEST;
      context.request.response.close();
    }
    
    return false;
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