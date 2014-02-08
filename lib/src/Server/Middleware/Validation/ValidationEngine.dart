part of softhai.bulls_eye.Server;

class Validation implements BeforeHook {
  
  Future before(ReqResContext context) {
      
      this._validateVariables(context.variables.routeVariables.getVariables(), context);
      
      this._validateVariables(context.variables.queryVariables.getVariables(), context);
  }
  
  void _validateVariables(Map<dynamic, String> variables, ReqResContext context) {
    for(var variable in variables.keys) {
      
      var validator = variable.extensions[common.ValidatorKey] as common.Validator;
      if(validator != null) {
        
        var data = variables[variable];
        if(!validator.isValid(data)) {
          throw new VariableValidationException(context.request, "The variable '${variable.varName}' is not valid", variable);
        }
      }
    }
  }
  
}