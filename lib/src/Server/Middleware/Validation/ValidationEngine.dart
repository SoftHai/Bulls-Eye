part of softhai.bulls_eye.Server;

const String HeaderValidatorKey = "HeaderValidation";
const String HeaderValidatorOnInvalidKey = "HeaderValidationInValid";

const String CookieValidatorKey = "CookieValidation";
const String CookieValidatorOnInvalidKey = "CookieValidationInValid";

const String BodyValidatorKey = "BodyValidation";
const String BodyValidatorOnInvalidKey = "BodyValidationInValid";

class Validation implements BeforeHook {
  
  Future before(ReqResContext context) {
      
    var versionValue = common.DefaultKeyValidator;
    var version = context.request.route.variables.path.firstWhere((v) => v.variable is common.Version, orElse: () => null);
    if(version != null)
    {
      versionValue = version.value;
    }
    
    this._validateUrlInputs(context.request.route.variables.path, context, versionValue);
    
    this._validateUrlInputs(context.request.route.variables.query, context, versionValue);
    
    this._validateHeaders(context, versionValue);
    
    this._validateCookies(context, versionValue);
    
    this._validateHeaders(context, versionValue);
  }
  
  void _validateUrlInputs(ReadOnlyMap<UrlInputData> variables, ReqResContext context, String versionValue) {

    for(var urlInputData in variables) {
      
      var onInvalid = urlInputData.variable.extensions[common.ValidatorOnInvalidKey];
      var validator = urlInputData.variable.extensions[common.ValidatorKey] as common.Validator;
      if(validator != null) {

        bool isValid = false;
        var data = urlInputData.value;
        var onInvalid = urlInputData.variable.extensions[common.ValidatorOnInvalidKey];
        
        this._validateInputData(context, urlInputData, validator, versionValue, onInvalid);
      }
    }
  }
  
  void _validateHeaders(ReqResContext context, String versionValue) {
    
    var onInvalid = context.request.route.extensions[HeaderValidatorOnInvalidKey];
    var validator = context.request.route.extensions[HeaderValidatorKey] as ValidatorByKey;
    if(validator != null)
    {
      for (var headerInputData in context.request.header.fields) {
        _validateInputData(context, headerInputData, validator, versionValue, onInvalid);
      } 
    }
  }
  
  void _validateCookies(ReqResContext context, String versionValue) {
    
    var onInvalid = context.request.route.extensions[CookieValidatorOnInvalidKey];
    var validator = context.request.route.extensions[CookieValidatorKey] as ValidatorByKey;
    if(validator != null)
    {
      for (var cookieInputData in context.request.header.cookies) {
        _validateInputData(context, cookieInputData, validator, versionValue, onInvalid);
      } 
    }
  }
  
  void _validateBody(ReqResContext context, String versionValue) {
    
    var onInvalid = context.request.route.extensions[BodyValidatorOnInvalidKey];
    var validator = context.request.route.extensions[BodyValidatorKey] as common.Validator;
    if(validator != null)
    {
      _validateInputData(context, context.request.body, validator, versionValue, onInvalid);
    }
    
  }
  
  void _validateInputData(ReqResContext context, InputData inputData, common.Validator validator, String versionValue, int onInvalid) {
    
    bool isValid = false;
    var data = inputData.value;
    
    // Validate
    if(validator is ValidatorByKey) {
      isValid = (validator as ValidatorByKey).isValid(data, inputData.key, versionValue);
    }
    else if(validator is common.ValidatorByVersion) {
      isValid = (validator as common.ValidatorByVersion).isValid(data, versionValue);
    }
    else {
      isValid = validator.isValid(data);
    }
    
    // Check result
    if(isValid) {
      inputData.SetIsValidated();
    }
    else {
      this._handleInvalid(inputData, context, onInvalid);
    }
    
  }
  
  void _handleInvalid(InputData inputData, ReqResContext context, int onInvalid) {
    
    if(onInvalid == common.OnInvalidContinue) {
      // Do nothing
    }
    else {
      throw new ValidationException(context, "The variable '${inputData.key}' is not valid", inputData);
    }
  }
  
}