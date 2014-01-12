part of softhai.bulls_eye.Server;

typedef bool LogicCall(ReqResContext context);

class LogicRoute extends Route {
  
  LogicCall _logicCall;
  
  LogicRoute(common.Url routeDefenition, this._logicCall, {List<String> methods, List<String> contentTypes}) : super(routeDefenition, methods, contentTypes) {
    
  }
  
  bool _internalExecute(ReqResContext context) 
  {
    try
    {
      return this._logicCall(context);
    }
    catch(e)
    {
      this._handleException(new WrappedHttpRequestException(context.request, e));
    }
  }
}
