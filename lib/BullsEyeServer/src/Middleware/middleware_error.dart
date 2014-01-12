part of softhai.bulls_eye.Server;

class MiddlewareError {
  
  String MiddlewareName;
  Object catchedError;
  
  MiddlewareError(this.MiddlewareName, this.catchedError);
  
}