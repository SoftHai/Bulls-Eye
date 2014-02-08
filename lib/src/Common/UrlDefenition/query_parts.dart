part of softhai.bulls_eye.Common;

abstract class QueryPart {
  
  const QueryPart();
  
}

class QVariable extends QueryPart {
  
  final String varName;
  final bool isOptional;
  final Map<String,dynamic> extensions = new Map<String, dynamic>();
  
  QVariable(this.varName, {bool isOptional: false, Map<String,dynamic> extensions}) : this.isOptional = isOptional, super() {
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
      return config.RoutePartVariableOptionalStart + this.varName + config.RoutePartVariableOptionalEnd;
    }
    
    return this.varName;
  }
}