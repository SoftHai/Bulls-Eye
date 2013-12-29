part of softhai.bulls_eye.Common;

class MultipleVersionException implements Exception {

  RouteDef _routeDefinition;
  
  MultipleVersionException(this._routeDefinition);
  
  String toString() {
    return "Multible Version Definition in Route: " + this._routeDefinition.name;
  }
}