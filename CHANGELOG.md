#Changelog
```
DateFormat: DD.MM.YYYY
Legend: (NEW) New Feature - (IMP) Improvement - (FIX) Bugfix - (!!!) Attantion (e.g. Breaking Changes)
```

##Version 0.3.0-Alpha
**Release date: *Not Released* **

--------------------------------------------------------------
- **(!!!) Changed constructor optional parameter of `Variable` from positional to named**
- **(!!!) Changed constructor optional parameter of `QVariable` from positional to named**

--------------------------------------------------------------

- **(NEW)** (#7) Add a validation engine with predefined [validators](/doc/Validators.md)

##Version 0.2.0-Alpha
**Release date: *05 Feb 2014* **

--------------------------------------------------------------
- **(!!!) Class `RouteDef` was renamed in `Url`**
- **(!!!) Class `RoutePart` was renamed in `PathPart`**
- **(!!!) Class `RouteDefConfig` was renamed in `UrlDefConfig`**
- **(!!!) Class `UriMatcher` was renamed in `UrlMatcher`**
- **(!!!) Class `LogicRoute` was renamed in `ExecuteCode` and refactored**
- **(!!!) Class `FileRoute` was renamed in `LoadFile` and refactored**
- **(!!!) Method `RegisterRoute` of the class `Server` was renamed in `route` and gots a new parameter order:**

  ```dart
  // Old
  server.RegisterRoute(new FileRoute.fromUri(jsPath, methods: ["GET"]));
  // New - better readability
  server.route("GET", jsPath, new LoadFile.fromUrl());
  ``` 
- **(!!!) (#4) Renamed the Common-Lib import from `package:bulls_eye/BullsEyeCommon/bulls_eye_common.dart` to `package:bulls_eye/common.dart`**
- **(!!!) (#4) Renamed the Server-Lib import from `package:bulls_eye/BullsEyeCommon/bulls_eye_server.dart` to `package:bulls_eye/server.dart`**

--------------------------------------------------------------

- **(NEW)** Add [Middleware](/doc/Server/Middleware.md)
- **(IMP)** Add funxtion `exception` to `Server` object for custom exception handling
- **(IMP)** Documentation
- **(FIX)** A Problem with extracting variables from URLs with only required variables (Route and Query)

##Version 0.1.0-Alpha
**Release date: *05 Jan 2014* **

- **(NEW)** Add [Route Defenition](/doc/URLDefenition.md) Structures
- **(NEW)** Add Route-Variable Replacing
- **(NEW)** Add Route-Variable Extracting
- **(NEW)** Add Route-Matching
- **(NEW)** Add WebServer
- **(NEW)** Add Server-Side Routing
