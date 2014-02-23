part of softhai.bulls_eye.Common;

DateTime _convertToDateTime(data) {
  if(data is DateTime) {
    return data as DateTime;
  }
  else {
    try {
      return DateTime.parse(data.toString());
    }
    catch (FormatException) {
      return null;
    }
  }
}

const Validator isDateTime = const _IsDateTimeImpl();

class _IsDateTimeImpl implements Validator {
  
  const _IsDateTimeImpl();
  
  String get invalidReason => "Is not date time";
  
  bool isValid(Object data) {
    var parsedDateTime = _convertToDateTime(data);
    return parsedDateTime != null;
  }
}

Validator inRangeDT(DateTime from, DateTime to) => new _InRangeDTImpl(from, to);

class _InRangeDTImpl extends IsTypeOf<num> {
  
  final DateTime _from;
  final DateTime _to;
  
  const _InRangeDTImpl(this._from, this._to) : super();
  
  String get invalidReason => "Is not datetime or not in range (${this._from} to ${this._from})";
  
  bool isValid(Object data) {
    var parsedDateTime = _convertToDateTime(data);
    if(parsedDateTime != null)
    {
      return parsedDateTime.isAfter(this._from) && parsedDateTime.isBefore(this._to);
    }
    
    return false;
  }
}

Validator notOlderThan(Duration duration) => new _NotOlderThanImpl(duration);

class _NotOlderThanImpl extends IsTypeOf<num> {
  
  final Duration _duration;
  
  const _NotOlderThanImpl(this._duration) : super();
  
  String get invalidReason => "Is not datetime or older than '${this._duration}'";
  
  bool isValid(Object data) {
    var parsedDateTime = _convertToDateTime(data);
    if(parsedDateTime != null)
    {
      return new DateTime.now().difference(parsedDateTime) < this._duration;
    }
    
    return false;
  }
}