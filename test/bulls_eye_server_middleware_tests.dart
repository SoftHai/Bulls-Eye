library softhai.bulls_eye.Server;

import 'dart:io';
import 'dart:async';
import '../lib/BullsEyeCommon/bulls_eye_common.dart' as common;
import 'HttpMocks.dart';

import 'package:unittest/unittest.dart';
import 'package:spec_dart/spec_dart.dart';

// Globals
part '../lib/BullsEyeServer/src/req_res_context.dart';
part '../lib/BullsEyeServer/src/Exceptions.dart';

// Middleware
part '../lib/BullsEyeServer/src/Middleware/middleware.dart';
part '../lib/BullsEyeServer/src/Middleware/middleware_channel_part.dart';
part '../lib/BullsEyeServer/src/Middleware/middleware_error.dart';

// Routing
part '../lib/BullsEyeServer/src/Routing/RouteManager.dart';
part '../lib/BullsEyeServer/src/Routing/ExecuteCode.dart';
part '../lib/BullsEyeServer/src/Routing/LoadFile.dart';
part '../lib/BullsEyeServer/src/Routing/RoutingExceptions.dart';

void main() {
  
  var feature = new Feature("Middleware", "With the middleware, developer can extract common code from the logic")
                    ..setUp(createHttpRequest); // Setup a mock http Reuqest object
  
  var storyMiddlewareCode = feature.story("Middleware functions", 
                            asA: "WebServer Developer", 
                            iWant: "to add middleware code before/after/around the route logic called", 
                            soThat: "I can control and/or manipulate the route executing and the input and/or output data");
  
  storyMiddlewareCode.scenario("Add logic before")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "is a middleware defenition with a before call", func: middlewareBeforeCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the before code was called before the logic", func: middlewareBeforeCheck);
 
  storyMiddlewareCode.scenario("Add logic after")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with a after call", func: middlewareAfterCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the after code was called after the logic", func: middlewareAfterCheck);

  storyMiddlewareCode.scenario("Add logic around")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with a around call", func: middlewareAroundCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the after code was called after the logic", func: middlewareAroundCheck);

  storyMiddlewareCode.scenario("Add complex middleware calls")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with a complex structure (Before, Before, Around, Before, Code, After, After, Arround, After)", func: middlewareComplexCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the call order is as expected", func: middlewareComplexCheck);

  var storyExceptionHandling = feature.story("Middleware exception", 
      asA: "WebServer Developer", 
      iWant: "to add exception handling code", 
      soThat: "I can handle the exceptions in a customized way");
  
  storyExceptionHandling.scenario("Exception in before call")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with an exception in an before call", func: middlewareExceptionBeforeCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the exception in the before call was handled", func: middlewareExceptionBeforeCheck);

  storyExceptionHandling.scenario("Exception in after call")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with an exception in an after call", func: middlewareExceptionAfterCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the exception in the after call was handled", func: middlewareExceptionAfterCheck);
  
  storyExceptionHandling.scenario("Exception in around call before the logic")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with an exception in an around call before the logic", func: middlewareExceptionAroundBeforeCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the exception in the around call was handled", func: middlewareExceptionAroundBeforeCheck);

  storyExceptionHandling.scenario("Exception in around call after the logic")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "a middleware defenition with an exception in an around call after the logic", func: middlewareExceptionAroundAfterCreate)
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the exception in the around call was handled", func: middlewareExceptionAroundAfterCheck);
  
  feature.run().then((v) { 
    if(!v) exitCode = 2; // Error
  });
}

// Common Test Functions
bool createCallCounter(SpecContext context) {
  context.data["CallCounter"] = 0;
}

bool createHttpRequest(SpecContext context) {
  var urlDef = new common.Url("/Part1/:var1/Part2/(:var2)", "Demo Route");
  var route = new RouteManager("GET", urlDef, new ExecuteCode((context) { return true; }), ["application/html"], null);
  var request = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["*/*"]);
  context.data["ReqRes"] = route.createContext(request);
}

Future executeMiddleware(SpecContext context) {
  return context.data["middleware"].execute(context.data["ReqRes"], (midContext) 
      { context.data["CodeCalled"] = ++context.data["CallCounter"]; });
}

// Middleware Before Test Code
bool middlewareBeforeCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { context.data["ErrorCalled"] = ++context.data["CallCounter"]; });
  middleware.before((midContext) { context.data["BeforeCodeCalled"] = ++context.data["CallCounter"]; });
  context.data["middleware"] = middleware;
}

bool middlewareBeforeCheck(SpecContext context) {
  expect(context.data["ErrorCalled"], isNull);
  expect(context.data["BeforeCodeCalled"], equals(1));
  expect(context.data["CodeCalled"], equals(2));
  return true;
}

// Middleware After Test Code
bool middlewareAfterCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { context.data["ErrorCalled"] = ++context.data["CallCounter"]; });
  middleware.after((midContext) { context.data["AfterCodeCalled"] = ++context.data["CallCounter"]; });
  context.data["middleware"] = middleware;
}

bool middlewareAfterCheck(SpecContext context) {
  expect(context.data["ErrorCalled"], isNull);
  expect(context.data["CodeCalled"], equals(1));
  expect(context.data["AfterCodeCalled"], equals(2));
  return true;
}

// Middleware Around Test Code
bool middlewareAroundCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { context.data["ErrorCalled"] = ++context.data["CallCounter"]; });
  middleware.around((midContext, ctrl) { 
    context.data["AroundBeforeCodeCalled"] = ++context.data["CallCounter"]; 
    ctrl.next();
    context.data["AroundAfterCodeCalled"] = ++context.data["CallCounter"]; 
  });
  context.data["middleware"] = middleware;
}

bool middlewareAroundCheck(SpecContext context) {
  expect(context.data["ErrorCalled"], isNull);
  expect(context.data["AroundBeforeCodeCalled"], equals(1)); 
  expect(context.data["CodeCalled"], equals(2));
  expect(context.data["AroundAfterCodeCalled"], equals(3));
  return true;
}

// Middleware Complex Test Code
bool middlewareComplexCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { context.data["ErrorCalled"] = ++context.data["CallCounter"]; });
  middleware.before((midContext) { context.data["Before1Called"] = ++context.data["CallCounter"]; });
  middleware.before((midContext) { context.data["Before2Called"] = ++context.data["CallCounter"]; });
  middleware.after((midContext) { context.data["After3Called"] = ++context.data["CallCounter"]; });
  middleware.around((midContext, ctrl) { 
    context.data["Around1BeforeCalled"] = ++context.data["CallCounter"]; 
    return ctrl.next()
               .then((_) => context.data["Around1AfterCalled"] = ++context.data["CallCounter"] );
  });
  middleware.before((midContext) { context.data["Before3Called"] = ++context.data["CallCounter"]; });
  middleware.after((midContext) { context.data["After2Called"] = ++context.data["CallCounter"]; });
  middleware.after((midContext) { context.data["After1Called"] = ++context.data["CallCounter"]; });
  context.data["middleware"] = middleware;
}

bool middlewareComplexCheck(SpecContext context) {
  expect(context.data["ErrorCalled"], isNull);
  expect(context.data["Before1Called"], equals(1)); 
  expect(context.data["Before2Called"], equals(2)); 
  expect(context.data["Around1BeforeCalled"], equals(3)); 
  expect(context.data["Before3Called"], equals(4)); 
  expect(context.data["CodeCalled"], equals(5));
  expect(context.data["After1Called"], equals(6));
  expect(context.data["After2Called"], equals(7));
  expect(context.data["Around1AfterCalled"], equals(8)); 
  expect(context.data["After3Called"], equals(9));
  return true;
}

// Middleware Exception Before Test Code
bool middlewareExceptionBeforeCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { 
    context.data["ErrorCalled"] = ++context.data["CallCounter"]; 
    context.data["Error"] = error; 
  });
  middleware.before((midContext) { 
    context.data["BeforeCodeCalled"] = ++context.data["CallCounter"];
    throw "Demo Exception"; 
  });
  context.data["middleware"] = middleware;
}

bool middlewareExceptionBeforeCheck(SpecContext context) {
  expect(context.data["BeforeCodeCalled"], equals(1));
  expect(context.data["CodeCalled"], isNull);
  expect(context.data["ErrorCalled"], equals(2));
  expect(context.data["Error"], new isInstanceOf<MiddlewareError>());
  expect(context.data["Error"].middlewareName, "Middleware");
  expect(context.data["Error"].catchedError.toString(), "Demo Exception");
  return true;
}

// Middleware Exception After Test Code
bool middlewareExceptionAfterCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { 
    context.data["ErrorCalled"] = ++context.data["CallCounter"]; 
    context.data["Error"] = error; 
  });
  middleware.after((midContext) { 
    context.data["AfterCodeCalled"] = ++context.data["CallCounter"];
    throw "Demo Exception"; 
  });
  context.data["middleware"] = middleware;
}

bool middlewareExceptionAfterCheck(SpecContext context) {
  expect(context.data["CodeCalled"], equals(1));
  expect(context.data["AfterCodeCalled"], equals(2));
  expect(context.data["ErrorCalled"], equals(3));
  expect(context.data["Error"], new isInstanceOf<MiddlewareError>());
  expect(context.data["Error"].middlewareName, "Middleware");
  expect(context.data["Error"].catchedError.toString(), "Demo Exception");
  return true;
}

// Middleware Exception Around Before Test Code
bool middlewareExceptionAroundBeforeCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { 
    context.data["ErrorCalled"] = ++context.data["CallCounter"]; 
    context.data["Error"] = error; 
  });
  middleware.around((midContext, ctrl) { 
    context.data["AroundBeforeCodeCalled"] = ++context.data["CallCounter"];
    throw "Demo Exception"; 
  });
  context.data["middleware"] = middleware;
}

bool middlewareExceptionAroundBeforeCheck(SpecContext context) {
  expect(context.data["AroundBeforeCodeCalled"], equals(1));
  expect(context.data["CodeCalled"], isNull);
  expect(context.data["ErrorCalled"], equals(2));
  expect(context.data["Error"], new isInstanceOf<MiddlewareError>());
  expect(context.data["Error"].middlewareName, "Middleware");
  expect(context.data["Error"].catchedError.toString(), "Demo Exception");
  return true;
}

// Middleware Exception Around After Test Code
bool middlewareExceptionAroundAfterCreate(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware", (reqRes, error) { 
    context.data["ErrorCalled"] = ++context.data["CallCounter"]; 
    context.data["Error"] = error; 
  });
  middleware.around((midContext, ctrl) { 
    context.data["AroundBeforeCodeCalled"] = ++context.data["CallCounter"];
    ctrl.next();
    context.data["AroundAfterCodeCalled"] = ++context.data["CallCounter"];
    throw "Demo Exception"; 
  });
  context.data["middleware"] = middleware;
}

bool middlewareExceptionAroundAfterCheck(SpecContext context) {
  expect(context.data["AroundBeforeCodeCalled"], equals(1));
  expect(context.data["CodeCalled"], equals(2));
  expect(context.data["AroundAfterCodeCalled"], equals(3));
  expect(context.data["ErrorCalled"], equals(4));
  expect(context.data["Error"], new isInstanceOf<MiddlewareError>());
  expect(context.data["Error"].middlewareName, "Middleware");
  expect(context.data["Error"].catchedError.toString(), "Demo Exception");
  return true;
}
