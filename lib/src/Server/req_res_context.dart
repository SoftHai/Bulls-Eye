part of softhai.bulls_eye.Server;

typedef void ErrorHandler(Object ex);

abstract class RouteData {
  
  Map<String, dynamic> get extensions;
  
  common.Url get definition;
  
  Uri get request;
  
  UrlVariables get variables;
  
}

abstract class UrlVariables {
  
  ReadOnlyMap<UrlInputData> get path;
  
  ReadOnlyMap<UrlInputData> get query;
  
}

abstract class RequestHeaderData {
  
  InputDataList<List<String>> get fields;
  
  InputDataList<Cookie> get cookies;
}

abstract class Request {
  
  String get method;
  
  RouteData get route;
  
  RequestHeaderData get header;
  
  InputData<HttpBody> get body;
}

abstract class Response {
  
  int statusCode;
  
  HttpHeaders get headers;

  List<Cookie> get cookies;
  
  ResponseBody get body;
}

abstract class ResponseBody {
  
  String get ContentType;
  
  dynamic get Data;
  
  void SetBody(String contentType, dynamic data);
  
  void TransformBody(String targetContentType, dynamic transform(data));
}

abstract class ReqResContext {
  
  Request request;
  Response response;
  Map<String, dynamic> data;

  void HandleError(Object ex);
  
  dynamic operator[](String key);
  
  void operator[]=(String key, dynamic value);
}

abstract class ReqResContextNative implements ReqResContext {
  
  HttpRequest nativeRequest;
}
