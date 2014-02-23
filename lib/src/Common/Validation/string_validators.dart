part of softhai.bulls_eye.Common;

Validator startWith(Pattern pattern,[int index = 0]) => new _StartWith(pattern, index);

class _StartWith extends IsTypeOf<String> {
  
  final Pattern _pattern;
  final int _index;
  
  const _StartWith(this._pattern, this._index);
  
  String get invalidReason => "String don't starts with ${this._pattern}' at index '${this._index}'";
  
  bool isValid(Object data) {
    var isString = super.isValid(data);
    
    if(isString)
    {
      return (data as String).startsWith(this._pattern, this._index);
    }
    
    return false;
  }
}

Validator endWith(Pattern pattern) => new _EndWith(pattern);

class _EndWith extends IsTypeOf<String> {
  
  final Pattern _pattern;
  
  const _EndWith(this._pattern);
  
  String get invalidReason => "String don't starts with ${this._pattern}'";
  
  bool isValid(Object data) {
    var isString = super.isValid(data);
    
    if(isString)
    {
      return (data as String).endsWith(this._pattern);
    }
    
    return false;
  }
}

Validator isRegEx(RegExp regEx) => new _IsRegExImpl(regEx);

class _IsRegExImpl extends IsTypeOf<String> {
  
  final RegExp _regEx;
  
  const _IsRegExImpl(this._regEx);
  
  String get invalidReason => "String don't matchs the regular expression";
  
  bool isValid(Object data) {
    var isString = super.isValid(data);
    
    if(isString)
    {
      return this._regEx.hasMatch(data);
    }
    
    return false;
  }
}

// Email RegEx source: http://www.regular-expressions.info/email.html
Validator isEmail() => new _IsRegExImpl(new RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"));