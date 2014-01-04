import 'package:unittest/unittest.dart';
import '../lib/BullsEyeCommon/bulls_eye_common.dart';

void _BullsEyeCommonTest_RouteDefenition_Test(RouteDef routeDef, String expectedPath, [String expectedName]) {
  expectedName = expectedName == null ? expectedPath : expectedName;
  
  expect(routeDef.name, equals(expectedName));
  expect(routeDef.toString(), equals(expectedPath));
  expect(routeDef.routeParts, hasLength(6));
  expect(routeDef.routeParts[0],new isInstanceOf<Static>());
  expect(routeDef.routeParts[1],new isInstanceOf<Version>());
  expect((routeDef.routeParts[1] as Variable).isOptional, isFalse);
  expect(routeDef.routeParts[2],new isInstanceOf<Variable>());
  expect((routeDef.routeParts[2] as Variable).isOptional, isFalse);
  expect(routeDef.routeParts[3],new isInstanceOf<Static>());
  expect(routeDef.routeParts[4],new isInstanceOf<Variable>());
  expect((routeDef.routeParts[4] as Variable).isOptional, isTrue);
  expect(routeDef.routeParts[5],new isInstanceOf<WildCard>());
}

RouteDef _Build_RouteDefenition_FromObjects1() {
  
  return new RouteDef.fromObjects([new Static("Part1"), 
                                   new Version(), 
                                   new Variable("Var1"), 
                                   new Static("Part2"),
                                   new Variable("OptVar2", true),
                                   new WildCard()]);
}

RouteDef _Build_RouteDefenition_FromStrings1() {
  
  return new RouteDef.fromMixed(["Part1", 
                                           ":Version", 
                                           ":Var1", 
                                           "Part2",
                                           "(:OptVar2)",
                                           "*"]);
}

RouteDef _Build_RouteDefenition_FromString1() {
  
  return new RouteDef("Part1/:Version/:Var1/Part2/(:OptVar2)/*");
}

main()  {
  group("BullsEye Common -", () {
    
    group("Route Defenition -", () {
      
      var expectedUrl = "Part1/:Version/:Var1/Part2/(:OptVar2)/*";
      
      test("Test - FromObjects1", () =>
           _BullsEyeCommonTest_RouteDefenition_Test(_Build_RouteDefenition_FromObjects1(), 
                                                    expectedUrl));
      
      test("Test - FromObjects2 - MultipleVersionException", () => 
          expect(() => new RouteDef.fromObjects([new Version(), new Version()]),
                 throwsA(new isInstanceOf<MultipleVersionException>())));
      
      test("Test - FromStrings1", () =>
          _BullsEyeCommonTest_RouteDefenition_Test(_Build_RouteDefenition_FromStrings1(), 
                                                   expectedUrl));

      test("Test - FromStrings2 - MultipleVersionException", () => 
          expect(() => new RouteDef.fromMixed([":Version", ":Version"]),
                 throwsA(new isInstanceOf<MultipleVersionException>())));
      
      test("Test - FromString1", () =>
          _BullsEyeCommonTest_RouteDefenition_Test(_Build_RouteDefenition_FromString1(), 
                                                   expectedUrl));
      
      test("Test - FromString2 - MultipleVersionException", () => 
          expect(() => new RouteDef(":Version/:Version"),
                 throwsA(new isInstanceOf<MultipleVersionException>())));
      
    });
  
    group("UriMatcher -", () {
      
      test("Test - UriMatcher Match Successful - Complex", () {
        var routeDef = new RouteDef("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*");
                
        // With optional variable part
        expect(routeDef.matcher.match("/Part1/v1/12345/Part2/6789/Part3/More/More.js"), isTrue);
        
        var variables = routeDef.matcher.getMatches("/Part1/v1/12345/Part2/6789/Part3/More/More.js");
        expect(variables.result, hasLength(4));
        expect(variables.getVariable("Version"), new isInstanceOf<Version>());
        expect(variables["Version"], "v1");
        expect(variables.getVariable("Var1"), new isInstanceOf<Variable>());
        expect(variables["Var1"], "12345");       
        expect(variables.getVariable("OptVar2"), new isInstanceOf<Variable>());
        expect(variables["OptVar2"], "6789");
        expect(variables.getVariable("*"), new isInstanceOf<Variable>());
        expect(variables["*"], "More/More.js");
        
        // Without optional variable part
        expect(routeDef.matcher.match("/Part1/v1/12345/Part2/Part3/"), isTrue);
        
        variables = routeDef.matcher.getMatches("/Part1/v1/12345/Part2/Part3/");
        expect(variables.result, hasLength(4));
        expect(variables.getVariable("Version"), new isInstanceOf<Version>());
        expect(variables["Version"], "v1");
        expect(variables.getVariable("Var1"), new isInstanceOf<Variable>());
        expect(variables["Var1"], "12345");       
        expect(variables.getVariable("OptVar2"), new isInstanceOf<Variable>());
        expect(variables["OptVar2"], isNull);
        expect(variables.getVariable("*"), new isInstanceOf<Variable>());
        expect(variables["*"], isNull);
      });
      
      test("Test - UriMatcher Match - Not available variable", () {
        var routeDef = new RouteDef("Part1/Part2");

        var variables = routeDef.matcher.getMatches("/Part1/Part2");
        
        expect(variables["abc"], isNull);
        expect(variables.getVariable("abc"), isNull);

      });
      
      test("Test - UriMatcher Match Successful - leading /", () {
        var routeDef = new RouteDef("Part1/Part2");
                
        // With leading /
        expect(routeDef.matcher.match("/Part1/Part2"), isTrue);

        // Without leading /
        expect(routeDef.matcher.match("Part1/Part2"), isTrue);
      });
      
      test("Test - UriMatcher Match Successful - ending /", () {
        var routeDef = new RouteDef("Part1/Part2");
                
        // With ending /
        expect(routeDef.matcher.match("/Part1/Part2/"), isTrue);

        // Without ending /
        expect(routeDef.matcher.match("/Part1/Part2"), isTrue);
      });
      
      test("Test - UriMatcher Match not successful", () {
        var routeDef = new RouteDef("Part1/Part2/(:OptVar)/Part3/*");

        expect(routeDef.matcher.match("/Part2/Part1/123/Part3/"), isFalse);
        
        expect(routeDef.matcher.match("/Part1"), isFalse);

        expect(routeDef.matcher.match("/Part1/Part2"), isFalse);
        
        expect(routeDef.matcher.match("/Part1/Part2/1234"), isFalse);
        
        expect(routeDef.matcher.match("/Part1/Part2/Part3/bla"), isTrue);
        
        expect(routeDef.matcher.match("/Part1/Part2/12345/Part3/bla"), isTrue);
      });
     
      test("Test - UriMatcher - Replace", () {
        var routeDef = new RouteDef("Part1/:Var/Part2/(:OptVar)/Part3/*");
        
        expect(routeDef.matcher.replace({ "Var" : 123, "OptVar" : 456}), "Part1/123/Part2/456/Part3/");
        
        expect(routeDef.matcher.replace({ "Var" : 123}), "Part1/123/Part2/Part3/");
      });
      
    });
    
    // Has to be the last test, because all other working with the default
    group("Customize RouteDefenition -", () {
      test("Test - Customized Route Def Config", () {
        var custConfig = new RouteDefConfig.Costumize("{", "}", "!", "", "%");
        Version.RegisterParseFunc(); // Register Version before can be used (Only required if the String-Style is used) 
        
        var routeStr = "Part1/{Version}/Part2/{var}/!{OptVariable}/Part3/%";
        var routeDef = new RouteDef(routeStr);
        
        expect(routeDef.toString(), equals(routeStr));
        expect(routeDef.routeParts, hasLength(7));
        expect(routeDef.routeParts[0],new isInstanceOf<Static>());
        expect(routeDef.routeParts[1],new isInstanceOf<Version>());
        expect(routeDef.routeParts[2],new isInstanceOf<Static>());
        expect(routeDef.routeParts[3],new isInstanceOf<Variable>());
        expect(routeDef.routeParts[4],new isInstanceOf<Variable>());
        expect((routeDef.routeParts[4] as Variable).isOptional, isTrue);
        expect(routeDef.routeParts[5],new isInstanceOf<Static>());
        expect(routeDef.routeParts[6],new isInstanceOf<WildCard>());
        
      });
    });
    
  });
}