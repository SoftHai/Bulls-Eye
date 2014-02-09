part of softhai.bulls_eye.Common;

abstract class QueryPart {
  
  const QueryPart();
  
}

class QVariable extends QueryPart implements VariableInfo {
  
  final String name;
  final bool isOptional;
  final Map<String,dynamic> extensions = new Map<String, dynamic>();
  
  QVariable(this.name, {bool isOptional: false, Map<String,dynamic> extensions}) : this.isOptional = isOptional, super() {
    if(extensions != null)
    {
      this.extensions.addAll(extensions);
    }
  }
  
  String toString() 
  {
    var config = new UrlDefConfig.Current();

    if(this.isOptional)
    {
      return config.RoutePartVariableOptionalStart + this.name + config.RoutePartVariableOptionalEnd;
    }
    
    return this.name;
  }
}