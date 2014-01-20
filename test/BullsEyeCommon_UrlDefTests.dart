import 'package:unittest/unittest.dart';
import '../lib/common.dart';

void _BullsEyeCommonTest_RouteDefenition_Test(Url urlDef, String expectedPath, [String expectedName]) {
  expectedName = expectedName == null ? expectedPath : expectedName;
  
  expect(urlDef.name, equals(expectedName));
  expect(urlDef.toString(), equals(expectedPath));
  
  expect(urlDef.routeParts, hasLength(6));
  expect(urlDef.routeParts[0],new isInstanceOf<Static>());
  expect((urlDef.routeParts[0] as Static).partName, "Part1");
  expect(urlDef.routeParts[1],new isInstanceOf<Version>());
  expect((urlDef.routeParts[1] as Variable).varName, "Version");
  expect((urlDef.routeParts[1] as Variable).isOptional, isFalse);
  expect(urlDef.routeParts[2],new isInstanceOf<Variable>());
  expect((urlDef.routeParts[2] as Variable).varName, "Var1");
  expect((urlDef.routeParts[2] as Variable).isOptional, isFalse);
  expect(urlDef.routeParts[3],new isInstanceOf<Static>());
  expect((urlDef.routeParts[3] as Static).partName, "Part2");
  expect(urlDef.routeParts[4],new isInstanceOf<Variable>());
  expect((urlDef.routeParts[4] as Variable).varName, "OptVar2");
  expect((urlDef.routeParts[4] as Variable).isOptional, isTrue);
  expect(urlDef.routeParts[5],new isInstanceOf<WildCard>());
  
  expect(urlDef.queryParts, hasLength(2));
  expect(urlDef.queryParts[0],new isInstanceOf<QVariable>());
  expect((urlDef.queryParts[0] as QVariable).varName, "QVar1");
  expect((urlDef.queryParts[0] as QVariable).isOptional, isFalse);
  expect(urlDef.queryParts[1],new isInstanceOf<QVariable>());
  expect((urlDef.queryParts[1] as QVariable).varName, "QVar2");
  expect((urlDef.queryParts[1] as QVariable).isOptional, isTrue);
}

Url _Build_RouteDefenition_FromObjects1() {
  
  return new Url.fromObjects([new Static("Part1"), 
                                   new Version(), 
                                   new Variable("Var1"), 
                                   new Static("Part2"),
                                   new Variable("OptVar2", true),
                                   new WildCard()], 
                                   queryParts: [new QVariable("QVar1"),
                                                new QVariable("QVar2", true)]);
}

Url _Build_RouteDefenition_FromMixed1() {
  
  return new Url.fromMixed(["Part1/:Version", 
                                 new Variable("Var1"), 
                                 "Part2",
                                 new Variable("OptVar2", true),
                                 "*?QVar1",
                                 new QVariable("QVar2", true)]);
}

Url _Build_RouteDefenition_FromString1() {
  
  return new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/*?QVar1&(QVar2)");
}

main()  {
  group("BullsEye Common -", () {
    
    group("Route Defenition -", () {
      
      var expectedUrl = "Part1/:Version/:Var1/Part2/(:OptVar2)/*?QVar1&(QVar2)";
      
      test("Test - FromObjects1", () =>
           _BullsEyeCommonTest_RouteDefenition_Test(_Build_RouteDefenition_FromObjects1(), 
                                                    expectedUrl));
      
      test("Test - FromObjects2 - MultipleVersionException", () => 
          expect(() => new Url.fromObjects([new Version(), new Version()]),
                 throwsA(new isInstanceOf<MultipleVersionException>())));
      
      test("Test - FromMixed1", () =>
          _BullsEyeCommonTest_RouteDefenition_Test(_Build_RouteDefenition_FromMixed1(), 
                                                   expectedUrl));

      test("Test - FromMixed2 - MultipleVersionException", () => 
          expect(() => new Url.fromMixed([":Version", ":Version"]),
                 throwsA(new isInstanceOf<MultipleVersionException>())));
      
      test("Test - FromString1", () =>
          _BullsEyeCommonTest_RouteDefenition_Test(_Build_RouteDefenition_FromString1(), 
                                                   expectedUrl));
      
      test("Test - FromString2 - MultipleVersionException", () => 
          expect(() => new Url(":Version/:Version"),
                 throwsA(new isInstanceOf<MultipleVersionException>())));
      
    });
  
    group("UriMatcher -", () {
      
      test("Test - UriMatcher Match Successful - Complex inc. Optional vars", () {
        var routeDef = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)");
                
        // With optional variable part
        expect(routeDef.matcher.match("/Part1/v1/12345/Part2/6789/Part3/More/More.js?QVar1=abc&QVar2=def"), isTrue);
        
        UriMatcherResult variables = routeDef.matcher.getMatches("/Part1/v1/12345/Part2/6789/Part3/More/More.js?QVar1=abc&QVar2=def");
        expect(variables.routeVariables.result, hasLength(4));
        expect(variables.routeVariables.getVariable("Version"), new isInstanceOf<Version>());
        expect(variables.routeVariables["Version"], "v1");
        expect(variables.routeVariables.getVariable("Var1"), new isInstanceOf<Variable>());
        expect(variables.routeVariables["Var1"], "12345");       
        expect(variables.routeVariables.getVariable("OptVar2"), new isInstanceOf<Variable>());
        expect(variables.routeVariables["OptVar2"], "6789");
        expect(variables.routeVariables.getVariable("*"), new isInstanceOf<Variable>());
        expect(variables.routeVariables["*"], "More/More.js");
        
        expect(variables.queryVariables.result, hasLength(2));
        expect(variables.queryVariables.getVariable("QVar1"), new isInstanceOf<QVariable>());
        expect(variables.queryVariables["QVar1"], "abc");
        expect(variables.queryVariables.getVariable("QVar2"), new isInstanceOf<QVariable>());
        expect(variables.queryVariables["QVar2"], "def");       
        
        // Without optional variable part
        expect(routeDef.matcher.match("/Part1/v1/12345/Part2/Part3?QVar1=abc"), isTrue);
        
        variables = routeDef.matcher.getMatches("/Part1/v1/12345/Part2/Part3?QVar1=abc");
        expect(variables.routeVariables.result, hasLength(4));
        expect(variables.routeVariables.getVariable("Version"), new isInstanceOf<Version>());
        expect(variables.routeVariables["Version"], "v1");
        expect(variables.routeVariables.getVariable("Var1"), new isInstanceOf<Variable>());
        expect(variables.routeVariables["Var1"], "12345");       
        expect(variables.routeVariables.getVariable("OptVar2"), new isInstanceOf<Variable>());
        expect(variables.routeVariables["OptVar2"], isNull);
        expect(variables.routeVariables.getVariable("*"), new isInstanceOf<Variable>());
        expect(variables.routeVariables["*"], isNull);
        
        expect(variables.queryVariables.result, hasLength(2));
        expect(variables.queryVariables.getVariable("QVar1"), new isInstanceOf<QVariable>());
        expect(variables.queryVariables["QVar1"], "abc");
        expect(variables.queryVariables.getVariable("QVar2"), new isInstanceOf<QVariable>());
        expect(variables.queryVariables["QVar2"], isNull);   
      });
      
      test("Test - UriMatcher Match - Not available variable", () {
        var routeDef = new Url("Part1/Part2");

        UriMatcherResult variables = routeDef.matcher.getMatches("/Part1/Part2");
        
        expect(variables.routeVariables["abc"], isNull);
        expect(variables.routeVariables.getVariable("abc"), isNull);

        expect(variables.queryVariables["abc"], isNull);
        expect(variables.queryVariables.getVariable("abc"), isNull);
        
      });
      
      test("Test - UriMatcher Match Successful - leading /", () {
        var routeDef = new Url("Part1/Part2?QVar");
                
        // With leading /
        expect(routeDef.matcher.match("/Part1/Part2?QVar=123"), isTrue);

        // Without leading /
        expect(routeDef.matcher.match("Part1/Part2?QVar=123"), isTrue);
      });
      
      test("Test - UriMatcher Match Successful - ending /", () {
        var routeDef = new Url("Part1/Part2?QVar");
                
        // With ending /
        expect(routeDef.matcher.match("/Part1/Part2/?QVar=123"), isTrue);

        // Without ending /
        expect(routeDef.matcher.match("/Part1/Part2?QVar=123"), isTrue);
      });
      
      test("Test - UriMatcher Match not successful", () {
        var urlDef = new Url("Part1/Part2/(:OptVar)/Part3/*?QVar1&(QVar2)");

        expect(urlDef.matcher.match("/Part2/Part1/123/Part3/"), isFalse);
        
        expect(urlDef.matcher.match("/Part1"), isFalse);

        expect(urlDef.matcher.match("/Part1/Part2"), isFalse);
        
        expect(urlDef.matcher.match("/Part1/Part2/1234"), isFalse);
        
        expect(urlDef.matcher.match("/Part1/Part2/Part3/bla"), isFalse);
        
        expect(urlDef.matcher.match("/Part1/Part2/Part3/bla?QVar3=1234"), isFalse);
        
        expect(urlDef.matcher.match("/Part1/Part2/Part3/bla?QVar1=123"), isTrue);
        
        expect(urlDef.matcher.match("/Part1/Part2/12345/Part3/bla?QVar1=123&QVar2=456"), isTrue);
      });
     
      test("Test - UriMatcher - Replace", () {
        var urlDef = new Url("Part1/:Var/Part2/(:OptVar)/Part3/*?QVar&(OptQVar)");
        
        expect(urlDef.matcher.replace({ "Var" : 123, "OptVar" : 456, "*" : "file.js", "QVar" : 789, "OptQVar" : 963}), "Part1/123/Part2/456/Part3/file.js?QVar=789&OptQVar=963");
        
        expect(urlDef.matcher.replace({ "Var" : 123, "QVar" : 789}), "Part1/123/Part2/Part3/?QVar=789");
      });
      
    });
    
    // Has to be the last test, because all other working with the default
    group("Customize RouteDefenition -", () {
      test("Test - Customized Route Def Config", () {
        var custConfig = new UrlDefConfig.Costumize("{", "}", "!", "", "%");
        Version.RegisterParseFunc(); // Register Version before can be used (Only required if the String-Style is used) 
        
        var urlStr = "Part1/{Version}/Part2/{var}/!{OptVariable}/Part3/%?QVar&!OptQVar";
        var urlDef = new Url(urlStr);
        
        expect(urlDef.toString(), equals(urlStr));
        expect(urlDef.routeParts, hasLength(7));
        expect(urlDef.routeParts[0],new isInstanceOf<Static>());
        expect((urlDef.routeParts[0] as Static).partName, "Part1");
        expect(urlDef.routeParts[1],new isInstanceOf<Version>());
        expect((urlDef.routeParts[1] as Variable).varName, "Version");
        expect((urlDef.routeParts[1] as Variable).isOptional, isFalse);
        expect(urlDef.routeParts[2],new isInstanceOf<Static>());
        expect((urlDef.routeParts[2] as Static).partName, "Part2");
        expect(urlDef.routeParts[3],new isInstanceOf<Variable>());
        expect((urlDef.routeParts[3] as Variable).varName, "var");
        expect((urlDef.routeParts[3] as Variable).isOptional, isFalse);
        expect(urlDef.routeParts[4],new isInstanceOf<Variable>());
        expect((urlDef.routeParts[4] as Variable).varName, "OptVariable");
        expect((urlDef.routeParts[4] as Variable).isOptional, isTrue);
        expect(urlDef.routeParts[5],new isInstanceOf<Static>());
        expect((urlDef.routeParts[5] as Static).partName, "Part3");
        expect(urlDef.routeParts[6],new isInstanceOf<WildCard>());
        
        expect(urlDef.queryParts[0],new isInstanceOf<QVariable>());
        expect((urlDef.queryParts[0] as QVariable).varName, "QVar");
        expect((urlDef.queryParts[0] as QVariable).isOptional, isFalse);
        expect(urlDef.queryParts[1],new isInstanceOf<QVariable>());
        expect((urlDef.queryParts[1] as QVariable).varName, "OptQVar");
        expect((urlDef.queryParts[1] as QVariable).isOptional, isTrue);
        
      });
    });
    
  });
}