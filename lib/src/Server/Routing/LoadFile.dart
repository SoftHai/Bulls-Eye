part of softhai.bulls_eye.Server;

class LoadFile implements RouteLogic {
  
  RouteLogicError _errorHandler;
  String _filePath;
  
  LoadFile.fromUrl();
    
  LoadFile.fromPath(this._filePath);
  
  void onError(RouteLogicError errorHandler) {
    this._errorHandler = errorHandler;
  }
  
  void execute(ReqResContext context) 
  {
    var filePath = this._filePath; 
    
    if(filePath == null)
    {
      // Try to find a wildcard variable
      filePath = context.variables.routeVariables["*"];
    }
    
    if(filePath != null) {
      final File file = new File(filePath);
      var f = file.exists().then((bool found) {
        if (found) 
        {
          file.openRead().pipe(context.request.response);
        } 
        else 
        {
          if(this._errorHandler != null) {
            this._errorHandler(new FileNotFoundException(context.request, filePath, context.currentRoute));
          }
        }
      });
    }
  }
}