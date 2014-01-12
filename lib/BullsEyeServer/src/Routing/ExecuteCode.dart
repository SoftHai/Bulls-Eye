part of softhai.bulls_eye.Server;

typedef bool CodeCall(ReqResContext context);

class ExecuteCode implements RouteLogic {
  
  RouteLogicError _errorHandler;
  CodeCall _codeCall;
  
  ExecuteCode(this._codeCall) {
    
  }
  
  void onError(RouteLogicError errorHandler) {
    this._errorHandler = errorHandler;
  }
  
  void execute(ReqResContext context) 
  {
    this._codeCall(context);
  }
}
