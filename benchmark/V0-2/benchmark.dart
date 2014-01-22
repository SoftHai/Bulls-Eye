// thats the benchmarks for v0.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:bulls_eye/common.dart';

void executeBenchmark() {
  URLStringDefBenchmark.main();
  URLObjectDefBenchmark.main();
  URLMixedDefBenchmark.main();
  
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", true, "Complex - All");
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/456/Part3?QVar1=10&QVar2=11", true, "Complex - All (without wildcard)");
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/Part3/Folder/Folder/file.js?QVar1=10", true, "Complex - Only required + wildcard");
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/Part3?QVar1=10", true, "Complex - Only required");
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part111/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", false, "Complex - early Error");
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part222/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", false, "Complex - middle Error");
  URLMatchingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar111=10&QVar2=11", false, "Complex - late Error");
  URLMatchingBenchmark.main("Part1/Part2/Part3", "Part1/Part2/Part3", true, "Static");
  URLMatchingBenchmark.main("Part1/Part222/Part3", "Part1/Part2/Part3", false, "Static");
  URLMatchingBenchmark.main("Part1/:Var1/Part3?QVar1", "Part1/123/Part3?QVar1=12", true, "No Optional");
  URLMatchingBenchmark.main("Part1/:Var1/Part3?QVar1", "Part1/123/Part333?QVar1=12", false, "No Optional");
  
  URLExtractingBenchmark.main("Part1/:Version/:Var1/Part2/(:OptVar2)/Part3/*?QVar1&(QVar2)", "Part1/v1/123/Part2/456/Part3/Folder/Folder/file.js?QVar1=10&QVar2=11", 6, "Complex - All");
  URLExtractingBenchmark.main("Part1/Part222/Part3", "Part1/Part2/Part3", 0, "Static");
  URLExtractingBenchmark.main("Part1/:Var1/Part3?QVar1", "Part1/123/Part3?QVar1=12", 2, "No Optional");
}

class URLStringDefBenchmark extends BenchmarkBase {
  const URLStringDefBenchmark() : super("V0.2 - URL String Def");

  static void main() {
    new URLStringDefBenchmark().report();
  }

  // The benchmark code.
  void run() {
    var urlObj = new Url("Part1/:Version/:Var1/Part2/(:OptVar2)/*?QVar1&(QVar2)");
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { 
    
  }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { 
    
  }
}

class URLObjectDefBenchmark extends BenchmarkBase {
  const URLObjectDefBenchmark() : super("V0.2 - URL Object Def");

  static void main() {
    new URLObjectDefBenchmark().report();
  }

  // The benchmark code.
  void run() {
    var urlObj = new Url.fromObjects([new Static("Part1"), 
                          new Version(), 
                          new Variable("Var1"), 
                          new Static("Part2"),
                          new Variable("OptVar2", true),
                          new WildCard()], 
                          queryParts: [new QVariable("QVar1"),
                                       new QVariable("QVar2", true)]);
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { 
    
  }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { 
    
  }
}

class URLMixedDefBenchmark extends BenchmarkBase {
  const URLMixedDefBenchmark() : super("V0.2 - URL Mixed Def");

  static void main() {
    new URLMixedDefBenchmark().report();
  }

  // The benchmark code.
  void run() {
    var urlObj = new Url.fromMixed(["Part1/:Version", 
                                      new Variable("Var1"), 
                                      "Part2",
                                      new Variable("OptVar2", true),
                                      "*?QVar1",
                                      new QVariable("QVar2", true)]);
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { 
    
  }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { 
    
  }
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
    if(matches.routeVariables.result.length + matches.queryVariables.result.length != varCount) throw "Extracting wrong";
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { 
    url = new Url(defUrl);
  }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { 
    
  }
}