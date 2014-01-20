part of softhai.bulls_eye.Server;

typedef Future _MidChThan(ReqResContext context);
typedef bool _MidChOnError(ReqResContext context, Object error);

class _MiddlewareChannelPart extends MiddlewareController {
    
  _MidChThan _then;
  _MidChOnError _onError;
  ReqResContext _context;
  
  List<MiddlewareBefore> beforeChannel = new List<MiddlewareBefore>();
  List<MiddlewareAfter> afterChannel = new List<MiddlewareAfter>();
  MiddlewareAround aroundEndpoint;
  
  Future execute(ReqResContext context) {
    
    this._context = context;
    
    //return this._nextBefore(0);
    
    return Future.forEach(this.beforeChannel, (before) => before(context))
        .then((_) {
        if(this.aroundEndpoint != null)
        {
          return this.aroundEndpoint(context, this);
        }
        else  
        {
          return this.next();
        }
    }).then((_) => Future.forEach(this.afterChannel.reversed, (after) => after(context)))
      .catchError((ex) => this._executeOnError(context, ex));
    
    /*
    // Execute before channel
    for(var before in this.beforeChannel) {
      
      
      try {
      
        var errorCatched = false;
        var errorContinue = false;
        var future = new Future.sync(() => before(context))
                               .catchError((ex) {
                                 errorCatched = true;
                                 errorContinue = this._executeOnError(context, ex); 
                               });
        
        if(errorCatched && errorContinue != true) return;
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
        var errorCatched = false;
        var errorContinue = false;
        var future = new Future.sync(() => after(context))
                               .catchError((ex) {
                                 errorCatched = true;
                                 errorContinue = this._executeOnError(context, ex); 
                               });
        
        if(errorCatched && errorContinue != true) return;
      }
      catch (ex) {
        var errorContinue = this._executeOnError(context, ex);
        if(errorContinue != true) return;
      }
    }
    */
  }
  
  void then(_MidChThan func) {
    this._then = func;
  }
  
  void onError(_MidChOnError func) {
    this._onError = func;
  }
  
  Future next() {
    if(this._then != null)
    {
      return new Future.sync(() => this._then(this._context));
    }
  }
  
  /*
  Future _nextBefore(int index) {
    
    if(index < this.beforeChannel.length)
    {
      var before = this.beforeChannel[index];
      
      return new Future.sync(() => before(this._context))
                              .then((_) => this._nextBefore(index+1))
                              .catchError((ex) => this._executeOnError(this._context, ex));
      
    }
    else {
      return this._nextAround();
    }
    
  }
  
  Future _nextAround() {
    
    return new Future.sync(() {
                              if(this.aroundEndpoint != null)
                              {
                                return this.aroundEndpoint(this._context, this);
                              }
                              else
                              {
                                return this.next();
                              }
                            })
                            .then((_) {
                              this._nextAfter(this.afterChannel.length-1);
                            })
                            .catchError((ex) {
                              this._executeOnError(this._context, ex); 
                            });
    
  }
  
  Future _nextAfter(int index) {
    
    if(index >= 0)
    {
      var after = this.afterChannel[index];
      
      return new Future.sync(() => after(this._context))
                              .then((_) => this._nextAfter(index-1))
                              .catchError((ex) => this._executeOnError(this._context, ex));
      
    }
    else {
      return null;
    }
    
  }
  */
  
  
  bool _executeOnError(ReqResContext context, Object catchedError) {
    
    if(this._onError != null)
    {
      return this._onError(context, catchedError);
    }
    
    return false;
  }
  
}