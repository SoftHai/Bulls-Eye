import "V0-2/BullsEyeCommon_URLDefBenchmarks.dart" as urlDefBench;
import "V0-2/bulls_eye_server_middleware_benchmarks.dart" as middlewareBench;
import 'package:spec_dart/spec_dart.dart';
import 'dart:async';

var versions = ["v0.1", "v0.2", "v0.3"];

main() {
  
  List<Suite> suites = new List<Suite>();
  
  suites.add(urlDefBench.buildBenchmark());
  suites.add(middlewareBench.buildBenchmark());
  
  Future.forEach(suites, (s) => s.run());
  return;

}
