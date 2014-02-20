#Feature Overview

This overview should you show what BullsEye make unique and different.

##Reuseable URL definition for Server and Client

**Global**

Defining the URL
```dart
// global.dart

var apiToDoListUrl = new Url("/api/:Version/todo/:ListID?:orderby");
```

**On Server**

Defining several routs with one URL definition:
```dart
// server.dart

var server = new Server();

server..route("POST", apiToDoListUrl, /* Logic for POST */)
      ..route("GET", apiToDoListUrl, /* Logic for GET */);
```

**On Client**

Replace URL Variables to send the request:
```dart
client.dart

var resolvedUrl = apiToDoListUrl.matcher.replace({ "Version" : "V1", "ListID" : 12345, "orderby": "desc" });

// Creates: /api/v1/todo/12345?orderby=desc
```

## Aspect oriented Middleware (AOM)

**On Server**

Creating complex middleware combination from Before, Around and After hooks.

```dart
// server.dart

// Defining different Middlewares for different needs
server.middleware("PublicArea")..before((context) { /* e.g. Validation */ })
                                ..around((context) { /* e.g. loging */ })
                                ..after((context) { /* e.g. post processing */ });

server.middleware("SecureArea")..before((context) { /* e.g. Validation */ })
								..before((context) { /* e.g. Auth */ })
                                ..around((context) { /* e.g. loging */ })
                                ..after((context) { /* e.g. post processing */ });

// Registering the middleware by name on the route
server..route("GET", homeURL, /* Logic */, middleware: "PublicArea")
      ..route("GET", contactURL, /* Logic */, middleware: "PublicArea")
      ..route("GET", aboutURL, /* Logic */, middleware: "PublicArea")

      ..route("GET", friendlistURL, /* Logic */, middleware: "SecureArea")
      ..route("GET", todoOverviewURL, /* Logic */, middleware: "SecureArea");

```

##Validation Firewall

Validate every incoming data one time by the validation engine.

**Global**

Defining URL variable validation during the URL definition

```dart
// Single definition of validating rules for URL Variables
var versionVar = new Version(extensions: { ValidatorKey: inList(["v1", "v2"]) }); // Allows only the two values "v1" and "v2"
var toDoListID = new Variable("ListID", extensions: { ValidatorKey: isInt }); // Allows only integer
var toDoItemID = new Variable("ItemID", extensions: { ValidatorKey: isInt }); // Allows only integer

// Multiple usage of the URL Variables
var apiToDoListUrl = new Url(["api", versionVar, "todo", toDoListID]); // e.g. api/v1/todo/12345
var apiToDoItemUrl = new Url(["api", versionVar, "todo", toDoListID, toDoItemID]); // e.g. api/v1/todo/12345/2345
```

**On Server**

Activating the validation middleware and defining validation rules for HEADER, COOKIE and BODY on the routes:
```dart
// server.dart

// Registering a middleware with the Validation-Hook
server.middleware("Validated").add(new Validation());

// Validate additional input data like HEADER, COOKIE and BODY
server..route("POST", apiToDoListUrl, /* Logic for POST */, middleware: "Validated", extensions: { BodyValidatorKey: isJSON, CookieValidatorKey: byKey({ "Auth": isInt }) }) // ABody must be JSON and Cookie "Auth" must have an int value (e.g. Session ID)

      ..route("GET", apiToDoListUrl, /* Logic for GET */, middleware: "Validated", extensions: { CookieValidatorKey: byKey({ "Auth": isInt }) });

      ..route("POST", apiToDoItemUrl, /* Logic for POST */, middleware: "Validated", extensions: { BodyValidatorKey: isJSON, CookieValidatorKey: byKey({ "Auth": isInt }) })

      ..route("GET", apiToDoItemUrl, /* Logic for GET */, middleware: "Validated", extensions: { CookieValidatorKey: byKey({ "Auth": isInt }) });
```

```dart
// server_logic.dart

Future SomeServerLogic1(ReqResContext context)
{
  // Check if the validation engin already validated the input
  if(context.request.body.isValidated && context.request.body.isValid)
  {
    // Do something with the body data
  }
}

Future SomeServerLogic2(ReqResContext context)
{
  // Check if somewhere already validates this input
  if(!context.request.body.isValidated)
  {
    // If not the validate
    // ...

    // Set Validation result to protect before multiple validation runs
    context.request.body.setValidated(true);
  }
}

```

**On Client**

Not yet implemented