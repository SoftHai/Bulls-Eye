part of softhai.bulls_eye.Server;

class Validation implements BeforeHook {
  
  Future before(ReqResContext context) {
      
    var versionValue = common.ValidatorByVersion.defaultVersionValidator;
    var version = context.request.url.variables.path.firstWhere((v) => v.variable is common.Version, orElse: () => null);
    if(version != null)
    {
      versionValue = version.value;
    }
    
    this._validateVariables(context.request.url.variables.path, context, versionValue);
    
    this._validateVariables(context.request.url.variables.query, context, versionValue);
  }
  
  void _validateVariables(ReadOnlyMap<UrlInputData> variables, ReqResContext context, String versionValue) {

    for(var urlInputData in variables) {
      
      var validator = urlInputData.variable.extensions[common.ValidatorKey] as common.Validator;
      if(validator != null) {
        
        var data = urlInputData.value;
        if(validator is common.ValidatorByVersion) {
          if(!(validator as common.ValidatorByVersion).isValid(data, versionValue)) {
            throw new VariableValidationException(context, "The variable '${urlInputData.key}' is not valid", urlInputData.variable);
          }
        }
        else if(!validator.isValid(data)) {
          throw new VariableValidationException(context, "The variable '${urlInputData.key}' is not valid", urlInputData.variable);
        }
      }
    }
  }
  
}