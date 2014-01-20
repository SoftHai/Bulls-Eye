part of softhai.bulls_eye.Server;

typedef Future CodeCall(ReqResContext context);

class ExecuteCode implements RouteLogic {
  
  CodeCall _codeCall;
  
  ExecuteCode(this._codeCall) {
    
  }

  Future execute(ReqResContext context) 
  {
    return new Future.sync(() => this._codeCall(context)).catchError((ex) => context.HandleError(ex));
  }
}
