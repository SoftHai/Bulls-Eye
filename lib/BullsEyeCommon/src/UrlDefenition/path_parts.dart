part of softhai.bulls_eye.Common;

abstract class PathPart {
  
  const PathPart();
  
}

class WildCard extends PathPart {
  
  const WildCard() : super();
  
  String toString() 
  {
    var config = new UrlDefConfig.Current();
    return config.RoutePartWildCard;
  }
}

class Static extends PathPart {
  
  final String partName;
  
  const Static(this.partName) : super();
  
  String toString() 
  {
    return this.partName;
  }
}

class Variable extends PathPart {
  
  final String varName;
  final bool isOptional;
  
  const Variable(this.varName, [bool isOptional = false]) : this.isOptional = isOptional, super();
  
  void CheckUsage(Url currentRoute) 
  {
    
  }
  
  String toString() 
  {
    var config = new UrlDefConfig.Current();
    
    var partStr = config.RoutePartVariableStart + this.varName + config.RoutePartVariableEnd;
    if(this.isOptional)
    {
      partStr = config.RoutePartVariableOptionalStart + partStr + config.RoutePartVariableOptionalEnd;
    }
    
    return partStr;
  }
}
