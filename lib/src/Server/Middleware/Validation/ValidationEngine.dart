part of softhai.bulls_eye.Server;

class Validation implements BeforeHook {
  
  Future before(ReqResContext context) {
      
      this._validateVariables(context.variables.routeVariables.getVariables(), context);
      
      this._validateVariables(context.variables.queryVariables.getVariables(), context);
  }
  
  void _validateVariables(Map<common.VariableInfo, String> variables, ReqResContext context) {
    var versionValue = common.ValidatorByVersion.defaultVersionValidator;
    var version = variables.keys.firstWhere((v) => v is common.Version, orElse: () => null);
    if(version != null)
    {
      versionValue = variables[version];
    }
    
    for(var variable in variables.keys) {
      
      var validator = variable.extensions[common.ValidatorKey] as common.Validator;
      if(validator != null) {
        
        var data = variables[variable];
        if(validator is common.ValidatorByVersion) {
          if(!(validator as common.ValidatorByVersion).isValid(data, versionValue)) {
            throw new VariableValidationException(context.request, "The variable '${variable.name}' is not valid", variable);
          }
        }
        else if(!validator.isValid(data)) {
          throw new VariableValidationException(context.request, "The variable '${variable.name}' is not valid", variable);
        }
      }
    }
  }
  
}