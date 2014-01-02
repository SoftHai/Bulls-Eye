part of softhai.bulls_eye.Common;

class RouteDefConfig {

  final String RoutePartSeperator = "/";
  final String RoutePartVariableOptionalStart = "(";
  final String RoutePartVariableOptionalEnd = ")";
  final String RoutePartVariableStart = ":";
  final String RoutePartVariableEnd = "";
  final String RoutePartVariableVersion = "Version";
  final String RoutePartWildCard = "*";
  
  static RouteDefConfig _config = null;
  
  RouteDefConfig._default();
  
  factory RouteDefConfig.Current() 
  {
    if(_config == null)
    {
      _config = new RouteDefConfig._default();
    }
    
    return _config;
  }  
}