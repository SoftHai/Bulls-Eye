part of softhai.bulls_eye.Common;

Validator inList(List<String> list) => new _InListImpl(list);

class _InListImpl extends IsTypeOf<num> {
  
  final List<String> _list;
  
  const _InListImpl(this._list) : super();
  
  String get invalidReason => "Is not in list of allowed values'";
  
  bool isValid(Object data) {
    return this._list.contains(data);
  }
}

const String AND = "and";
const String OR = "or";

Validator composed(List<Validator> validators, [String composeType = AND]) => new _ComposedImpl(validators, composeType);

/**
 * A Validator which compose several single validator to one
 */
class _ComposedImpl implements Validator {
    
  final List<Validator> _validators;
  final String _composeType;
  
  String invalidReason;
  
  _ComposedImpl(List<Validator> validators, this._composeType) : this._validators = validators, super();
  
  /**
   * Verifice if the input data are valid or not
   * 
   * Runs through all registered single validators and checks the input data.
   * If you fails than the data are invalid.
   */
  bool isValid(Object data) {
    
    for(var validator in this._validators) {
      var isValid = validator.isValid(data); 

      // take invalid reason
      if(!isValid) {
        this.invalidReason = validator.invalidReason;
      }
      
      if(_composeType == AND && !isValid) {
        // if AND and one is invalid than abort and return false
        return false;
      }
      else if(_composeType == OR && isValid) {
        // if OR and one is valid than abort and return true
        return true;
      }
    }
    
    // all executed without abort
    if(_composeType == AND) {
      return true;
    }
    else if (_composeType == OR) {
      return false;
    }
    
    return false;
  }
}

Validator versionDep(Map<String, Validator> versionValidator, [bool invalidIfNoValidatorFound = true]) => new _ValidatorByVersionImpl(versionValidator, invalidIfNoValidatorFound);

class _ValidatorByVersionImpl implements ValidatorByVersion {
  
  final Map<String, Validator> _versionValidator;
  final bool _invalidIfNoValidatorFound;
  
  String invalidReason;
  
  _ValidatorByVersionImpl(this._versionValidator, this._invalidIfNoValidatorFound) : super();
  
  bool isValid(Object data, [String verisonValue = DefaultVerisonValidator]) {
    if(this._versionValidator.containsKey(verisonValue)) {
      var isValid = this._versionValidator[verisonValue].isValid(data);
      this.invalidReason = "Version '$verisonValue' is invalid because of: ${this._versionValidator[verisonValue].invalidReason}";
      return isValid;
    }
    else {
      return !this._invalidIfNoValidatorFound;
    }
  }
  
}