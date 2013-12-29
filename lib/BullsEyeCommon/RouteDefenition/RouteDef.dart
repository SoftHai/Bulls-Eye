part of softhai.bulls_eye.Common;

class RouteDef {
  
  String name;
  UriMatcher matcher;
  RouteDefConfig config = new RouteDefConfig.Current();
  List<RoutePart> routeParts = new List<RoutePart>();
  
  RouteDef(String routeString, [String name]) {
    this.name = name == null ? routeString : name;
    var parts = routeString.split(this.config.RoutePartSeperator);
    this._initFromStrings(parts);
    this.matcher = new UriMatcher(this);
  }
  
  RouteDef.fromObjects(this.routeParts, [String name]) {
    this.name = name == null ? this.routeParts.join(this.config.RoutePartSeperator) : name;
    
    // Check if multiple Version-Elements are defined
    bool versionAvailable = false; 
    this.routeParts.forEach((part) 
        { 
          if(part is Version || (part is Variable && (part as Variable).varName == this.config.RoutePartVariableVersion)) 
          {
            if(versionAvailable)
            {
              throw new MultipleVersionException(this);
            }
            
            versionAvailable = true;
          }
        });
    
    this.matcher = new UriMatcher(this);
  }
  
  RouteDef.fromStrings(List<String> parts, [String name]) {
    this.name = name == null ? parts.join(this.config.RoutePartSeperator) : name;
    this._initFromStrings(parts);
  }
  
  void _initFromStrings(List<String> parts)
  {
    bool versionAdded = false; 
    
    parts.forEach((part) 
        {
          if(part == this.config.RoutePartWildCard)
          {
            this.routeParts.add(new WildCard());
          }
          else if((part.startsWith(this.config.RoutePartVariableOptionalStart) && part.endsWith(this.config.RoutePartVariableOptionalEnd))||
                  (part.startsWith(this.config.RoutePartVariableStart) && part.endsWith(this.config.RoutePartVariableEnd)))
          {
            // Variable
            if(part == this.config.RoutePartVariableStart + this.config.RoutePartVariableVersion + this.config.RoutePartVariableEnd)
            {
              // Version Variable
              if(!versionAdded) {
                // First Version
                this.routeParts.add(new Version());
                versionAdded = true;
              }
              else
              {
                // Multible versions defined, not allowed
                throw new MultipleVersionException(this);
              }
            }
            else
            {
              // Custom Variable
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

