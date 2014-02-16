part of softhai.bulls_eye.Server;


class ValidationException extends BadRequestException {
  
  InputData inputData;
  
  ValidationException(ReqResContext context, String reason, this.inputData) : super(context, reason) {
    
  }
}