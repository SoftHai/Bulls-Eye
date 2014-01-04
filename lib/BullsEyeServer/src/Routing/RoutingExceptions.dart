part of softhai.bulls_eye.Server;

abstract class RoutingException implements Exception {

  Route route;
  
  RoutingException(this.route);
  
  String toString() {
    var routeName = this.route._routeDefenition.name;
    
    return "The route '$routeName' creates an Error";
  }
}

class NotFoundException extends RoutingException {

  String resource;
  
  NotFoundException(Route route, this.resource) : super(route);
  
  String toString() {
    var routeName = this.route._routeDefenition.name;
    var resource = this.resource;
    
    return "During executing of the route '$routeName', the resource '$resource' was not found";
  }
}