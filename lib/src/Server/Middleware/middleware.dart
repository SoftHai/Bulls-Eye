part of softhai.bulls_eye.Server;

typedef Future _ThanFunc(ReqResContext context);

typedef Future BeforeFunc(ReqResContext context);
typedef Future AfterFunc(ReqResContext context);
typedef Future AroundFunc(ReqResContext context, MiddlewareController midCtrl);

typedef bool MiddlewareOnErrorFunc(ReqResContext context, MiddlewareError error);

abstract class MiddlewareHook {
  
}

abstract class BeforeHook implements MiddlewareHook {
  Future before(ReqResContext context);
}

abstract class AfterHook implements MiddlewareHook {
  Future after(ReqResContext context);
}

abstract class AroundHook implements MiddlewareHook {
  Future around(ReqResContext context, MiddlewareController midCtrl);
}

abstract class MiddlewareController {
  Future next();
}

abstract class Middleware {
  
  void add(MiddlewareHook hook);
  
  void before(BeforeFunc func);
  
  void after(AfterFunc func);
  
  void around(AroundFunc func);
  
  void onError(MiddlewareOnErrorFunc func);
}
