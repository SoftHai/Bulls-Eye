part of softhai.bulls_eye.Server;


class VariableValidationException extends BadRequestException {
  
  dynamic variable;
  
  VariableValidationException(HttpRequest request, String reason, this.variable) : super(request, reason) {
    
  }
}