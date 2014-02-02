import "V0-2/BullsEyeCommon_URLDefBenchmarks.dart" as urlDefBench;
import "V0-2/bulls_eye_server_middleware_benchmarks.dart" as middlewareBench;

var versions = ["v0.1", "v0.2", "v0.3"];

main() {
  
  //urlDefBench.buildBenchmark().run();
  middlewareBench.buildBenchmark().run();
  return;

}
