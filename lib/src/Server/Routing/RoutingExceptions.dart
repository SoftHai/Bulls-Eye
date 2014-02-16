part of softhai.bulls_eye.Server;

abstract class RoutingException extends HttpRequestException {

  common.Url url;
  
  RoutingException(ReqResContext context, this.url) : super(context);
  
  String toString() {
    return super.toString() + "The route '${this.url.name}' creates an unhandled error";
  }
}

class FileNotFoundException extends NotFoundException {

  common.Url url;
  
  FileNotFoundException(ReqResContext context, String resource) : this.url = context.request.url.definition,  super(context, resource, "File");
  
  String toString() {
    return super.toString() + " This was reported by the route '${this.url.name}'.";
  }
}