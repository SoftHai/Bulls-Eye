part of softhai.bulls_eye.Server;

const String HeaderValidatorKey = "HeaderValidation";
const String HeaderValidatorOnInvalidKey = "HeaderValidationInValid";

const String CookieValidatorKey = "CookieValidation";
const String CookieValidatorOnInvalidKey = "CookieValidationInValid";

const String BodyValidatorKey = "BodyValidation";
const String BodyValidatorOnInvalidKey = "BodyValidationInValid";

const String ValidationSection_Header = "HEADER";
const String ValidationSection_Cookie = "COOKIE";
const String ValidationSection_URLPathVar = "URL_PATH_VARIABLE";
const String ValidationSection_URLQueryVar = "URL_QUERY_VARIABLE";
const String ValidationSection_Body = "BODY";

class Validation implements BeforeHook {
  
  Future before(ReqResContext context) {
      
    var versionValue = common.DefaultKeyValidator;
    var version = context.request.route.variables.path.firstWhere((v) => v.variable is common.Version, orElse: () => null);
    if(version != null)
    {
      versionValue = version.value;
    }
    
    this._validateHeaders(context, versionValue);
    
    this._validateCookies(context, versionValue);
    
    this._validateUrlInputs(ValidationSection_URLPathVar, context.request.route.variables.path, context, versionValue);
    
    this._validateUrlInputs(ValidationSection_URLQueryVar, context.request.route.variables.query, context, versionValue);
    
    this._validateBody(context, versionValue);
  }
  
  void _validateUrlInputs(String validationSection, ReadOnlyMap<UrlInputData> variables, ReqResContext context, String versionValue) {

    for(var urlInputData in variables) {
      
      var onInvalid = urlInputData.variable.extensions[common.ValidatorOnInvalidKey];
      var validator = urlInputData.variable.extensions[common.ValidatorKey] as common.Validator;
      if(validator != null) {

        bool isValid = false;
        var data = urlInputData.value;
        var onInvalid = urlInputData.variable.extensions[common.ValidatorOnInvalidKey];
        
        this._validateInputData(validationSection, context, urlInputData, validator, versionValue, onInvalid);
      }
    }
  }
  
  void _validateHeaders(ReqResContext context, String versionValue) {
    
    var onInvalid = context.request.route.extensions[HeaderValidatorOnInvalidKey];
    var validator = context.request.route.extensions[HeaderValidatorKey] as ValidatorByKey;
    if(validator != null)
    {
      for (var headerInputData in context.request.header.fields) {
        _validateInputData(ValidationSection_Header, context, headerInputData, validator, versionValue, onInvalid);
      } 
    }
  }
  
  void _validateCookies(ReqResContext context, String versionValue) {
    
    var onInvalid = context.request.route.extensions[CookieValidatorOnInvalidKey];
    var validator = context.request.route.extensions[CookieValidatorKey] as ValidatorByKey;
    if(validator != null)
    {
      for (var cookieInputData in context.request.header.cookies) {
        this._validateInputData(ValidationSection_Cookie, context, cookieInputData, validator, versionValue, onInvalid);
      } 
    }
  }
  
  void _validateBody(ReqResContext context, String versionValue) {
    
    var onInvalid = context.request.route.extensions[BodyValidatorOnInvalidKey];
    var validator = context.request.route.extensions[BodyValidatorKey] as common.Validator;
    if(validator != null)
    {
      if(context.request.body != null && context.request.body.value != null) {
          
        if(context.request.body.value.type == 'form' && context.request.body.value.body is Map && validator is ValidatorByKey) {
          var tempInputDatas = new List<InputData>();
          (context.request.body.value.body as Map).forEach((k,v) => tempInputDatas.add(new _InputDataImpl(k, v)));

          for (var bodyInputData in tempInputDatas) {
            this._validateInputData(ValidationSection_Body, context, bodyInputData, validator, versionValue, common.OnInvalidContinue);
            
            // If something invalid than break and return
            if(bodyInputData.isValidated && !bodyInputData.isValid) {
              context.request.body.validated(false);
              this._handleInvalid(ValidationSection_Body, validator.invalidReason, context.request.body, context, onInvalid);
              return;
            }
          } 
          
          // Check all without abort, all good
          context.request.body.validated(true);
        }
        else {
          this._validateInputData(ValidationSection_Body, context, context.request.body, validator, versionValue, onInvalid);
        }
      }
      else {
        throw new ValidationException(context, "Validation rules for body but no body parsed. Can't validate body!", null, ValidationSection_Body, "Validation rules for body but no body parsed");
      }
    }
    
  }
  
  void _validateInputData(String validationSection, ReqResContext context, InputData inputData, common.Validator validator, String versionValue, int onInvalid) {
    
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
    if(isValid == null) {
      // Input stays unvalidated
    }
    else if(isValid) {
      inputData.validated(true);
    }
    else {
      this._handleInvalid(validationSection, validator.invalidReason, inputData, context, onInvalid);
    }
    
  }
  
  void _handleInvalid(String validationSection, String invalidReason, InputData inputData, ReqResContext context, int onInvalid) {
    
    inputData.validated(false);
    
    if(onInvalid == common.OnInvalidContinue) {
      // Do nothing
    }
    else {
      throw new ValidationException(context, "The variable '${inputData.key}' of '$validationSection' is not valid because of '$invalidReason'", inputData, validationSection);
    }
  }
  
}