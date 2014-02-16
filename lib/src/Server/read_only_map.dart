part of softhai.bulls_eye.Server;

class ReadOnlyMap<ValueType> extends IterableBase<ValueType> {
  
  Map<String, ValueType> _inputDatas = new Map<String, ValueType>();
  
  Iterator<ValueType> get iterator => this._inputDatas.values.iterator;
  
  int get length => this._inputDatas.length;
  
  ValueType operator[](String key) => this._inputDatas[key];
  
  ReadOnlyMap._internal(Iterable<ValueType> inputDatas) : super() {
    
    for(var input in inputDatas) {
      this._inputDatas[input.key] = input;
    }
  }
}