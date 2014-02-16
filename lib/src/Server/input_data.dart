part of softhai.bulls_eye.Server;

abstract class InputData<ValueType> {
  
  String get key;
  
  ValueType get value;
  
  bool get isValidated;
  
  void SetIsValidated();
}

abstract class UrlInputData implements InputData<dynamic> {
  
  common.VariableInfo get variable;
  
}

class _InputDataImpl<ValueType> implements InputData<ValueType> {
  
  bool _isValidated = false;
  
  final String key;
  
  final ValueType value;
  
  bool get isValidated => this._isValidated;
  
  _InputDataImpl(this.key, this.value);
  
  void SetIsValidated() {
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