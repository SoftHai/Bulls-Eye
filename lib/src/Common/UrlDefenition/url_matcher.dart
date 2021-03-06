part of softhai.bulls_eye.Common;

class UrlMatcher {
  
  RegExp _regex;
  List<_VariableManager<VariableInfo>> _routeVars;
  List<_VariableManager<VariableInfo>> _queryVars;
  Url routeDef; 
  
  bool hasOptionalVariables = false;
  
  UrlMatcher(this.routeDef)
  {
    this.hasOptionalVariables = this.routeDef.pathParts.where((part) => part is Variable && (part as Variable).isOptional).length > 0 ||
                                this.routeDef.queryParts.where((part) => part is QVariable && (part as QVariable).isOptional).length > 0; 
    
    this._initUriMatcher();
  }
  
  void _initUriMatcher()
  {
    this._routeVars = new List<_VariableManager<VariableInfo>>();
    this._queryVars = new List<_VariableManager<VariableInfo>>();
    var routeVars = this.routeDef.pathParts.where((part) => part is VariableInfo).toList();
  
    if(this.hasOptionalVariables)
    {
      // Build a individual regex for each variable (reqiured if optional part are available)
      routeVars.forEach((vpart) {
          String regExpStr = this._buildRegExp(vpart);

          this._routeVars.add(new _VariableManager<VariableInfo>(new RegExp(regExpStr), vpart));
        });
      
      this.routeDef.queryParts.forEach((vpart) {
        String regExpStr = this._buildRegExp(vpart);
        
        this._queryVars.add(new _VariableManager<VariableInfo>(new RegExp(regExpStr), vpart));
      });
    }
    else
    {
      // No induvidual regex required
      routeVars.forEach((vpart) { _routeVars.add(new _VariableManager<VariableInfo>(null, vpart)); });
      
      this.routeDef.queryParts.forEach((vpart) { _queryVars.add(new _VariableManager<VariableInfo>(null, vpart)); });
    }
    
    // Build a single regex for the whole path
    String regExpStr = this._buildRegExp();
    
    this._regex = new RegExp(regExpStr);
  }
  
  bool match(String path)
  {
    return this._regex.hasMatch(path);
  }
  
  UriMatcherResult getMatches(String path)
  {   
    Map<VariableInfo,String> routeResult = new Map<VariableInfo,String>();
    Map<VariableInfo,String> queryResult = new Map<VariableInfo,String>();
    
    if(this.hasOptionalVariables)
    {
      // Route Variables
      this._routeVars.forEach((vm) {
            var m = vm.regEx.allMatches(path);
            var match = m.elementAt(0);
            if(match.groupCount == 1 && match[1].isNotEmpty)
            {
              routeResult[vm.variable] = match[1];
            }
            else if(vm.variable.isOptional)
            {
              routeResult[vm.variable] = null;
            }
          });
      
      // Query Variables
      this._queryVars.forEach((vm) {
        var m = vm.regEx.allMatches(path);
        var match = m.elementAt(0);
        if(match.groupCount == 1 && match[1] != null && match[1].isNotEmpty)
        {
          queryResult[vm.variable] = match[1];
        }
        else if(vm.variable.isOptional)
        {
          queryResult[vm.variable] = null;
        }
      });
    }
    else 
    {
      var m = this._regex.allMatches(path);
      if(m.length > 0)
      {
        var match = m.elementAt(0);
        if(match.groupCount == (this._routeVars.length + this._queryVars.length))
        {
          int globalI = 0;
          // Route Variables
          for(int i = 0; i < this._routeVars.length; i++)
          {
            routeResult[this._routeVars[i].variable] = match[i+1];
            globalI = i+1;
          }
          
          // Query Variable
          for(int i = 0; i < this._queryVars.length; i++)
          {
            queryResult[this._queryVars[i].variable] = match[globalI+i+1];
          }
        }
      }
    }
    
    return new UriMatcherResult(routeResult, queryResult);
  }
  
  String replace(Map<String,Object> values)
  {
    String path = this.routeDef.toString();
    
    for(int i = 0; i < values.length; i++)
    {
      var variableName = values.keys.elementAt(i);
      if(variableName == this.routeDef.config.RoutePartWildCard)
      {
        // Wildcard
        path = path.replaceFirst(this.routeDef.config.RoutePartWildCard, values[variableName].toString());
      }
      else
      {
        var routeVarMang = this._routeVars.firstWhere((v) => v.variable.name == variableName, orElse: () => null);
        var queryVarMang = this._queryVars.firstWhere((v) => v.variable.name == variableName, orElse: () => null);
        
        if(routeVarMang != null)
        {
          path = path.replaceFirst(routeVarMang.variable.toString(), values[variableName].toString());
        }
        else if (queryVarMang != null)
        {
          var varName = queryVarMang.variable.name;
          var varValue = values[variableName];
          path = path.replaceFirst(queryVarMang.variable.toString(), "$varName=$varValue");
        }
      }
    }
    // Remove all Left Optional Variable-Placeholder
    this._routeVars.where((v) => v.variable.isOptional).forEach((vm) => path = path.replaceAll(this.routeDef.config.RoutePartSeperator + vm.variable.toString(), ""));
    this._queryVars.where((v) => v.variable.isOptional).forEach((vm) => path = path.replaceAll(this.routeDef.config.RoutePartQuerySeperator + vm.variable.toString(), ""));

    // Remove the WildCard sign, if not replaced before
    path = path.replaceAll(this.routeDef.config.RoutePartWildCard, "");

    return path;
  }

  String _buildRegExp([Object currentVar])
  {
    String regExpStr = r"^.*\" + this.routeDef.config.RoutePartSeperator + "?";
    this.routeDef.pathParts.forEach((part) {
      var vpart = currentVar == null ? part : currentVar;
      
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
      
      this.routeDef.queryParts.forEach((part) {
        var qpart = currentVar == null ? part : currentVar;
        
        if(part is QVariable)
        {
          var v = part as QVariable;
          regExpStr += v.isOptional ? "?" : "";
          if(qpart == v)
          {
            regExpStr += (v.isOptional ? "(?:" : "") + v.name + r"=([^\&]*)" + (v.isOptional ? ")?" : "");
          }
          else
          {
            regExpStr += (v.isOptional ? "(?:" : "") + v.name + r"=[^\&]*" + (v.isOptional ? ")?" : "");
          }
        }
        
        regExpStr += r"\" + this.routeDef.config.RoutePartQuerySeperator;
      });
      
      regExpStr += r"?";
    }
    
    regExpStr += r"$";
    
    return regExpStr;
  }
  
}

class _VariableManager<VarType> {
  final RegExp regEx;
  final VarType variable;
  
  const _VariableManager(this.regEx, this.variable);
}

class UriMatcherResult {
  
  UriVariableResult<VariableInfo> routeVariables;
  UriVariableResult<VariableInfo> queryVariables;
  
  UriMatcherResult(Map<VariableInfo,String> routeResult, Map<VariableInfo,String> queryResult) {
    this.routeVariables = new UriVariableResult<VariableInfo>(routeResult); 
    this.queryVariables = new UriVariableResult<VariableInfo>(queryResult); 
  }
}

class UriVariableResult<VarType> {
  
  final Map<VarType,String> result;
  
  const UriVariableResult(this.result);
  
  String operator [](String varName) {
    return this.result[this.result.keys.firstWhere((v) => v.name == varName, orElse: () => null)];
  }
  
  VarType getVariable(String varName) {
    return this.result.keys.firstWhere((v) => v.name == varName, orElse: () => null);
  }
  
  Map<VarType, String> getVariables() {
    return this.result;
  }
}
