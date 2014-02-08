part of softhai.bulls_eye.Server;

abstract class HttpRequestException implements Exception {
  
  HttpRequest request;
  
  HttpRequestException(this.request);
  
  String toString() {
    return "During executing the request '${this.request.uri}' happens an error: ";
  }
  
}

class WrappedHttpRequestException extends HttpRequestException {
  
  Object originalException;
  
  WrappedHttpRequestException(HttpRequest request, this.originalException) : super(request);
  
  String toString() {
    return super.toString() + this.originalException.toString();
  }
}

/**
 * Exception for HTTP Failure: 400
 */
class BadRequestException extends HttpRequestException {

  String reason;
  
  BadRequestException(HttpRequest request, this.reason) : super(request);
  
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
  
  NotFoundException(HttpRequest request, this.resource, [this.resourceType]) : super(request);
  
  String toString() {
    return super.toString() + "The resource '${this.resource}: ${this.resourceType}' was not found!";
  }
}
