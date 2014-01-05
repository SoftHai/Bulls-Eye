part of softhai.bulls_eye.Server;

class FileRoute extends Route {
  
  String _filePath;
  
  FileRoute.fromUri(common.RouteDef routeDefenition, {List<String> methods, List<String> contentTypes}) : super(routeDefenition, methods, contentTypes);
    
  FileRoute.fromPath(common.RouteDef routeDefenition, this._filePath, {List<String> methods, List<String> contentTypes}) : super(routeDefenition, methods, contentTypes);
  
  bool _internalExecute(RouteContext context) 
  {
    var filePath = this._filePath; 
    
    if(filePath == null)
    {
      // Try to find a wildcard variable
      filePath = context.routeVariables["*"];
    }
    
    if(filePath == null)
    {
      return false;
    }
    else
    {
      final File file = new File(filePath);
      var f = file.exists().then((bool found) {
        if (found) 
        {
          file.openRead().pipe(context.request.response);
        } 
        else 
        {
          this._handleException(new FileNotFoundException(context.request, filePath, this));
        }
      });
    }
    
    return null;
  }
}