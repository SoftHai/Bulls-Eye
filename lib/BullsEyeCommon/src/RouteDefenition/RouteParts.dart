part of softhai.bulls_eye.Common;

abstract class RoutePart {
  
  const RoutePart();
  
}

class WildCard extends RoutePart {
  
  const WildCard() : super();
  
  String toString() 
  {
    var config = new RouteDefConfig.Current();
    return config.RoutePartWildCard;
  }
}

class Static extends RoutePart {
  
  final String partName;
  
  const Static(this.partName) : super();
  
  String toString() 
  {
    return this.partName;
  }
}

class Variable extends RoutePart {
  
  final String varName;
  final bool isOptional;
  
  const Variable(this.varName, [bool isOptional = false]) : this.isOptional = isOptional, super();
  
  void CheckUsage(RouteDef currentRoute) 
  {
    
  }
  
  String toString() 
  {
    var config = new RouteDefConfig.Current();
    
    var partStr = config.RoutePartVariableStart + this.varName + config.RoutePartVariableEnd;
    if(this.isOptional)
    {
      partStr = config.RoutePartVariableOptionalStart + partStr + config.RoutePartVariableOptionalEnd;
    }
    
    return partStr;
  }
}
