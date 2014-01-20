import 'package:unittest/unittest.dart';
import 'HttpMocks.dart';

import 'dart:io';
import '../lib/common.dart';
import '../lib/server.dart';

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
  
  var urlDef = new Url("/Part1/:var1/Part2/(:var2)", "Demo Route");
  var route = new RouteManager("GET", urlDef, new ExecuteCode((context) { return true; }), ["application/html"], null);
  
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
    
    /*
    group("LogicRoute -", () {
      
      test("Test - Route execute", () {
        var routeExecute = new RouteManager("GET", urlDef, new ExecuteCode((ReqResContext context) { 
          expect(context.currentRoute, same(urlDef));
          expect(context.request, isNotNull);
          expect(context.variables.routeVariables.result.length, 2);
          expect(context.variables.routeVariables.getVariable("var1"), equals("123"));
          
          if(context.request.uri.path == "/Part1/123/Part2/")
          {
            expect(context.variables.routeVariables.getVariable("var2"), isNull);
          }
          else if(context.request.uri.path == "/Part1/123/Part2/456")
          {
            expect(context.variables.routeVariables.getVariable("var2"), "456");
          }
          
          return true;
          }), ["application/html"], null);
        
        var httpRequest = new HttpRequestMock("/Part1/123/Part2/", "GET", ["application/html"]);
        expect(route.execute(httpRequest), isTrue);
        
        httpRequest = new HttpRequestMock("/Part1/123/Part2/456", "GET", ["application/html"]);
        expect(route.execute(httpRequest), isTrue);
       
      });
      
    });
    */ 
  });
}