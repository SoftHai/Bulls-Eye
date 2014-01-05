part of softhai.bulls_eye.Common;

class UriMatcher {
  
  RegExp _regex;
  List<_VariableManager> _vars;
  RouteDef routeDef; 
  
  bool hasOptionalVariables = false;
  
  UriMatcher(this.routeDef)
  {
    this.hasOptionalVariables = this.routeDef.routeParts.where((part) => part is Variable && (part as Variable).isOptional).length > 0; 
    
    this._initUriMatcher();
  }
  
  void _initUriMatcher()
  {
    this._vars = new List<_VariableManager>();
    var vars = this.routeDef.routeParts.where((part) => part is Variable || part is WildCard).toList();
  
    if(this.hasOptionalVariables)
    {
      // Build a individual regex for each variable (reqiured if optional part are available)
      vars.forEach((vpart) {
          String regExpStr = r"^\" + this.routeDef.config.RoutePartSeperator + "?";
          this.routeDef.routeParts.forEach((part) 
              {
                if(part is Static)
                {
                  regExpStr += (part as Static).partName;
                }
                else if(part is Variable) // includes also the Version-Variable
                {
                  var v = part as Variable;
                  regExpStr += v.isOptional ? "?" : "";
                  
                  if(vpart == v)
                  {
                    regExpStr += r"([^\/]*)" + (v.isOptional ? "?" : "");
                  }
                  else
                  {
                    regExpStr += r"[^\/]*";
                  }
                  
                  //regExpStr += v.isOptional ? "?" : "";
                }
                else if(part is WildCard)
                {
                  if(vpart == part)
                  {
                    vpart = new Variable("*", true);
                    regExpStr += r"?(.*)";
                  }
                  else
                  {
                    regExpStr += r"?.*";
                  }
                }
                regExpStr += r"\" + this.routeDef.config.RoutePartSeperator;
              });
          regExpStr += r"?";
          
          if(this.routeDef.queryParts.length > 0) // Query Parts
          {
            regExpStr += r"\" + this.routeDef.config.RoutePartQueryStart;
            
            this.routeDef.queryParts.forEach((part) 
                {
              if(part is QVariable)
              {
                var v = part as QVariable;
                regExpStr += v.isOptional ? "?" : "";
                regExpStr += (v.isOptional ? "(?:" : "") + v.varName + r"=[^\&]*" + (v.isOptional ? ")?" : "");
              }
              
              regExpStr += r"\" + this.routeDef.config.RoutePartQuerySeperator;
                });
            
            regExpStr += r"?";
          }
          
          regExpStr += r"$";
          
          this._vars.add(new _VariableManager(new RegExp(regExpStr), vpart));
        });
    }
    else
    {
      // No induvidual regex required
      vars.forEach((vpart) { _vars.add(new _VariableManager(null, (vpart is Variable ? vpart : new Variable("*", true)))); });
    }
    
    // Build a single regex for the whole path
    String regExpStr = r"^\" + this.routeDef.config.RoutePartSeperator + "?";
    this.routeDef.routeParts.forEach((part)  // Route Parts
        {
          if(part is Static)
          {
            regExpStr += (part as Static).partName;
          }
          else if(part is Variable) // includes also the Version-Variable
          {
            var v = part as Variable;
            regExpStr += v.isOptional ? "?" : "";
            regExpStr += r"([^\/]*)" + (v.isOptional ? "?" : "");
          }
          else if(part is WildCard)
          {
            regExpStr += r"?(.*)";
          }
          
          regExpStr += r"\" + this.routeDef.config.RoutePartSeperator;
        });
    regExpStr += r"?";
    
    if(this.routeDef.queryParts.length > 0) // Query Parts
    {
      regExpStr += r"\" + this.routeDef.config.RoutePartQueryStart;
      
      this.routeDef.queryParts.forEach((part) 
          {
            if(part is QVariable)
            {
              var v = part as QVariable;
              regExpStr += v.isOptional ? "?" : "";
              regExpStr += (v.isOptional ? "(?:" : "") + v.varName + r"=([^\&]*)" + (v.isOptional ? ")?" : "");
            }
            
            regExpStr += r"\" + this.routeDef.config.RoutePartQuerySeperator;
          });
      
      regExpStr += r"?";
    }
    
    regExpStr += r"$";
    this._regex = new RegExp(regExpStr);
  }
  
  bool match(String path)
  {
    return this._regex.hasMatch(path);
  }
  
  UriMatcherResult getMatches(String path)
  {
    Map<Variable,String> result = new Map<Variable,String>();
    
    if(this.hasOptionalVariables)
    {
      this._vars.forEach((vm) {
            var m = vm.regEx.allMatches(path);
            var match = m.elementAt(0);
            if(match.groupCount == 1 && match[1].isNotEmpty)
            {
              result[vm.variable] = match[1];
            }
            else if(vm.variable.isOptional)
            {
              result[vm.variable] = null;
            }
          });
      return new UriMatcherResult(result);
    }
    else 
    {
      var m = this._regex.allMatches(path);
      var match = m.elementAt(0);
      if(match.groupCount == this._vars.length)
      {
        for(int i = 0; i < this._vars.length; i++)
        {
          result[this._vars[i].variable] = match[i+1];
        }
        return new UriMatcherResult(result);
      }
    }
    
    return null;
  }
  
  String replace(Map<String,Object> values)
  {
    String path = this.routeDef.toString();
    
    for(int i = 0; i < values.length; i++)
    {
      var variableName = values.keys.elementAt(i);
      var varMang = this._vars.firstWhere((v) => v.variable.varName == variableName);
      
      if(varMang != null)
      {
        path = path.replaceFirst(varMang.variable.toString(), values[variableName].toString());
      }
    }
    
    // Remove all Left Optional Variable-Placeholder
    this._vars.where((v) => v.variable.isOptional).forEach((vm) => path = path.replaceAll(this.routeDef.config.RoutePartSeperator + vm.variable.toString(), ""));
    
    // Remove the WildCard sign
    path = path.replaceAll(this.routeDef.config.RoutePartWildCard, "");

    return path;
  }
}

class _VariableManager {
  final RegExp regEx;
  final Variable variable;
  
  const _VariableManager(this.regEx, this.variable);
}

class UriMatcherResult {
  
  final Map<Variable,String> result;
  
  const UriMatcherResult(this.result);
  
  String operator [](String varName) {
    return this.result[this.result.keys.firstWhere((v) => v.varName == varName, orElse: () => null)];
  }
  
  Variable getVariable(String varName) {
    return this.result.keys.firstWhere((v) => v.varName == varName, orElse: () => null);
  }
}
