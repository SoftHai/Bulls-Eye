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
**Example:** Lets say you have an variables which transfers a formular value birthday of a user. And only people up to 120 years are valid.
```dart
var birthday = new QVariable("birthday", extensions: {ValidationKey: notOlderThan(new Duration(days: 120 * 360)) })
```
* A Call to a URL like `...?birthday=20000101` is valid
* A Call to a URL like `...?q=18500101` is not valid because its more in the past than 120 years.

##Bool Validators

###IsBool Validator

This validator checks if the given data are bool values. Bool values are `true`, `false`, `1`, `0` (not case sensetive).
```dart
Validator isBool;
```
##Other Validators

###Composed Validator

This validator allows you to define several validation rules for a single input. Also you can define if the rules are `AND` or `OR` connected.
```dart
Validator composed(List<Validator> validators, [String composeType = AND]);
```
**Example:** Validating a search-variable with different validators
Lets say you have a search-URL where user can search for different thinks. So not all strings are valid. Lets say the user can search by numbers and also by email. All other are no valid.
```dart
var search = new QVariable("q", extensions: {ValidationKey: composed([isInt, isEmail()], OR) })
```
* A Call to a URL like `...?q=123` is valid
* A Call to a URL like `...?q=test@gmx.de` is valid
* A Call to a URL like `...?q=some name` is not valid because it is not a number or a email

###InList Validator

This validator acts like an enum. It checks if the data are in a list of strings.
```dart
Validator inList(List<String> list);
```
**Example:** Validating if the `Version`-Variable has a valid version key.

Lets say that you have release 2 versions of your API (v1 and v2) and only this values are valid for the `Version`-Variable
```dart
var version = new Version(extensions: {ValidationKey: inList(["v1", "v2"]) })
```
* A call to a URL like `.../v1/...` is valid.
* A call to a URL like `.../v3/...` is not valid because `v3` is not in the list.

###VersionDep Validator

This validator checks depended on the version-Variable the input data. This is helpful for APIs which change over the time. So is in API v1 a value of 10 to 20 valid. In API v2 is a value of 10 to 30 valid, because you made some extensions.
```dart
Validator versionDep(Map<String, Validator> versionValidator, [bool invalidIfNoValidatorFound = true]);
```
You can register a validator with the key `ValidatorByVersion.defaultVersionValidator` to define which validator should be used if there was no matched version key.

**Example:** Validating a variable depending on the `Version`-Variable

If you have an API than you need sometimes to update your API to fit new requirements. Also you can't shut down the old version because there are applications out there which still needs this.
For this case you can define version depending validations.
Lets say that a variables was in the API v1 a bool and in the API v2 you need more values and change it to an int
```dart
var version = new Version(); // You need a version variable
var variable = new QVariable("flag", extensions: { ValidationKey: versionDep({ "v1": isBool, "v2": isInt} ) })
```
* A call to a URL like `.../v1/..?flag=1` is valid
* A call to a URL like `.../v2/..?flag=100` is also valid
* A call to a URL like `.../v1/..?flag=100` is not valid because it is not bool.

##Own Validators

You can implement own Validators (e.g. for special checks) by implementing the interface `Validator`:
```dart
class CustomValidator implements Validator {

  bool isValid(data) {
    // your validation code here
  }
}
```
Or `ValidatorByVersion`:
```dart
class CustomValidator implements ValidatorByVersion {

  bool isValid(data, [versionValue = defaultVersionValidator]) {
    // your validation code here
  }
}
```

**If you have create a new validator which could be also interesting for other user, please contribute to the project and create a pull request. THANKS**
