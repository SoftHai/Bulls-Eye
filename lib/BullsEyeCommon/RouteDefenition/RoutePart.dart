part of softhai.bulls_eye.Common;

abstract class RoutePart {
  
}

class WildCard extends RoutePart {
  
  WildCard() : super();
  
  String toString() 
  {
    var config = new RouteDefConfig.Current();
    return config.RoutePartWildCard;
  }
}

class Static extends RoutePart {
  
  String partName;
  
  Static(this.partName) : super();
  
  String toString() 
  {
    return this.partName;
  }
}

class Variable extends RoutePart {
  
  String varName;
  bool isOptional = false;
  
  Variable(this.varName, [bool isOptinal = false]) : super() 
  {
    this.isOptional = isOptinal;
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

class Version extends Variable {

  Version() : super(new RouteDefConfig.Current().RoutePartVariableVersion, false);
}