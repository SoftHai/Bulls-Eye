part of softhai.bulls_eye.Server;

abstract class InputData<ValueType> {
  
  String get key;
  
  ValueType get value;
  
  bool get isValidated;
  
  void validated([bool isValid = true]);
}

abstract class UrlInputData implements InputData<dynamic> {
  
  common.VariableInfo get variable;
  
}

class _InputDataImpl<ValueType> implements InputData<ValueType> {
  
  bool _isValidated = false;
  bool _isValid = false;
  
  final String key;
  
  final ValueType value;
  
  bool get isValidated => this._isValidated;
  
  bool get isValid => this._isValid;
  
  _InputDataImpl(this.key, this.value);
  
  void validated([bool isValid = true]) {
    this._isValid = isValid;
    this._isValidated = true;
  }
}

class _UrlInputData<ValueType> extends _InputDataImpl<ValueType> implements UrlInputData {
  
  final common.VariableInfo variable;
  
  _UrlInputData(String key, ValueType value, this.variable) : super(key, value);
}

class InputDataList<InputValueType> extends ReadOnlyMap<InputData<InputValueType>> {
  
  InputDataList._internal(Iterable<InputData<InputValueType>> inputDatas) : super._internal(inputDatas);
}