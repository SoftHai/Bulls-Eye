part of softhai.bulls_eye.Server;

class FileRoute extends Route {
  
  String _filePath;
  
  FileRoute(common.RouteDef routeDefenition, [this._filePath, List<String> methods, List<String> contentTypes]) : super(routeDefenition, methods, contentTypes) {
    
  }
  
  bool _internalExecute(HttpRequest request, common.MatchResult variables) 
  {
    return false;
  }
}