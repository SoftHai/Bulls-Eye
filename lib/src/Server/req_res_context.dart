part of softhai.bulls_eye.Server;

typedef void ErrorHandler(Object ex);

class ReqResContext {

  ErrorHandler _errorHandler = null;
  
  HttpRequest request;
  common.Url currentRoute;
  common.UriMatcherResult variables;
  Map<String, Object> contextData;

  ReqResContext(this.request, this.currentRoute, this.variables, this._errorHandler) {
    this.contextData = new Map<String,Object>();
  }
  
  void HandleError(Object ex) {
    if(ex is HttpRequestException) {
      this._errorHandler(ex);
    }
    else {
      this._errorHandler(new WrappedHttpRequestException(this.request, ex));
    }
  }
}