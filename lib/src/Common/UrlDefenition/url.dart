part of softhai.bulls_eye.Common;

abstract class VariableInfo {
  
  final String name;
  final bool isOptional;
  final Map<String,dynamic> extensions;  
  
  VariableInfo._internal(this.name, this.isOptional, this.extensions);
}


class Url {
  
  String name;
  UrlMatcher matcher;
  UrlDefConfig config = new UrlDefConfig.Current();
  List<PathPart> pathParts = new List<PathPart>();
  List<QueryPart> queryParts = new List<QueryPart>();
  
  Url(String url, [String name]) {
    
    this.name = name == null ? url : name;

    this._parseRoute(url);
    
    this.matcher = new UrlMatcher(this);
  }
  
  Url.fromObjects(this.pathParts, {this.queryParts, String name}) {
    
    if(this.queryParts == null) this.queryParts = new List<QueryPart>();
    
    this.name = name == null ? this._buildUrl() : name;
    
    // Check if multiple Version-Elements are defined
    this.pathParts.forEach((part) 
        { 
          if(part is Variable) 
          {
            var variable = part as Variable;
            variable.CheckUsage(this);
          }
        });
    
    this.matcher = new UrlMatcher(this);
  }
  
  Url.fromMixed(List<Object> parts, {String name}) {
    
    parts.forEach((part) {
      if(part is String)
      {
        this._parseRoute(part);
      }
      else if (part is PathPart)
      {
        this.pathParts.add(part);
      }
      else if (part is QueryPart)
      {
        this.queryParts.add(part);
      }
      else
      {
        throw "Not allowed part in RouteDef.fromMixed";
      }
    });
    
    this.name = name == null ? this._buildUrl() : name;
    
    this.matcher = new UrlMatcher(this);
  }
  
  void _parseRoute(String routeString)
  {
    var parts = routeString.split(this.config.RoutePartSeperator);
    
    if(parts.length >= 1)
    {
      var lastParts = parts.last.split(this.config.RoutePartQueryStart);
      if(lastParts.length == 2)
      {
        // Query Parts available
        parts[parts.length-1] = lastParts[0]; // First Part is last route part
        var queryParts = lastParts[1].split(this.config.RoutePartQuerySeperator); // Second part is query part
        this._parseQueryParts(queryParts);
      }
    }
    
    this._parseRouteParts(parts);
  }
  
  void _parseRouteParts(List<String> parts)
  {
    parts.forEach(this._parseRoutePart);
  }
  
  void _parseRoutePart(String part)
  {
    if(part == this.config.RoutePartWildCard)
    {
      this.pathParts.add(new WildCard());
    }
    else if((part.startsWith(this.config.RoutePartVariableOptionalStart) && part.endsWith(this.config.RoutePartVariableOptionalEnd))||
        (part.startsWith(this.config.RoutePartVariableStart) && part.endsWith(this.config.RoutePartVariableEnd)))
    {
      bool isOptional = this._isOptionalVariable(part);
      var clean = this._cleanVariable(part);

      // Check if special variable
      bool isSpecialVar = false;
      for(var parseFunc in this.config.specialVariableParsers)
      {
        var value = parseFunc(part, clean, isOptional, this.config, this);
        if(value != null)
        {
          this.pathParts.add(value);
          isSpecialVar = true;
          break;
        }
      }
      
      // Variable
      if(!isSpecialVar)
      {
        this.pathParts.add(new Variable(clean, isOptional: isOptional));
      }
    }
    else
    {
      // StaticPart
      this.pathParts.add(new Static(part));
    }
  }
  
  void _parseQueryParts(List<String> parts) {
    
    parts.forEach(this._parseQueryPart);
  }
  
  void _parseQueryPart(String part)
  {
    bool isOptinal = this._isOptionalVariable(part);
    var clean = this._cleanVariable(part);
    
    this.queryParts.add(new QVariable(clean, isOptional: isOptinal));
  }
  
  bool _isOptionalVariable(String variable)
  {
    return variable.startsWith(this.config.RoutePartVariableOptionalStart) && variable.endsWith(this.config.RoutePartVariableOptionalEnd);
  }
  
  String _cleanVariable(String variable)
  {
    return variable.replaceAll(this.config.RoutePartVariableOptionalStart, "")
                   .replaceAll(this.config.RoutePartVariableOptionalEnd, "")
                   .replaceAll(this.config.RoutePartVariableStart, "")
                   .replaceAll(this.config.RoutePartVariableEnd, "");
  }
  
  String _buildUrl()
  {
    var url = this.pathParts.join(this.config.RoutePartSeperator);
    if(this.queryParts.length > 0)
    {
      url += this.config.RoutePartQueryStart + this.queryParts.join(this.config.RoutePartQuerySeperator);
    }
    
    return url;
  }
  
  String toString() 
  {
    return this.name;
  }
}

