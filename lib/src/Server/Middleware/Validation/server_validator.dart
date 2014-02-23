part of softhai.bulls_eye.Server;

common.Validator header(Map<String, common.Validator> headerValidator, [bool invalidIfNoValidatorFound = false]) => new _ValidatorByKeyImpl(headerValidator, invalidIfNoValidatorFound);

common.Validator cookie(Map<String, common.Validator> cookieValidator, [bool invalidIfNoValidatorFound = false]) => new _ValidatorByKeyImpl(cookieValidator, invalidIfNoValidatorFound);

common.Validator formData(Map<String, common.Validator> formFieldValidator, [bool invalidIfNoValidatorFound = false]) => new _ValidatorByKeyImpl(formFieldValidator, invalidIfNoValidatorFound);

abstract class ValidatorByKey implements common.Validator {
  
  const ValidatorByKey();
  
  /**
   * Verifice if the input data are valid or not
   */
  bool isValid(Object data, [String key, String versionValue]);
  
}

class _ValidatorByKeyImpl implements ValidatorByKey {
  
  final Map<String, common.Validator> _keyValidator;
  final bool _invalidIfNoValidatorFound;
  
  String invalidReason;
  
  _ValidatorByKeyImpl(this._keyValidator, this._invalidIfNoValidatorFound) : super();
  
  bool isValid(Object data, [String key = common.DefaultKeyValidator, String versionValue = common.DefaultVerisonValidator]) {
    if(this._keyValidator.containsKey(key)) {
      var validator = this._keyValidator[key];
      var isValid = false;
      if(validator is common.ValidatorByVersion) {
        isValid = validator.isValid(data, versionValue);
      }
      else {
        isValid = validator.isValid(data);
      }
      
      this.invalidReason = "Key '$key' is invalid because of: ${validator.invalidReason}";
      return isValid;
    }
    else if(this._invalidIfNoValidatorFound) {
      return false;
    }
    else {
      return null;
    }
  }

}

common.Validator isFile([List<String> allowedExtensions]) => new _IsFileValidator(allowedExtensions);

class _IsFileValidator extends common.Validator {

  final List<String> _allowedExtensions;
  
  const _IsFileValidator(this._allowedExtensions) : super();
  
  String get invalidReason => "Is not a file or wrong extension";
  
  bool isValid(Object data) {
    // Check if file content
    var fileContent =  data as HttpBodyFileUpload;
    if(fileContent != null) {
      if(_allowedExtensions != null) {
        // Check if filename ends with oine of the allowed extensions
        for (var extension in this._allowedExtensions) {
          if(fileContent.filename.endsWith(extension)) {
            // Filename ends with allowed extension
            return true;
          }
        }
      }
      else {
        return true;
      }
    }
    
    return false;
  }
}

const common.Validator isBinary = const _IsBinaryValidator();

class _IsBinaryValidator extends common.Validator {

  const _IsBinaryValidator() : super();
  
  String get invalidReason => "Is not binary content";
  
  bool isValid(Object data) {
    // Check if file content
    var body =  data as HttpBody;
    if(body != null) {
      return body.type == "binary" && body.body is List<int>;
    }
    
    return false;
  }
}

const common.Validator isText = const _IsTextValidator();

class _IsTextValidator extends common.Validator {

  const _IsTextValidator() : super();
  
  String get invalidReason => "Is not text content";
  
  bool isValid(Object data) {
    // Check if file content
    var body =  data as HttpBody;
    if(body != null) {
      return body.type == "text" && body.body is String;
    }
    
    return false;
  }
}

const common.Validator isJson = const _IsJsonValidator();

class _IsJsonValidator extends common.Validator {

  const _IsJsonValidator() : super();
  
  String get invalidReason => "Is not JSON content";
  
  bool isValid(Object data) {
    // Check if file content
    var body =  data as HttpBody;
    if(body != null) {
      return body.type == "json" && body.body is Map;
    }
    
    return false;
  }
}