part of softhai.bulls_eye.Common;

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

/**
 * A Validator which compose several single validator to one
 */
class ComposedValidators implements Validator {
  
  final List<Validator> _validators;
  
  const ComposedValidators(List<Validator> validators) : this._validators = validators, super();
  
  /**
   * Verifice if the input data are valid or not
   * 
   * Runs through all registered single validators and checks the input data.
   * If you fails than the data are invalid.
   */
  bool isValid(Object data) {
    
    for(var validator in this._validators)
    {
      var isValid = validator.isValid(data); 
      // if one is invalid than abort and return
      if(!isValid)
      {
        return false;
      }
    }
    
    // all executed without abort => valid
    return true;
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