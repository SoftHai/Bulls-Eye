part of softhai.bulls_eye.Common;

bool _convertToBool(data) {
  if(data is bool) {
    return data as bool;
  }
  else if(data is String) {
    var str = (data as String).toLowerCase();
    if(str == "true" || str == "1") {
      return true;
    }
    else if(str == "false" || str == "0") {
      return false;
    }
  }
  
  return null;
}


const Validator isBool = const _IsBoolImpl();

class _IsBoolImpl implements Validator {
  
  const _IsBoolImpl();
  
  bool isValid(Object data) {
    var parsedBool = _convertToBool(data);
    return parsedBool != null;
  }
}