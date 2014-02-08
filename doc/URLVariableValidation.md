#URL Variable validation

You can use the [validators](Validators.md) to validate the variables off an URL defenition. Thats the reason why you can create URLs with the object-style.

Example:
```dart
var api = new Static("api");
var version = new Version({ValidatorKey: inList(["v1", "v2"])});
var user = new Static("user");
var userID = new Variable("userID", extentions: {ValidatorKey: isInt});
var friendID = new Variable("friendID", extentions: {ValidatorKey: isInt});

var friendSearch = new QVariable("fsearch", extentions: {ValidatorKey: composed([isEmail(), isInt], OR)})

var url1 = new Url.fromObjects([api, version, user, userID], queryParts: [friendSearch], name: "User friends search api");

var url2 = new Url.fromObjects([api, version, user, userID, friendID], name: "User friend api access");
```

As you can see, you can define the validation rules, where you define the input data. Also you can reuse this definition across several URLs. That guaranteed you that all input data which use this URL variables, are validated.

Request with invalid data are reject and not reaching your logic. You can free you logic code from the validation stuff and handle this common task in the middleware.