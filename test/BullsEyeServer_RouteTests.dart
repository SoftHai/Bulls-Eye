import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

import 'dart:io';
import '../lib/BullsEyeCommon/bulls_eye_common.dart';
import '../lib/BullsEyeServer/bulls_eye_server.dart';

class HttpHeadersMock extends Mock implements HttpHeaders {
  HttpHeadersMock(List<String> accept) {
    this.when(callsTo("[]", HttpHeaders.ACCEPT)).alwaysReturn(accept);
  }
}

class HttpRequestMock extends Mock implements HttpRequest {
  
  HttpRequestMock(String path, String method, List<String> httpHeaderAccept) {
    this.when(callsTo("get uri")).alwaysReturn(new Uri.file(path));
    this.when(callsTo("get method")).alwaysReturn(method);
    this.when(callsTo("get headers")).alwaysReturn(new HttpHeadersMock(httpHeaderAccept));
  }
  
}


void TestHttpRequestMock() {
  
  var httpRequest = new HttpRequestMock("/Test/X/Foo/Bar", "GET", ["Bla Bla Bla"]);

  expect(httpRequest.uri.path, "/Test/X/Foo/Bar");
  expect(httpRequest.method, "GET");
  expect(httpRequest.headers[HttpHeaders.ACCEPT].length, 1);
  expect(httpRequest.headers[HttpHeaders.ACCEPT].first, "Bla Bla Bla");
}

main()  {
  // Make sure the Mock works as expected
  test("Test HttpRequestMock", () { TestHttpRequestMock(); });
  
  var routeDef = new RouteDef("/Part1/:var1/Part2/(:var2)", "Demo Route");
  var route = new LogicRoute(routeDef, (context) { return true; }, methods: ["GET"], contentTypes: ["application/html"]);
  
  group("BullsEye Server -", () {
    
    group("Route -", () {
      
      test("Test - Route Matching Successful", () {
        // Allow all ContentTypes
        var httpRequest = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["*/*"]);
        expect(route.match(httpRequest), isTrue);
        
        // Test with optional var
        httpRequest = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["application/html"]);
        expect(route.match(httpRequest), isTrue);
        
        // Test without optional var
        httpRequest = new HttpRequestMock("/Part1/123/Part2/", "GET", ["application/html"]);
        expect(route.match(httpRequest), isTrue);     
        
        // Test with multible allowed contents
        httpRequest = new HttpRequestMock("/Part1/123/Part2/", "GET", ["application/html,*/*"]);
        expect(route.match(httpRequest), isTrue);     
      });  
      
      test("Test - Route Matching Not Successful", () {
        // Wrong Path
        var httpRequest = new HttpRequestMock("/Part1/123/Part5/456", "GET", ["application/html"]);
        expect(route.match(httpRequest), isFalse);
        
        // Wrong Method
        httpRequest = new HttpRequestMock("/Part1/123/Part2/456", "POST", ["application/html"]);
        expect(route.match(httpRequest), isFalse);
        
        // Wrong ContentType
        httpRequest = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["application/json"]);
        expect(route.match(httpRequest), isFalse);
        
        // Wrong Method
        httpRequest = new HttpRequestMock("/Part1/123/Part2/", "POST", ["application/html"]);
        expect(route.match(httpRequest), isFalse);
        
        // Wrong ContentType
        httpRequest = new HttpRequestMock("/Part1/123/Part2/", "GET", ["application/json"]);
        expect(route.match(httpRequest), isFalse);        
      }); 
    });
    
    group("LogicRoute -", () {
      
      test("Test - Route execute", () {
        var routeExecute = new LogicRoute(routeDef, (RouteContext context) { 
          expect(context.currentRoute, same(routeDef));
          expect(context.request, isNotNull);
          expect(context.routeVariables.result.length, 2);
          expect(context.routeVariables.getVariable("var1"), equals("123"));
          
          if(context.request.uri.path == "/Part1/123/Part2/")
          {
            expect(context.routeVariables.getVariable("var2"), isNull);
          }
          else if(context.request.uri.path == "/Part1/123/Part2/456")
          {
            expect(context.routeVariables.getVariable("var2"), "456");
          }
          
          return true;
          }, methods: ["GET"], contentTypes: ["application/html"]);
        
        var httpRequest = new HttpRequestMock("/Part1/123/Part2/", "GET", ["application/html"]);
        expect(route.execute(httpRequest), isTrue);
        
        httpRequest = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["application/html"]);
        expect(route.execute(httpRequest), isTrue);
       
      });
      
      skip_test("Test - Route Exception", () {
        bool exceptionRaised = false;
        var routeExecute = new LogicRoute(routeDef, (RouteContext context) { 
          throw new Exception("Test Exception");
          }, methods: ["GET"], contentTypes: ["application/html"]);
        
        var httpRequest = new HttpRequestMock("/Part1/123/Part2/", "GET", ["application/html"]);
        
        routeExecute.registerExceptionHandler((Route route, request, ex) {
          
          expect(route, routeExecute);
          expect(request, httpRequest);
          expect(ex.toString(), "Test Exception");
          exceptionRaised = true;
        });

        expect(route.execute(httpRequest), isTrue);
        
        expect(exceptionRaised, isTrue);
      });
    }); 
  });
}