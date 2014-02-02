// thats the benchmarks for v0.2

library softhai.bulls_eye.Server;

import 'dart:io';
import 'dart:async';
import '../../lib/common.dart' as common;
import '../../Test/HttpMocks.dart';

import 'package:spec_dart/spec_dart.dart';

// Globals
part '../../lib/src/Server/req_res_context.dart';
part '../../lib/src/Server/Exceptions.dart';

// Middleware
part '../../lib/src/Server/Middleware/middleware.dart';
part '../../lib/src/Server/Middleware/middleware_impl.dart';
part '../../lib/src/Server/Middleware/middleware_channel_part.dart';
part '../../lib/src/Server/Middleware/middleware_error.dart';

// Routing
part '../../lib/src/Server/Routing/RouteManager.dart';
part '../../lib/src/Server/Routing/ExecuteCode.dart';
part '../../lib/src/Server/Routing/LoadFile.dart';
part '../../lib/src/Server/Routing/RoutingExceptions.dart';

Suite buildBenchmark() {
  
  var suite = Suite.create();
  suite.interations(5);

  suite.add("Middleware - Before Func")
            ..setUp(buildMiddleware_BeforeFunc)
            ..bench((context) => executeMiddleware(context, 1,0,1,0,0), name: "Successful", unit: MICROSECONDS)
            ..bench((context) => executeMiddleware(context, 1,0,0,0,0, exception:true), name: "Exception", unit: MICROSECONDS);

  suite.add("Middleware - Before Class")
            ..setUp(buildMiddleware_BeforeClass)
            ..bench((context) => executeMiddleware(context, 1,0,1,0,0), name: "Successful", unit: MICROSECONDS);
  
  suite.add("Middleware - After Func")
            ..setUp(buildMiddleware_AfterFunc)
            ..bench((context) => executeMiddleware(context, 0,0,1,0,1), name: "Successful", unit: MICROSECONDS)
            ..bench((context) => executeMiddleware(context, 0,0,0,0,0, exception:true), name: "Exception", unit: MICROSECONDS);

  suite.add("Middleware - After Class")
            ..setUp(buildMiddleware_AfterClass)
            ..bench((context) => executeMiddleware(context, 0,0,1,0,1), name: "Successful", unit: MICROSECONDS);
  
  suite.add("Middleware - Around Func")
            ..setUp(buildMiddleware_AroundFunc)
            ..bench((context) => executeMiddleware(context, 0,1,1,1,0), name: "Successful", unit: MICROSECONDS)
            ..bench((context) => executeMiddleware(context, 0,1,0,0,0, exception:true), name: "Exception", unit: MICROSECONDS);
  
  suite.add("Middleware - Around Class")
            ..setUp(buildMiddleware_AroundClass)
            ..bench((context) => executeMiddleware(context, 0,1,1,1,0), name: "Successful", unit: MICROSECONDS);
 
  suite.add("Middleware - Complex")
            ..setUp(buildMiddleware_Complex)
            ..bench((context) => executeMiddleware(context, 3,1,1,1,3), name: "Successful", unit: MICROSECONDS)
            ..bench((context) => executeMiddleware(context, 3,1,0,0,0, exception:true), name: "Exception", unit: MICROSECONDS);
  
  return suite;

}

class BeforeTest implements BeforeHook {
  SpecContext context;
  
  BeforeTest(this.context);
  
  Future before(reqRes) { 
    context.data["before"]++; }
}

class AfterTest implements AfterHook {
  SpecContext context;
  
  AfterTest(this.context);
  
  Future after(reqRes) { context.data["after"]++; }
}

class AroundTest implements AroundHook {
  SpecContext context;
  
  AroundTest(this.context);
  
  Future around(reqRes, ctrl) { 
    context.data["around_before"]++; // Before Code
    return ctrl.next().then((_) { 
      context.data["around_after"]++; //After Code
    });
  }
}

void executeMiddleware(context, int beforeCount, int aroundBeforeCount, int thenCount, int aroundAfterCount, int afterCount, {bool exception: false }) {  
  context.data["before"] = 0;
  context.data["around_before"] = 0;
  context.data["then"] = 0;
  context.data["around_after"] = 0;
  context.data["after"] = 0;
  
  var future = context.data["middleware"].execute(context.data["ReqRes"], (reqRes) { 
    if(exception) {
      throw "Exception in then";
    }
    else {
      context.data["then"]++; 
    }
  });
  
  future.then((_) {
    if(context.data["before"] != beforeCount) throw "Wrong before count - expected '$beforeCount' but was '${context.data["before"]}'";
    if(context.data["around_before"] != aroundBeforeCount) throw "Wrong around before count - expected '$aroundBeforeCount' but was '${context.data["around_before"]}'";
    if(context.data["then"] != thenCount) throw "Wrong then count - expected '$thenCount' but was '${context.data["then"]}'";
    if(context.data["around_after"] != aroundAfterCount) throw "Wrong around after count - expected '$aroundAfterCount' but was '${context.data["around_after"]}'";
    if(context.data["after"] != afterCount) throw "Wrong after count - expected '$afterCount' but was '${context.data["after"]}'";
  });
  
  return future;
}

bool createHttpRequest(SpecContext context) {
  var urlDef = new common.Url("/Part1/:var1/Part2/(:var2)", "Demo Route");
  var route = new RouteManager("GET", urlDef, new ExecuteCode((context) { return true; }), ["application/html"], null);
  var request = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["*/*"]);
  context.data["ReqRes"] = route.createContext(request, (ex) { });
}

void buildMiddleware_BeforeFunc(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.before((midContext) { context.data["before"]++; });
  context.data["middleware"] = middleware;
}

void buildMiddleware_BeforeClass(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.add(new BeforeTest(context));
  context.data["middleware"] = middleware;
}

void buildMiddleware_AfterFunc(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.after((midContext) { context.data["after"]++; });
  context.data["middleware"] = middleware;
}

void buildMiddleware_AfterClass(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.add(new AfterTest(context));
  context.data["middleware"] = middleware;
}

void buildMiddleware_AroundFunc(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.around((midContext, ctrl) { 
    context.data["around_before"]++; // Before Code
    return ctrl.next().then((_) { 
      context.data["around_after"]++; //After Code
    });
  });
  context.data["middleware"] = middleware;
}

void buildMiddleware_AroundClass(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.add(new AroundTest(context));
  context.data["middleware"] = middleware;
}

void buildMiddleware_Complex(context) {
  createHttpRequest(context);
  
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.before((midContext) { context.data["before"]++; });
  middleware.before((midContext) { context.data["before"]++; });
  middleware.after((midContext) { context.data["after"]++; });
  middleware.around((midContext, ctrl) { 
    context.data["around_before"]++;
    return ctrl.next()
               .then((_) => context.data["around_after"]++ );
  });
  middleware.before((midContext) { context.data["before"]++; });
  middleware.after((midContext) { context.data["after"]++; });
  middleware.after((midContext) { context.data["after"]++; });
  context.data["middleware"] = middleware;
}
