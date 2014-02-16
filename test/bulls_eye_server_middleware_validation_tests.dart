library softhai.bulls_eye.Server;

import 'dart:io';
import 'dart:async';
import 'dart:collection';
import '../lib/common.dart' as common;
import 'HttpMocks.dart';

import 'package:unittest/unittest.dart';
import 'package:spec_dart/spec_dart.dart';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart' as path;

// Globals
part '../lib/src/Server/read_only_map.dart';
part '../lib/src/Server/input_data.dart';
part '../lib/src/Server/req_res_context.dart';
part '../lib/src/Server/req_res_context_impl.dart';
part '../lib/src/Server/Exceptions.dart';

// Middleware
part '../lib/src/Server/Middleware/middleware.dart';
part '../lib/src/Server/Middleware/middleware_impl.dart';
part '../lib/src/Server/Middleware/middleware_channel_part.dart';
part '../lib/src/Server/Middleware/middleware_error.dart';

// Middleware - Validation
part '../lib/src/Server/Middleware/Validation/server_validator.dart';
part '../lib/src/Server/Middleware/Validation/ValidationEngine.dart';
part '../lib/src/Server/Middleware/Validation/ValidationException.dart';

// Routing
part '../lib/src/Server/Routing/Route.dart';
part '../lib/src/Server/Routing/ExecuteCode.dart';
part '../lib/src/Server/Routing/LoadFile.dart';
part '../lib/src/Server/Routing/RoutingExceptions.dart';

void main() {
  
  var feature = new Feature("Middleware - Validation", "The middleware VALIDATION protects your code before bad requests")
                    ..setUp((context) {
                        createCallCounter(context);
                      });
  
  var storyMiddlewareCode = feature.story("Validation", 
                            asA: "WebServer Developer", 
                            iWant: "I don't want to handle the validation in all buisness code seperate", 
                            soThat: "I can centralize the validation code and the logic will be save");
  
  storyMiddlewareCode.scenario("Request")
        ..setUp(createCallCounter) // set Call Counter to 0
        ..given(text: "is a middleware with validation engine and a request", 
               func: createValidationMiddleware)
           .and(text: "a request with a [url]", 
               func: (context) => createHttpRequest(context, context.data["url"]))
        ..when(text: "the middleware is executed", func: executeMiddleware)
        ..than(text: "the validation protects the logic before bad requests", func: validationCheck)
        ..example([ { "url": new Uri.http("www.example.com", "/Part1/v1/15", { "QVar": "20140202" }), "valid": true },
                    { "url": new Uri.http("www.example.com", "/Part1/v1/15", { "QVar": "Hallo" }), "valid": false },
                    { "url": new Uri.http("www.example.com", "/Part1/v1/30", { "QVar": "20140202" }), "valid": false },
                    { "url": new Uri.http("www.example.com", "/Part1/v2/30", { "QVar": "20140202" }), "valid": true },
                    { "url": new Uri.http("www.example.com", "/Part1/v3/30", { "QVar": "20140202" }), "valid": false }]);
  
  feature.run();
  
}

bool createCallCounter(SpecContext context) {
  context.data["CallCounter"] = 0;
}

bool createHttpRequest(SpecContext context, Uri url) {
  var versionVariable = new common.Version();
  var routeVariable = new common.Variable("var1", extensions: { common.ValidatorKey: common.versionDep( {"v1": common.inRangeNum(10, 20),
                                                                                                         "v2": common.inRangeNum(10, 50) }) });
  var queryVariable = new common.QVariable("QVar", extensions: { common.ValidatorKey: common.isDateTime });
  
  var urlDef = new common.Url.fromObjects([new common.Static("Part1"), versionVariable, routeVariable],  queryParts: [queryVariable], name: "Demo Route");
  var route = new Route("GET", urlDef, new ExecuteCode((context) { return true; }), ["application/html"], null, false, null);
  var request = new HttpRequestMock(url, "GET", ["*/*"]);
  context.data["ReqRes"] = route.createContext(request, (ex) { });
}

bool createValidationMiddleware(SpecContext context) {
  var middleware = new _MiddlewareImpl("Middleware");
  middleware.onError((reqRes, error) { 
    context.data["ErrorCalled"] = ++context.data["CallCounter"]; 
    context.data["Error"] = error;
    });
  middleware.add(new Validation());
  context.data["middleware"] = middleware;
}

Future executeMiddleware(SpecContext context) {
  return context.data["middleware"].execute(context.data["ReqRes"], (midContext) 
      { context.data["CodeCalled"] = ++context.data["CallCounter"]; });
}

bool validationCheck(SpecContext context) {
  
  if(context.data["valid"]) {
    expect(context.data["CodeCalled"], equals(1));
    expect(context.data["ErrorCalled"], isNull);
    expect(context.data["Error"], isNull);
  }
  else {
    expect(context.data["CodeCalled"], isNull);
    expect(context.data["ErrorCalled"], equals(1));
    expect(context.data["Error"].catchedError, new isInstanceOf<ValidationException>());
  }
}