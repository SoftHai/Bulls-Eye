part of softhai.bulls_eye.Common;

num _convertToNum(data) {
  if(data is num) {
    return data as num;
  }
  else {
    return num.parse(data.toString(), (s) => null);
  }
}

num _convertToInt(data) {
  if(data is int) {
    return data as int;
  }
  else {
    return int.parse(data.toString(), onError: (s) => null);
  }
}

const Validator isNum = const _IsNumImpl();

class _IsNumImpl implements Validator {
  
  const _IsNumImpl();
  
  String get invalidReason => "Is not a numeric value'";
  
  bool isValid(Object data) {
    var parsedNum = _convertToNum(data);
    return parsedNum != null;
  }
}

const Validator isInt = const _IsIntImpl();

class _IsIntImpl implements Validator {
  
  const _IsIntImpl();
  
  String get invalidReason => "Is not integer'";
  
  bool isValid(Object data) {
    var parsedInt = _convertToInt(data);
    return parsedInt != null;
  }
}

Validator inRangeNum(num from, num to) => new _InRangeNumImpl(from, to);

class _InRangeNumImpl extends IsTypeOf<num> {
  
  final num _from;
  final num _to;
  
  const _InRangeNumImpl(this._from, this._to) : super();
  
  String get invalidReason => "Is a numeric value or not in range (${this._from} to ${this._from})";
  
  bool isValid(Object data) {
    var parsedNum = _convertToNum(data);
    if(parsedNum != null)
    {
      return parsedNum > this._from && parsedNum < this._to;
    }
    
    return false;
  }
}