#Validators

Validators are used to validate input data of requests. They can be used in:
 * [URLs](URLVariableValidation.md) (Variable validation)
 * Routes (Post data validation)

##String Validators

###StartWith / EndWith Validator

Checks if a string starts oder ends with an given pattern:
```dart
Validator startWith(Pattern pattern,[int index = 0]);

Validator endWith(Pattern pattern);
```

###RegEx Validator

You can use this validator to validate a string with an regular expression.
```dart
Validator isRegEx(RegExp regEx);
```
####Special RegEx Validators

* **IsEmail**

  Validates a string to be a valid email adress or not.
  ```dart
  Validator isEmail();
  ```

##ListValidators

###InList Validator

This validator acts like an enum. It checks if the data are in a list of strings.
```dart
Validator inList(List<String> list);
```

##Numeric Validators

###IsNum / IsInt Validator

This validators are checking if the given data are num (int or duouble) or int values.
```dart
Validator isNum;

Validator isInt;

```
###InRangeNum Validatior

This Validator checks if a num value in an a range from to.
```dart
Validator inRangeNum(num from, num to);
```

##DateTime Validators

###IsDateTime Validator

Checks if the input data are valid DateTime data (Only a subset of ISO 8601 are parsed, see `DateTime.parse` documentation).
```dart
Validator isDateTime;
```
###InRangeDT Validatior

This Validator checks if a DateTime value in an a range from to.
```dart
Validator inRangeDT(DateTime from, DateTime to);
```

###NotOlderThan Validator

Checks if given DateTime data are not older than a specific duration.
```dart
Validator notOlderThan(Duration duration);
```

##Bool Validators

###IsBool Validator

This validator checks if the given data are bool values. Bool values are `true`, `false`, `1`, `0` (not case sensetive).
```dart
Validator isBool;
```
##Other Validators

###Composed Validator

This validator allows you to define several validation rules for a single input. Also you can define if the rules are AND or OR connected.
```dart
Validator composed(List<Validator> validators, [String composeType = AND]);
```
##Own Validators

You can implement own Validators (e.g. for special checks) by implementing the interface `Validator`:
```dart

class CustomValidator implements Validator {

  bool isValid(data) {
    // your validation code here
  }
}
```

**If you have create a new validator which could be also interesting for other user, please contribute to the project and create a pull request. THANKS**
