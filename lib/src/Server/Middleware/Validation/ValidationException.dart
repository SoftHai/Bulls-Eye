part of softhai.bulls_eye.Server;


class VariableValidationException extends BadRequestException {
  
  dynamic variable;
  
  VariableValidationException(ReqResContext context, String reason, this.variable) : super(context, reason) {
    
  }
}