part of softhai.bulls_eye.Server;


class ValidationException extends BadRequestException {
  
  InputData inputData;
  String section;
  String invalidReason;
  
  ValidationException(ReqResContext context, String reason, this.inputData, this.section, this.invalidReason) : super(context, reason) {
    
  }
}