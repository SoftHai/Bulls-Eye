part of softhai.bulls_eye.Server;

class _MiddlewareChannelPart extends MiddlewareController {
    
  _ThanFunc _then;
  ReqResContext _context;
  
  List<BeforeHook> beforeChannel = new List<BeforeHook>();
  List<AfterHook> afterChannel = new List<AfterHook>();
  AroundHook aroundHook;
  
  Future execute(ReqResContext context) {
    
    this._context = context;
    
    return Future.forEach(this.beforeChannel, (hook) => hook.before(context))
        .then((_) {
        if(this.aroundHook != null)
        {
          return this.aroundHook.around(context, this);
        }
        else  
        {
          return this.next();
        }
    }).then((_) => Future.forEach(this.afterChannel.reversed, (hook) => hook.after(context)));
    
  }
  
  void then(_ThanFunc func) {
    this._then = func;
  }
  
  Future next() {
    if(this._then != null)
    {
      return new Future.sync(() => this._then(this._context));
    }
  }
}