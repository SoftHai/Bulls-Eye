part of softhai.bulls_eye.Common;

typedef Variable TryParseSpecialVariable(String rawStr, String cleanStr, bool isOptional, UrlDefConfig currentConfig, Url currentRoute);

class UrlDefConfig {

  final String RoutePartSeperator = "/";
  final String RoutePartQueryStart = "?";
  final String RoutePartQuerySeperator = "&";
  
  final String RoutePartVariableOptionalStart;
  final String RoutePartVariableOptionalEnd;
  final String RoutePartVariableStart;
  final String RoutePartVariableEnd;
  final String RoutePartWildCard;
  
  List<TryParseSpecialVariable> specialVariableParsers = new List<TryParseSpecialVariable>(); 
  
  static UrlDefConfig _config = null;

  UrlDefConfig.Costumize(this.RoutePartVariableStart, this.RoutePartVariableEnd, this.RoutePartVariableOptionalStart, this.RoutePartVariableOptionalEnd, this.RoutePartWildCard) {
    _config = this;
  }
  
  factory UrlDefConfig.SetToDefault() 
  {
    _config = new UrlDefConfig.Costumize(":", "", "(", ")", "*"); // Default Config
    
    return _config;
  }  
  
  factory UrlDefConfig.Current() 
  {
    if(_config == null)
    {
      _config = new UrlDefConfig.SetToDefault();
    }
    
    return _config;
  }  

  void RegisterSpecialVariableParser(TryParseSpecialVariable parseFunc)
  {
    this.specialVariableParsers.add(parseFunc);
  }
}