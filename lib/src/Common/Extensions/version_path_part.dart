part of softhai.bulls_eye.Common;

class Version extends Variable {

  static String routePartVariableVersion = "Version";

  Version() : super(routePartVariableVersion, false) 
  {
    RegisterParseFunc();
  }
  
  void CheckUsage(Url currentRoute) 
  {
    if(currentRoute.routeParts.where((part) => part is Version).length > 1) throw new MultipleVersionException(currentRoute);
  }
  
  static Variable _TryParse(String rawStr, String cleanStr, bool isOptional, UrlDefConfig currentConfig, Url currentRoute) {
    
    if(cleanStr == routePartVariableVersion && !isOptional)
    {
      if(currentRoute.routeParts.where((part) => part is Version).length > 0) throw new MultipleVersionException(currentRoute);

      return new Version();
    }
    
    return null;
  }
  
  static void RegisterParseFunc()
  {
    var config = new UrlDefConfig.Current();
    if(!config.specialVariableParsers.contains(_TryParse))
    {
      config.RegisterSpecialVariableParser(_TryParse);
    }
  }
}

class MultipleVersionException implements Exception {

  Url _routeDefinition;
  
  MultipleVersionException(this._routeDefinition);
  
  String toString() {
    return "Multible Version Definition in Route: " + this._routeDefinition.name;
  }
}