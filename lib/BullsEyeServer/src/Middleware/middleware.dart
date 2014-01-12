part of softhai.bulls_eye.Server;

typedef void _MiddlewareThan(ReqResContext context);

typedef void MiddlewareBefore(ReqResContext context);
typedef void MiddlewareAfter(ReqResContext context);
typedef void MiddlewareAround(ReqResContext context, MiddlewareController midCtrl);

typedef bool MiddlewereOnError(ReqResContext context, MiddlewareError error);

abstract class MiddlewareController {
  void next();
}

abstract class Middleware {
  
  void before(MiddlewareBefore func);
  
  void after(MiddlewareAfter func);
  
  void around(MiddlewareAround func);
  
  void onError(MiddlewereOnError func);
}

class _MiddlewareImpl implements Middleware  {
  
  MiddlewereOnError _errorHandler;
  _MiddlewareThan _thenHandler;
  List<_MiddlewareChannelPart> _channel = new List<_MiddlewareChannelPart>();
  
  String name;
  
  _MiddlewareImpl(this.name, this._errorHandler);
  
  void execute(ReqResContext context, _MiddlewareThan thenFunc) {
    this._thenHandler = thenFunc;
    
    var first = this._channel.first;
    if(first != null)
    {
      first.execute(context);
    }
  }
  
  void before(MiddlewareBefore func) {
    var part = this._nextPart();
    part.beforeChannel.add(func);
  }
  
  void after(MiddlewareAfter func) {
    var part = this._nextPart();
    part.afterChannel.add(func);
  }
  
  void around(MiddlewareAround func) {
    var part = this._nextPart();
    part.aroundEndpoint = func;
  }
  
  void onError(MiddlewereOnError func) {
    this._errorHandler = func;
  }
  
  _MiddlewareChannelPart _nextPart() {
    
    var last = this._channel.last;
    if(last != null) {
      if(last.aroundEndpoint != null) {
        // Not finalized, return
        return last;
      }
      else {
        // Create new part
        var newPart = new _MiddlewareChannelPart();
        newPart.onError(this._handleChannelPartError);
        newPart.then(this._handleChannelPartThen);
            
        this._channel.add(newPart);
        
        // Connect the part before with the new one
        last.then(newPart.execute);
      }
    }
    else {
      // Create new part
      var newPart = new _MiddlewareChannelPart();
      newPart.onError(this._handleChannelPartError);
      newPart.then(this._handleChannelPartThen);
      
      this._channel.add(newPart);
      
      return newPart;
    }
    
  }
  
  void _handleChannelPartThen(ReqResContext context) {
    this._thenHandler(context);
  }
  
  bool _handleChannelPartError(ReqResContext context, Object error) {
    return this._errorHandler(context, new MiddlewareError(this.name, error));
  }
}
