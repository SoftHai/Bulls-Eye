part of softhai.bulls_eye.Server;

class _BeforeImpl implements BeforeHook {
  
  BeforeFunc _before;
  
  _BeforeImpl(this._before);
  
  Future before(ReqResContext context) {
    return this._before(context);
  }
}

class _AfterImpl implements AfterHook {
  
  AfterFunc _after;
  
  _AfterImpl(this._after);
  
  Future after(ReqResContext context) {
    return this._after(context);
  }
}

class _AroundImpl implements AroundHook {
  
  AroundFunc _around;
  
  _AroundImpl(this._around);
  
  Future around(ReqResContext context, MiddlewareController midCtrl) {
    return this._around(context, midCtrl);
  }
}

class _MiddlewareImpl implements Middleware  {
  
  MiddlewareOnErrorFunc _errorHandler;
  _ThanFunc _thenHandler;
  List<_MiddlewareChannelPart> _channel = new List<_MiddlewareChannelPart>();
  
  String name;
  
  _MiddlewareImpl(this.name);
  
  Future execute(ReqResContext context, _ThanFunc thenFunc) {
    this._thenHandler = thenFunc;
    
    var first = this._channel.first;
    if(first != null)
    {
      return first.execute(context).catchError((ex) => this._handleChannelPartError(context, ex));
    }
  }
  
  void add(MiddlewareHook hook) {
    var part = this._nextPart();
    if(hook is BeforeHook) {
      part.beforeChannel.add(hook);
    }
    else if(hook is AfterHook) {
      part.afterChannel.add(hook);
    }
    else if (hook is AroundHook) {
      part.aroundHook = hook;
    }
  }
  
  void before(BeforeFunc func) {
    var part = this._nextPart();
    part.beforeChannel.add(new _BeforeImpl(func));
  }
  
  void after(AfterFunc func) {
    var part = this._nextPart();
    part.afterChannel.add(new _AfterImpl(func));
  }
  
  void around(AroundFunc func) {
    var part = this._nextPart();
    part.aroundHook = new _AroundImpl(func);
  }
  
  void onError(MiddlewareOnErrorFunc func) {
    this._errorHandler = func;
  }
  
  _MiddlewareChannelPart _nextPart() {
    
    _MiddlewareChannelPart last = null;
    if(this._channel.length > 0) {
      last = this._channel.last;
    }
    
    if(last != null) {
      if(last.aroundHook == null) {
        // Not finalized, return
        return last;
      }
      else {
        // Create new part
        var newPart = new _MiddlewareChannelPart();
        newPart.then(this._handleChannelPartThen);
            
        this._channel.add(newPart);
        
        // Connect the part before with the new one
        last.then(newPart.execute);
        
        return newPart;
      }
    }
    else {
      // Create new part
      var newPart = new _MiddlewareChannelPart();
      newPart.then(this._handleChannelPartThen);
      
      this._channel.add(newPart);
      
      return newPart;
    }
    
  }
  
  Future _handleChannelPartThen(ReqResContext context) {
    return this._thenHandler(context);
  }
  
  void _handleChannelPartError(ReqResContext context, Object error) {
    if(_errorHandler != null) {
      this._errorHandler(context, new MiddlewareError(this.name, error));
    }
    else {
      context.HandleError(new MiddlewareError(this.name, error));
    }
  }
}
