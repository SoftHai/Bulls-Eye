part of softhai.bulls_eye.Server;

typedef void _MidChThan(ReqResContext context);
typedef bool _MidChOnError(ReqResContext context, Object error);

class _MiddlewareChannelPart extends MiddlewareController {
  
  _MidChThan _then;
  _MidChOnError _onError;
  ReqResContext _context;
  
  List<MiddlewareBefore> beforeChannel = new List<MiddlewareBefore>();
  List<MiddlewareAfter> afterChannel = new List<MiddlewareAfter>();
  MiddlewareAround aroundEndpoint;
  
  void execute(ReqResContext context) {
    
    this._context = context;
    
    // Execute before channel
    for(var before in this.beforeChannel) {
      try {
        before(context);
      }
      catch (ex) {
        var errorContinue = this._executeOnError(context, ex);
        if(errorContinue != true) return;
      }
    }
    
    // Execute around or next channel
    try {
      if(this.aroundEndpoint != null)
      {
        this.aroundEndpoint(context, this);
      }
      else
      {
        this.next();
      }
    }
    catch (ex) {
      var errorContinue = this._executeOnError(context, ex);
      if(errorContinue != true) return;
    }
    
    // Execute after channel
    for(var after in this.afterChannel.reversed) {
      try {
        after(context);
      }
      catch (ex) {
        var errorContinue = this._executeOnError(context, ex);
        if(errorContinue != true) return;
      }
    }
    
  }
  
  void then(_MidChThan func) {
    this._then = func;
  }
  
  void onError(_MidChOnError func) {
    this._onError = func;
  }
  
  void next() {
    if(this._then != null)
    {
      this._then(this._context);
    }
  }
  
  bool _executeOnError(ReqResContext context, Object catchedError) {
    
    if(this._onError != null)
    {
      return this._onError(context, catchedError);
    }
    
    return false;
  }
  
}