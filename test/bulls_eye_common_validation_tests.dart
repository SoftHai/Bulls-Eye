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
  
  storyValidators.scenario("NoOlderThanValidator")
                  ..given(text: "Input data that should be a date time and not longer in the past than [duration]")
                    .and(text: "A not older than validator", 
                         func: (context) { context.data["validator"] = notOlderThan(context.data["duration"]); } )
                  ..when(text: "I validate this with the notOlderThan Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": new DateTime.now().subtract(new Duration(days: 120)).toString(), "duration": new Duration(days: 360), "valid": true }, 
                             { "data": new DateTime.now().subtract(new Duration(days: 400)).toString(), "duration": new Duration(days: 360), "valid": false }]);
  
  // Bool Validation
  storyValidators.scenario("IsBoolValidator")
                  ..given(text: "Input data that should be an bool")
                    .and(text: "A bool validator", 
                         func: (context) { context.data["validator"] = isBool; } )
                  ..when(text: "I validate this with the isBool Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "true", "valid": true }, 
                             { "data": "false", "valid": true },
                             { "data": "1", "valid": true },
                             { "data": "0", "valid": true },
                             { "data": "abc", "valid": false }]);
  
  // Other
  storyValidators.scenario("InListValidator")
                  ..given(text: "Input data that should be a string in a list of strings")
                    .and(text: "A InList validator", 
                         func: (context) { context.data["validator"] = inList(context.data["listData"]); } )
                  ..when(text: "I validate this with the InList Validator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "soft", "listData": ["soft", "hai", "bulls", "eye"], "valid": true }, 
                             { "data": "eye", "listData": ["soft", "hai", "bulls", "eye"], "valid": true },
                             { "data": "spec", "listData": ["soft", "hai", "bulls", "eye"], "valid": false }]);
  
  storyValidators.scenario("ComposedValidators OR")
                  ..given(text: "Input data that should be a an Email or a Integer")
                    .and(text: "A composed validator", 
                         func: (context) { context.data["validator"] = composed([isEmail(), isInt], OR); } )
                  ..when(text: "I validate this with the ComposedValidator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "softhai@gmx.de", "valid": true }, 
                             { "data": "100", "valid": true },
                             { "data": "softhai", "valid": false }]);
  
  storyValidators.scenario("ComposedValidators AND")
                  ..given(text: "Input data that should be a an Email and in a list")
                    .and(text: "A composed validator", 
                         func: (context) { context.data["validator"] = composed([isEmail(), inList(["softhai@gmx.de"])], AND); } )
                  ..when(text: "I validate this with the ComposedValidator", 
                         func: Validate)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "softhai@gmx.de", "valid": true }, 
                             { "data": "somewhere@company.de", "valid": false }]);
  
  storyValidators.scenario("VersionDepValidator")
                  ..given(text: "Input data that should be a validated depended on the version")
                    .and(text: "A VersionDep validator", 
                         func: (context) { context.data["validator"] = versionDep({ "v1": isBool, "v2": isInt }); } )
                  ..when(text: "I validate this with the VersionDep Validator", 
                         func: ValidateVersionDep)
                  ..than(text: "The data should be valid?", 
                         func: (context) { 
                           expect(context.data["result"], equals(context.data["valid"])); })
                  ..example([{ "data": "1", "version": "v1", "valid": true }, 
                             { "data": "true", "version": "v1", "valid": true },
                             { "data": "10", "version": "v1", "valid": false },
                             { "data": "true", "version": "v2", "valid": false },
                             { "data": "10", "version": "v2", "valid": true }]);
  
  feature.run();
  
}

bool Validate(context) {
  context.data["result"] = context.data["validator"].isValid(context.data["data"]);
}

bool ValidateVersionDep(context) {
  context.data["result"] = context.data["validator"].isValid(context.data["data"], context.data["version"]);
}