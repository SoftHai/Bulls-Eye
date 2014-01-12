part of softhai.bulls_eye.Server;

class ReqResContext {

  HttpRequest request;
  common.Url currentRoute;
  common.UriMatcherResult variables;
  Map<String, Object> contextData;

  ReqResContext(this.request, this.currentRoute, this.variables) {
    this.contextData = new Map<String,Object>();
  }
}