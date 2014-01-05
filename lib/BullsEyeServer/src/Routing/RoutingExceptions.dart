part of softhai.bulls_eye.Server;

abstract class RoutingException extends HttpRequestException {

  Route route;
  
  RoutingException(HttpRequest request, this.route) : super(request);
  
  String toString() {
    var routeName = this.route._routeDefenition.name;
    
    return super.toString() + "The route '$routeName' creates an unhandled error";
  }
}

class FileNotFoundException extends NotFoundException {

  Route route;
  
  FileNotFoundException(HttpRequest request, String resource, this.route) : super(request, resource, "File");
  
  String toString() {
    var routeName = this.route._routeDefenition.name;
    
    return super.toString() + " This was reported by the route '$routeName'.";
  }
}