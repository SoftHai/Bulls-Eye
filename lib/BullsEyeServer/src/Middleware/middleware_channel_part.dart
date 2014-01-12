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
        if(!this._executeOnError(ex)) return;
      }
    }
    
    // Execute around or next channel
    try {
      if(this.aroundEndpoint != null)
      {
        this.aroundEndpoint(context);
      }
      else
      {
        this.next();
      }
    }
    catch (ex) {
      if(!this._executeOnError(ex)) return;
    }
    
    // Execute after channel
    for(var after in this.afterChannel) {
      try {
        after(context);
      }
      catch (ex) {
        if(!this._executeOnError(ex)) return;
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
  
  bool _executeOnError(Object catchedError) {
    
    if(this._onError != null)
    {
      return this._onError(catchedError);
    }
    
    return false;
  }
  
}