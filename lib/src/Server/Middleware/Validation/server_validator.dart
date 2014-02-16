part of softhai.bulls_eye.Server;

common.Validator header(Map<String, common.Validator> headerValidator, [bool invalidIfNoValidatorFound = false]) => new _ValidatorByKeyImpl(headerValidator, invalidIfNoValidatorFound);

common.Validator cookie(Map<String, common.Validator> cookieValidator, [bool invalidIfNoValidatorFound = false]) => new _ValidatorByKeyImpl(cookieValidator, invalidIfNoValidatorFound);

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
  
  const _ValidatorByKeyImpl(this._keyValidator, this._invalidIfNoValidatorFound) : super();
  
  bool isValid(Object data, [String key = common.DefaultKeyValidator, String versionValue = common.DefaultVerisonValidator]) {
    if(this._keyValidator.containsKey(key)) {
      var validator = this._keyValidator[key];
      if(validator is common.ValidatorByVersion) {
        return validator.isValid(data, versionValue);
      }
      else {
        return validator.isValid(data);
      }
    }
    else if(this._invalidIfNoValidatorFound) {
      return false;
    }
    else {
      return null;
    }
  }
  
}