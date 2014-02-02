// thats the benchmarks for v0.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:bulls_eye/common.dart';
import 'package:spec_dart/spec_dart.dart';

void executeBenchmark() {
  
  var suite = Suite.create();
  suite.interations(5);
  var urlDefBenchmark = suite.add("URLDef");
  
  urlDefBenchmark..bench(URLStringDef_Benchmark, name: "String", unit: MICROSECONDS)
                 ..bench(URLObjectDef_Benchmark, name: "Object", unit: MICROSECONDS)
                 ..bench(URLMixedDef_Benchmark, name: "Mixed", unit: MICROSECONDS);
  
  var urlMatchingComplexBenchmark = suite.add("URLMatching - Complex");
  
  urlMatchingComplexBenchmark..setUp((context) { context.data["URL"] = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)"); })
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
  
  var urlMatchingStaticBenchmark = suite.add("URLMatching - Static");
  
  urlMatchingStaticBenchmark..setUp((context) { context.data["URL"] = new Url("Part1/Part2/Part3"); })
                            ..bench((context) => URLMatching_Benchmark(context, "Part1/Part2/Part3", true),
                                    name: "(matched)", unit: MICROSECONDS)
                            ..bench((context) => URLMatching_Benchmark(context, "Part1/Part222/Part3", false),
                                    name: "(not matched)", unit: MICROSECONDS);
  
  var urlMatchingNoOptionalBenchmark = suite.add("URLMatching - No Optional");
  
  urlMatchingNoOptionalBenchmark..setUp((context) { context.data["URL"] = new Url("Part1/:Var1/Part3?QVar1"); })
                                ..bench((context) => URLMatching_Benchmark(context, "Part1/123/Part3?QVar1=12", true),
                                        name: "(matched)", unit: MICROSECONDS)
                                ..bench((context) => URLMatching_Benchmark(context, "Part1/123/Part333?QVar1=12", false),
                                        name: "(not matched)", unit: MICROSECONDS);

  var urlExtractingComplexBenchmark = suite.add("URLExtracting - Complex");
  
  urlExtractingComplexBenchmark..setUp((context) { context.data["URL"] = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)"); })
                               ..bench((context) => URLExtracting_Benchmark(context, "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", 6),
                                        unit: MICROSECONDS);
 
  var urlExtractingStaticBenchmark = suite.add("URLExtracting - Static");
  
  urlExtractingStaticBenchmark..setUp((context) { context.data["URL"] = new Url("Part1/Part2/Part3"); })
                              ..bench((context) => URLExtracting_Benchmark(context, "Part1/Part2/Part3", 0),
                                        unit: MICROSECONDS);

  var urlExtractingNoOptionalBenchmark = suite.add("URLExtracting - NoOptional");
  
  urlExtractingNoOptionalBenchmark..setUp((context) { context.data["URL"] = new Url("Part1/:Var1/Part3?QVar1"); })
                                  ..bench((context) => URLExtracting_Benchmark(context, "Part1/123/Part3?QVar1=12", 2),
                                          unit: MICROSECONDS);
  
  suite.run();
 
  return;
  
  URLExtractingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", 6, "Complex - All");
  URLExtractingBenchmark.main("Part1/Part222/Part3", "Part1/Part2/Part3", 0, "Static");
  URLExtractingBenchmark.main("Part1/:Var1/Part3?QVar1", "Part1/123/Part3?QVar1=12", 2, "No Optional");
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

class URLMatchingBenchmark extends BenchmarkBase {
  const URLMatchingBenchmark(this.defUrl, this.matchUrl, bool matching, String text) : this.matching = matching, super("V0.2 - URL Matching - $matching - $text");

  static Url url;
  
  final String defUrl;
  final String matchUrl;
  final bool matching;
  
  static void main(String defUrl, String url, bool matching, String text) {
    new URLMatchingBenchmark(defUrl, url, matching, text).report();
  }

  // The benchmark code.
  void run() {
    // All
    var result = url.matcher.match(matchUrl);
    if(result != matching) throw "Matched wrong";
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { 
    url = new Url(defUrl);
  }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { 
    
  }
}

class URLExtractingBenchmark extends BenchmarkBase {
  const URLExtractingBenchmark(this.defUrl, this.extractUrl, this.varCount, String text) : super("V0.2 - URL Extracting - $text");

  static Url url;
  
  final String defUrl;
  final String extractUrl;
  final int varCount;
  
  static void main(String defUrl, String url, int varCount, String text) {
    new URLExtractingBenchmark(defUrl, url, varCount, text).report();
  }

  // The benchmark code.
  void run() {
    // All
    var matches = url.matcher.getMatches(extractUrl);
    //if(matches.routeVariables.result.length + matches.queryVariables.result.length != varCount) throw "Extracting wrong";
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { 
    url = new Url(defUrl);
  }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { 
    
  }
}