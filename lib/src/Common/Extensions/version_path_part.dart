part of softhai.bulls_eye.Common;

class Version extends Variable {

  static String pathPartVariableVersion = "Version";

  Version([Map<String,dynamic> extensions]) : super(pathPartVariableVersion, isOptional: false, extensions: extensions) 
  {
    RegisterParseFunc();
  }
  
  void CheckUsage(Url currentUrl) 
  {
    if(currentUrl.pathParts.where((part) => part is Version).length > 1) throw new MultipleVersionException(currentUrl);
  }
  
  static Variable _TryParse(String rawStr, String cleanStr, bool isOptional, UrlDefConfig currentConfig, Url currentUrl) {
    
    if(cleanStr == pathPartVariableVersion && !isOptional)
    {
      if(currentUrl.pathParts.where((part) => part is Version).length > 0) throw new MultipleVersionException(currentUrl);

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

  Url _urlDefinition;
  
  MultipleVersionException(this._urlDefinition);
  
  String toString() {
    return "Multible Version Definition in Route: " + this._urlDefinition.name;
  }
}