part of softhai.bulls_eye.Common;

abstract class PathPart {
  
  const PathPart();
  
}

class WildCard extends PathPart implements VariableInfo {
  
  final String name = new UrlDefConfig.Current().RoutePartWildCard;
  final bool isOptional = true;
  final Map<String,dynamic> extensions = new Map<String, dynamic>();
  
  WildCard({Map<String,dynamic> extensions}) : super() {
    if(extensions != null)
    {
      this.extensions.addAll(extensions);
    }
  }
  
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

class Variable extends PathPart implements VariableInfo {
  
  final String name;
  final bool isOptional;
  final Map<String,dynamic> extensions = new Map<String, dynamic>();
  
  Variable(this.name, {bool isOptional: false, Map<String,dynamic> extensions}) : this.isOptional = isOptional, super() {
    if(extensions != null)
    {
      this.extensions.addAll(extensions);
    }
  }
  
  void CheckUsage(Url currentRoute) {
    
  }
  
  String toString() {
    var config = new UrlDefConfig.Current();
    
    var partStr = config.RoutePartVariableStart + this.name + config.RoutePartVariableEnd;
    if(this.isOptional)
    {
      partStr = config.RoutePartVariableOptionalStart + partStr + config.RoutePartVariableOptionalEnd;
    }
    
    return partStr;
  }
}
