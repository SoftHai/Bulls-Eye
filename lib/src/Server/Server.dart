part of softhai.bulls_eye.Server;

typedef bool ExceptionHandler(HttpRequestException ex);

class Server {
  
  bool _debugMode = false;
  List<Route> _routes = new List<Route>();
  Map<String, _MiddlewareImpl> _middlewares = new Map<String, _MiddlewareImpl>();
  ExceptionHandler _customExceptionHandler;
  
  Server({bool debug: false}) : this._debugMode = debug;
  
  Middleware middleware(String name) {
    var middleware = new _MiddlewareImpl(name);
    _middlewares[name] = middleware;
    
    return middleware;
  }
  
  void route(String method, common.Url url, RouteLogic logic, {List<String> contentTypes, String middleware, bool parseBody: false, Map<String,dynamic> extensions}) {
    this._routes.add(new Route(method, url, logic, contentTypes, middleware, parseBody, extensions));
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
            
            ReqResContext context = null;
            Future future = null;
            
            // Parse body if wished
            if(route.parseBody) {
              future = new Future.sync(() => HttpBodyHandler.processRequest(request))
                                 .then((body) => context = route.createContext(request, this._handleException, body));
            }
            else {
              future = new Future.sync(() => context = route.createContext(request, this._handleException));
            }
            
            if(route.middleware != null)
            {
              // execute with middleware
              var middleware = this._middlewares[route.middleware];
              future.then((_) =>  middleware.execute(context, route.logic.execute));
            }
            else
            {
              // execute only logic
              future.then((context) => new Future.sync(() => route.logic.execute(context)));
            }
            future.then((_) {
              if(context.response.body.Data != null)
              {
                if(context.response.body.ContentType != null)
                {
                  request.response.headers.set(HttpHeaders.CONTENT_TYPE, context.response.body.ContentType);
                }
                request.response.write(context.response.body.Data);
              }
            }).catchError((ex) {
              if(ex is HttpRequestException) {
                this._handleException(ex);
              }
              else {
                this._handleException(new WrappedHttpRequestException._native(request, ex));
                this._debugOutput("Unhandled Exception $ex");
              }
            });
            
            return;
          }
        }
        
        // No match found
        this._debugOutput("No route Matched!");
        
        this._handleException(new NotFoundException._native(request, request.uri.path, "Route for"));
        
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
  
  void exception(ExceptionHandler handler) {
    this._customExceptionHandler = handler;
  }
  
  
  void _handleException(HttpRequestException ex)
  {
    this._debugOutput("Error '$ex' occurred!");
    
    bool handled = false;
    
    // Custom Error handling
    if(this._customExceptionHandler != null)
    {
      handled = this._customExceptionHandler(ex);
    }
    
    if(handled != true)
    {
      // Default Error handling
      if(ex is NotFoundException)
      {
        this._debugOutput(ex.toString());
        
        ex.request.response.statusCode = HttpStatus.NOT_FOUND;
        ex.request.response.close();
      }
      else
      {
        ex.request.response.statusCode = HttpStatus.BAD_REQUEST;
        ex.request.response.close();
      }
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