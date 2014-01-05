part of softhai.bulls_eye.Common;

abstract class QueryPart {
  
  const QueryPart();
  
}

class QVariable extends QueryPart {
  
  final String varName;
  final bool isOptional;
  
  const QVariable(this.varName, [bool isOptional = false]) : this.isOptional = isOptional, super();
  
  String toString() 
  {
    var config = new RouteDefConfig.Current();

    if(this.isOptional)
    {
      return config.RoutePartVariableOptionalStart + this.varName + config.RoutePartVariableOptionalEnd;
    }
    
    return this.varName;
  }
}