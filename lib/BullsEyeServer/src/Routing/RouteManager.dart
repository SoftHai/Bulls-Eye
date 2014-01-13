part of softhai.bulls_eye.Server;

typedef void RouteLogicError(HttpRequestException error);

abstract class RouteLogic {
  
  void onError(RouteLogicError errorHandler);
  
  void execute(ReqResContext context);
}

typedef void HandleRoutingException(HttpRequestException ex);

class RouteManager {
  
  common.Url routeDefenition;
  String method;
  List<String> contentTypes;
  RouteLogic logic;
  String middleware;
  
  RouteManager(this.method, this.routeDefenition, this.logic, this.contentTypes, this.middleware);
  

  // Route match the path
  bool match(HttpRequest request) {

    // Check request method if required
    if(this.method != null)
    {
      if(this.method.toLowerCase() != request.method.toLowerCase()) 
      {
        return false;
      }
    }
    
    // Check requested content type if required
    if(this.contentTypes != null)
    {
      if(!request.headers[HttpHeaders.ACCEPT].contains("*/*")) // All Allowed?
      {
        var possibleContentTypes = this.contentTypes.where((ct) => request.headers[HttpHeaders.ACCEPT].firstWhere((data) => data.toString().contains(ct), orElse: () => null) != null);
        if(possibleContentTypes.length == 0) // Matches any ContentType
        {
          return false;
        }
      }
    }
    
    // Check Route
    return this.routeDefenition.matcher.match(request.uri.path);
  }
  
  // Executer
  ReqResContext createContext(HttpRequest request) 
  {
    var variables = this.routeDefenition.matcher.getMatches(request.uri.path);
    var context = new ReqResContext(request, this.routeDefenition, variables);
    return context;
  }

  String toString() {
    return this.routeDefenition.name;
  }
}


