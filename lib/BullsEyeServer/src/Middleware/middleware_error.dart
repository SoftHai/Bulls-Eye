part of softhai.bulls_eye.Server;

class MiddlewareError {
  
  String middlewareName;
  Object catchedError;
  
  MiddlewareError(this.middlewareName, this.catchedError);
  
}