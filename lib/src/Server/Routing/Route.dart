part of softhai.bulls_eye.Server;


abstract class RouteLogic {

  Future execute(ReqResContext context);
}

typedef void HandleRoutingException(HttpRequestException ex);

class Route {
  
  common.Url routeDefenition;
  String method;
  List<String> contentTypes;
  RouteLogic logic;
  String middleware;
  bool parseBody = false;
  Map<String, dynamic> extensions = new Map<String, dynamic>();
  
  Route(this.method, this.routeDefenition, this.logic, this.contentTypes, this.middleware, this.parseBody, Map<String, dynamic> extensions) {
    if(extensions != null) {
      this.extensions.addAll(extensions);
    }
  }
  

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
    return this.routeDefenition.matcher.match(request.uri.toString());
  }
  
  // Executer
  ReqResContext createContext(HttpRequest request, ErrorHandler errorHandler, [HttpBody body = null]) 
  {
    var context = new _ReqResContextImpl(request, this, errorHandler, body);
    return context;
  }

  String toString() {
    return this.routeDefenition.name;
  }
}


