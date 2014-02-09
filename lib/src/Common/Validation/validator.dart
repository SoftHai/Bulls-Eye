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

abstract class ValidatorByVersion implements Validator {
  
  static const String defaultVersionValidator = "Default";
  
  const ValidatorByVersion();
  
  /**
   * Verifice if the input data are valid or not
   */
  bool isValid(Object data, [String versionValue = defaultVersionValidator]);
  
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
