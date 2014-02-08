part of softhai.bulls_eye.Common;

const String ValidatorKey = "Validation";

/**
 * Base class for validation logic
 */
abstract class Validator {
  
  const Validator();
  
  /**
   * Verifice if the input data are valid or not
   */
  bool isValid(Object data);
  
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
  
  const _ComposedImpl(List<Validator> validators, this._composeType) : this._validators = validators, super();
  
  /**
   * Verifice if the input data are valid or not
   * 
   * Runs through all registered single validators and checks the input data.
   * If you fails than the data are invalid.
   */
  bool isValid(Object data) {
    
    for(var validator in this._validators) {
      var isValid = validator.isValid(data); 

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
  }
}

/**
 * A Validator to check if the given data are of a specific type
 */
abstract class IsTypeOf<Type> implements Validator {
  
  const IsTypeOf();
  
  bool isValid(Object data) {
    return data is Type;
  }
  
}