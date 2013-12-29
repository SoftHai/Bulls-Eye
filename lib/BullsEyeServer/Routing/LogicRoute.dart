part of softhai.bulls_eye.Server;

typedef bool LogicCall(HttpRequest request, common.MatchResult variables);

class LogicRoute extends Route {
  
  LogicCall _logicCall;
  
  LogicRoute(common.RouteDef routeDefenition, this._logicCall, [List<String> methods, List<String> contentTypes]) : super(routeDefenition, methods, contentTypes) {
    
  }
  
  bool _internalExecute(HttpRequest request, common.MatchResult variables) 
  {
    return this._logicCall(request, variables);
  }
}
