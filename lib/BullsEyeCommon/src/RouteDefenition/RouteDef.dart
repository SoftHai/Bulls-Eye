part of softhai.bulls_eye.Common;

class RouteDef {
  
  String name;
  UriMatcher matcher;
  RouteDefConfig config = new RouteDefConfig.Current();
  List<RoutePart> routeParts = new List<RoutePart>();
  
  RouteDef(String routeString, [String name]) {
    var x = 10;
    if(routeString.contains("{"))
    {
      x += 10;
    }
    
    this.name = name == null ? routeString : name;
    var parts = routeString.split(this.config.RoutePartSeperator);
    this._initFromStrings(parts);
    this.matcher = new UriMatcher(this);
  }
  
  RouteDef.fromObjects(this.routeParts, [String name]) {
    this.name = name == null ? this.routeParts.join(this.config.RoutePartSeperator) : name;
    
    // Check if multiple Version-Elements are defined
    this.routeParts.forEach((part) 
        { 
          if(part is Variable) 
          {
            var variable = part as Variable;
            variable.CheckUsage(this);
          }
        });
    
    this.matcher = new UriMatcher(this);
  }
  
  RouteDef.fromMixed(List<String> parts, [String name]) {
    this.name = name == null ? parts.join(this.config.RoutePartSeperator) : name;
    this._initFromStrings(parts);
  }
  
  void _initFromStrings(List<String> parts)
  {
    parts.forEach((part) 
        {
          if(part == this.config.RoutePartWildCard)
          {
            this.routeParts.add(new WildCard());
          }
          else if((part.startsWith(this.config.RoutePartVariableOptionalStart) && part.endsWith(this.config.RoutePartVariableOptionalEnd))||
                  (part.startsWith(this.config.RoutePartVariableStart) && part.endsWith(this.config.RoutePartVariableEnd)))
          {
            // Check if special variable
            bool isSpecialVar = false;
            for(var parseFunc in this.config.specialVariableParsers)
            {
              var value = parseFunc(part, this.config, this);
              if(value != null)
              {
                this.routeParts.add(value);
                isSpecialVar = true;
                break;
              }
            }
            
            // Variable
            if(!isSpecialVar)
            {
              bool isOptinal = false;
              var clean = part;
              
              // Check if Optional
              if(part.startsWith(this.config.RoutePartVariableOptionalStart) && part.endsWith(this.config.RoutePartVariableOptionalEnd))
              {
                isOptinal = true;
                clean = clean.replaceAll(this.config.RoutePartVariableOptionalStart, "")
                             .replaceAll(this.config.RoutePartVariableOptionalEnd, "");
              }
              
              // Clean Variable
              clean = clean.replaceAll(this.config.RoutePartVariableStart, "")
                           .replaceAll(this.config.RoutePartVariableEnd, "");
              
              this.routeParts.add(new Variable(clean, isOptinal));
            }
          }
          else
          {
            // StaticPart
            this.routeParts.add(new Static(part));
          }
        });
  }
  
  String toString() 
  {
    String route = this.routeParts.join(this.config.RoutePartSeperator);
    return route;
  }
}

