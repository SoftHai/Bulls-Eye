part of softhai.bulls_eye.Server;

abstract class HttpRequestException implements Exception {
  
  HttpRequest request;
  
  HttpRequestException(ReqResContext context) : this._native((context as ReqResContextNative).nativeRequest);
  
  HttpRequestException._native(this.request);
  
  String toString() {
    return "During executing the request '${this.request.method} - ${this.request.uri}' happens an error: ";
  }
  
}

class WrappedHttpRequestException extends HttpRequestException {
  
  Object originalException;
  
  WrappedHttpRequestException(ReqResContext context, this.originalException) : super(context);
  
  WrappedHttpRequestException._native(HttpRequest request, this.originalException) : super._native(request);
  
  String toString() {
    return super.toString() + this.originalException.toString();
  }
}

/**
 * Exception for HTTP Failure: 400
 */
class BadRequestException extends HttpRequestException {

  String reason;
  
  BadRequestException(ReqResContext context, this.reason) : super(context);
  
  String toString() {
    return super.toString() + "It was a bad request because: ${this.reason}";
  }
}

/**
 * Exception for HTTP Failure: 404
 */
class NotFoundException extends HttpRequestException {

  String resourceType;
  String resource;
  
  NotFoundException(ReqResContext context, this.resource, [this.resourceType]) : super(context);
  
  NotFoundException._native(HttpRequest request, this.resource, [this.resourceType]) : super._native(request);
  
  String toString() {
    return super.toString() + "The resource '${this.resource}: ${this.resourceType}' was not found!";
  }
}
