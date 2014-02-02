import "V0-2/benchmark.dart" as v002;
import 'package:benchmark_harness/benchmark_harness.dart';

var versions = ["v0.1", "v0.2", "v0.3"];

main() {
  
  v002.executeBenchmark();
  return;
  
  var runs = 1000;
  
  // Single count measuring
  var countTimes = new List<int>();
  
  for (int i = 0; i < runs; i++) {
    var singleTime = new Stopwatch();
    singleTime.start();
    
    TestCode();
    
    singleTime.stop();
    countTimes.add(singleTime.elapsedTicks);
  }
  
  // Single Duration measuring 
  var durationTimes = new List<int>();
  
  var singleDurationTime = new Stopwatch();
  singleDurationTime.start();
  
  while (singleDurationTime.elapsedMilliseconds < 2000) {
    var singleTime = new Stopwatch();
    singleTime.start();
    
    TestCode();
    
    singleTime.stop();
    durationTimes.add(singleTime.elapsedTicks);
  }
  
  singleDurationTime.stop();
  
  // summary count measuring
  var summaryCountTime = new Stopwatch();
  summaryCountTime.start();
  
  for (int i = 0; i < runs; i++) {
    
    TestCode();
  }
  
  summaryCountTime.stop();
  
  // summary duration measuring
  var summaryDurationTime = new Stopwatch();
  summaryDurationTime.start();
  
  var durationCount = 0;
  while (summaryDurationTime.elapsedMilliseconds < 2000) {
    TestCode();
    durationCount++;
  }
  
  summaryDurationTime.stop();
  
  // Output result
  print("SummaryCount: ${summaryCountTime.elapsedTicks} ticks => ${summaryCountTime.elapsedTicks / runs} ticks per run");
  var sumCount = 0;
  countTimes.forEach((time) => sumCount += time);
  
  print("SingleCount: ${sumCount} ticks in ${countTimes.length} counts => ${sumCount / countTimes.length} ticks per run");
  print("First 20 single values: ${countTimes.take(20).join(",")}");
  
  
  print("SummaryDuration: ${summaryDurationTime.elapsedTicks} ticks => ${summaryDurationTime.elapsedTicks / durationCount} ticks per run");
  var sumDuration = 0;
  durationTimes.forEach((time) => sumDuration += time);
  
  print("SingleDuration: ${sumDuration} ticks  in ${durationTimes.length} counts  => ${sumDuration / durationTimes.length} ticks per run");
  print("First 20 single values: ${durationTimes.take(20).join(",")}");
  
}

void TestCode() {
  
  // Some code which takes time
  var n = 0;
  for(int i = 0; i < 1000; i++) {
    n++;
  }
  
}

class Benchmark extends BenchmarkBase {
  
  const Benchmark() : super("Test");
  
  static void main() {
    new Benchmark().report();
  }

  // The benchmark code.
  void run() {
    TestCode();
  }

  void setup() { 
  }

  void teardown() { 
  }
}