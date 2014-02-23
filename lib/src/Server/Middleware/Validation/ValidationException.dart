part of softhai.bulls_eye.Server;


class ValidationException extends BadRequestException {
  
  InputData inputData;
  String section;
  
  ValidationException(ReqResContext context, String reason, this.inputData, this.section) : super(context, reason) {
    
  }
}