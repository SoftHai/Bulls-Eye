part of softhai.bulls_eye.Server;

abstract class HttpRequestException implements Exception {
  
  HttpRequest request;
  
  HttpRequestException(this.request);
  
  String toString() {
    var requestPath = this.request.uri.toString();
    
    return "During executing the request '$requestPath' happens an error: ";
  }
  
}

class WrappedHttpRequestException extends HttpRequestException {
  
  Object originalException;
  
  WrappedHttpRequestException(HttpRequest request, this.originalException) : super(request);
  
  String toString() {
    return super.toString() + this.originalException.toString();
  }
}

class NotFoundException extends HttpRequestException {

  String resourceType;
  String resource;
  
  NotFoundException(HttpRequest request, this.resource, [this.resourceType]) : super(request);
  
  String toString() {
    var type = this.resourceType;
    var resource = this.resource;
    
    return super.toString() + "The resource '$type: $resource' was not found!";
  }
}