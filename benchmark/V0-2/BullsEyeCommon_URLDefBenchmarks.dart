// thats the benchmarks for v0.2

import 'package:bulls_eye/common.dart';
import 'package:spec_dart/spec_dart.dart';

Suite buildBenchmark() {
  
  var suite = Suite.create();
  suite.interations(3);

  suite.add("URLDef")
            ..bench(URLStringDef_Benchmark, name: "String", unit: MICROSECONDS)
            ..bench(URLObjectDef_Benchmark, name: "Object", unit: MICROSECONDS)
            ..bench(URLMixedDef_Benchmark, name: "Mixed", unit: MICROSECONDS);
  
  suite.add("URLMatching - Complex")
            ..setUp((context) { context.data["URL"] = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)"); })
            ..bench((context) => URLMatching_Benchmark(context, "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", true),
                      name: "(All)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/v1/123/Part2/456/Part3?QVar1=10&QVar2=11", true),
                      name: "(without wildcard)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/v1/123/Part2/Part3/Folder/Folder/file.js?QVar1=10", true),
                      name: "(without optional)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/v1/123/Part2/Part3?QVar1=10", true),
                      name: "(Only required)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part111/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", false),
                      name: "(early Error)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/v1/123/Part222/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", false),
                      name: "(middle Error)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar111=10&QVar2=11", false),
                      name: "(late Error)", unit: MICROSECONDS);

  suite.add("URLMatching - Static")
            ..setUp((context) { context.data["URL"] = new Url("Part1/Part2/Part3"); })
            ..bench((context) => URLMatching_Benchmark(context, "Part1/Part2/Part3", true),
                     name: "(matched)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/Part222/Part3", false),
                     name: "(not matched)", unit: MICROSECONDS);
  
  suite.add("URLMatching - No Optional")
            ..setUp((context) { context.data["URL"] = new Url("Part1/:Var1/Part3?QVar1"); })
            ..bench((context) => URLMatching_Benchmark(context, "Part1/123/Part3?QVar1=12", true),
                    name: "(matched)", unit: MICROSECONDS)
            ..bench((context) => URLMatching_Benchmark(context, "Part1/123/Part333?QVar1=12", false),
                    name: "(not matched)", unit: MICROSECONDS);

  suite.add("URLExtracting - Complex")
            ..setUp((context) { context.data["URL"] = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)"); })
            ..bench((context) => URLExtracting_Benchmark(context, "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", 6),
                     unit: MICROSECONDS);
 
  suite.add("URLExtracting - Static")
            ..setUp((context) { context.data["URL"] = new Url("Part1/Part2/Part3"); })
            ..bench((context) => URLExtracting_Benchmark(context, "Part1/Part2/Part3", 0), unit: MICROSECONDS);

  suite.add("URLExtracting - NoOptional")
            ..setUp((context) { context.data["URL"] = new Url("Part1/:Var1/Part3?QVar1"); })
            ..bench((context) => URLExtracting_Benchmark(context, "Part1/123/Part3?QVar1=12", 2), unit: MICROSECONDS);
  
  return suite;

}

void URLStringDef_Benchmark(context) {
  var urlObj = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/*?QVar1&(QVar2)");
}

void URLObjectDef_Benchmark(context) {
  var urlObj = new Url.fromObjects([new Static("Part1"), 
                                    new Version(), 
                                    new Variable("Var1"), 
                                    new Static("Part2"),
                                    new Variable("OptVar2", true),
                                    new WildCard()], 
                                    queryParts: [new QVariable("QVar1"),
                                                 new QVariable("QVar2", true)]);
}

void URLMixedDef_Benchmark(context) {
  var urlObj = new Url.fromMixed(["Part1/:Version", 
                                  new Variable("Var1"), 
                                  "Part2",
                                  new Variable("OptVar2", true),
                                  "*?QVar1",
                                  new QVariable("QVar2", true)]);
}

void URLMatching_Benchmark(BenchContext context, String url, bool matched) {
  var result = context.data["URL"].matcher.match(url);
  if(result != matched) throw "Matched wrong";
}

void URLExtracting_Benchmark(BenchContext context, String url, int expactedCount) {
  var matches = context.data["URL"].matcher.getMatches(url);
  var actualCount = matches.routeVariables.result.length + matches.queryVariables.result.length;
  if(matches.routeVariables.result.length + matches.queryVariables.result.length != expactedCount) throw "Extracting wrong - expected '$expactedCount' but was '$actualCount'";
}
