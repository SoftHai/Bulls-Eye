part of softhai.bulls_eye.Server;

abstract class RoutingException extends HttpRequestException {

  common.Url url;
  
  RoutingException(HttpRequest request, this.url) : super(request);
  
  String toString() {
    return super.toString() + "The route '${this.url.name}' creates an unhandled error";
  }
}

class FileNotFoundException extends NotFoundException {

  common.Url url;
  
  FileNotFoundException(HttpRequest request, String resource, this.url) : super(request, resource, "File");
  
  String toString() {
    return super.toString() + " This was reported by the route '${this.url.name}'.";
  }
}