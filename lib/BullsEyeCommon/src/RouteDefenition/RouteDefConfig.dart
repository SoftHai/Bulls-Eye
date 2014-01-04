part of softhai.bulls_eye.Common;

typedef Variable TryParseSpecialVariable(String partStr, RouteDefConfig currentConfig, RouteDef currentRoute);

class RouteDefConfig {

  final String RoutePartSeperator;
  final String RoutePartVariableOptionalStart;
  final String RoutePartVariableOptionalEnd;
  final String RoutePartVariableStart;
  final String RoutePartVariableEnd;
  final String RoutePartWildCard;
  
  List<TryParseSpecialVariable> specialVariableParsers = new List<TryParseSpecialVariable>(); 
  
  static RouteDefConfig _config = null;

  RouteDefConfig.Costumize(this.RoutePartSeperator, this.RoutePartVariableStart, this.RoutePartVariableEnd, this.RoutePartVariableOptionalStart, this.RoutePartVariableOptionalEnd, this.RoutePartWildCard) {
    _config = this;
  }
  
  factory RouteDefConfig.Current() 
  {
    if(_config == null)
    {
      _config = new RouteDefConfig.Costumize("/", ":", "", "(", ")", "*"); // Default Config
    }
    
    return _config;
  }  

  void RegisterSpecialVariableParser(TryParseSpecialVariable parseFunc)
  {
    this.specialVariableParsers.add(parseFunc);
  }
}