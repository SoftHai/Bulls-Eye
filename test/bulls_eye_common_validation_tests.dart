import 'package:unittest/unittest.dart';
import '../lib/common.dart';

import 'package:spec_dart/spec_dart.dart';

main() {
  
  var feature = new Feature("URL Validation", "A validation engine which validates all inputs comming from an request");
  
  var storyValidators = feature.story("Validators", 
                            asA: "WebServer Developer", 
                            iWant: "to validate all inputs off an request", 
                            soThat: "I can be sure that only valid data ariving my logic");
  
  // Numeric validatation
  storyValidators.scenario("IsNumValidator")
                  ..given(text: "Input data that should be numeric")
                    .and(text: "A numeric validator", 
                         func: (context) { context.data["validator"] = isNum; } )
                  ..when(text: "I validate this with the isNum Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "123", "valid": true }, 
                             { "data": "123.123", "valid": true },
                             { "data": "hallo", "valid": false }]);
  
  storyValidators.scenario("IsIntValidator")
                  ..given(text: "Input data that should be int")
                    .and(text: "A int validator", 
                         func: (context) { context.data["validator"] = isInt; } )
                  ..when(text: "I validate this with the isInt Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "123", "valid": true }, 
                             { "data": "123.123", "valid": false },
                             { "data": "hallo", "valid": false }]);
  
  storyValidators.scenario("InRangeNumValidator")
                  ..given(text: "Input data that should be numeric and in a range of [from] to [to]")
                    .and(text: "A range validator", 
                         func: (context) { context.data["validator"] = inRangeNum(context.data["from"], context.data["to"]); } )
                  ..when(text: "I validate this with the inRangeNum Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "5", "from": 0, "to": 10, "valid": true }, 
                             { "data": "200", "from": 0, "to": 10, "valid": false },
                             { "data": "hallo", "from": 0, "to": 10, "valid": false }]);
  
  // String validation
  storyValidators.scenario("IsEmailValidator")
                  ..given(text: "Input data that should be an EMail-String")
                    .and(text: "A email validator", 
                         func: (context) { context.data["validator"] = isEmail(); } )
                  ..when(text: "I validate this with the isEmail Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "softhai@gmx.de", "valid": true }, 
                             { "data": "first.lastname@sub.company.abc", "valid": true },
                             { "data": "test@test@.de", "valid": false },
                             { "data": "test@.de", "valid": false }]);
  
  storyValidators.scenario("StartWithValidator")
                  ..given(text: "Input data that should be an String and [startWith] an string")
                    .and(text: "A StartWith validator", 
                         func: (context) { context.data["validator"] = startWith(context.data["pattern"], context.data["index"]); } )
                  ..when(text: "I validate this with the StartWith Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "abcdef", "pattern": "ab", "index": 0, "valid": true }, 
                             { "data": "abcdef", "pattern": "cd", "index": 2, "valid": true },
                             { "data": "abcdef", "pattern": "ef", "index": 0, "valid": false }]);
  
  storyValidators.scenario("EndWithValidator")
                  ..given(text: "Input data that should be an String and [endWith] an string")
                    .and(text: "A EndWith validator", 
                         func: (context) { context.data["validator"] = endWith(context.data["pattern"]); } )
                  ..when(text: "I validate this with the EndWith Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "abcdef", "pattern": "ef", "valid": true }, 
                             { "data": "abcdef", "pattern": "ab", "valid": false }]);
  
  // DateTime validation
  storyValidators.scenario("DateTimeValidator")
                  ..given(text: "Input data that should be an date time")
                    .and(text: "A DateTime validator", 
                         func: (context) { context.data["validator"] = isDateTime; } )
                  ..when(text: "I validate this with the isDateTime Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "20140208", "valid": true }, 
                             { "data": "2014-02-08", "valid": true },
                             { "data": "2014-02-08 16:00:22", "valid": true },
                             { "data": "08.02.2014 16:00:22", "valid": false }, // Only a subset ISO 8601 :-(
                             { "data": "2014-02-08 08:00:22 AM", "valid": false }]);
  
  
  storyValidators.scenario("InRangeDateTimeValidator")
                  ..given(text: "Input data that should be a date time and in a range of [from] to [to]")
                    .and(text: "A range validator", 
                         func: (context) { context.data["validator"] = inRangeDT(context.data["from"], context.data["to"]); } )
                  ..when(text: "I validate this with the inRangeDT Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "20130804", "from": new DateTime(2010, 01, 01), "to": new DateTime(2014, 01, 01), "valid": true }, 
                             { "data": "20140202", "from": new DateTime(2010, 01, 01), "to": new DateTime(2014, 01, 01), "valid": false }]);
  
  feature.run();
  
}

bool Validate(context) {
  context.data["result"] = context.data["validator"].isValid(context.data["data"]);
}