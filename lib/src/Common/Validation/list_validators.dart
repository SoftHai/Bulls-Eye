part of softhai.bulls_eye.Common;

Validator inList(List<String> list) => new _InListImpl(list);

class _InListImpl extends IsTypeOf<num> {
  
  final List<String> _list;
  
  const _InListImpl(this._list) : super();
  
  bool isValid(Object data) {
    return this._list.contains(data);
  }
}