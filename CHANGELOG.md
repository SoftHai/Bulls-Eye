#Changelog
```
Legend: (NEW) New Feature - (IMP) Improvement - (FIX) Bugfix
```

##Version 0.2.0-Alpha
**Release date: *not released* **

--------------------------------------------------------------
**Breaking Changes**
- Class `RouteDef` was renamed in `Url`
- Class `RoutePart` was renamed in `PathPart`
- Class `RouteDefConfig` was renamed in `UrlDefConfig`
- Class `UriMatcher` was renamed in `UrlMatcher`
- Class `LogicRoute` was renamed in `ExecuteCode` and refactored
- Class `FileRoute` was renamed in `LoadFile` and refactored
- Method `RegisterRoute` of the class `Server` was renamed in `route` and gots a new parameter order:

  ```dart
  // Old
  server.RegisterRoute(new FileRoute.fromUri(jsPath, methods: ["GET"]));
  // New - better readability
  server.route("GET", jsPath, new LoadFile.fromUrl());
  ``` 

--------------------------------------------------------------

- **(NEW)** Add Middleware
- **(IMP)** Documentation

##Version 0.1.0-Alpha
**Release date: *05 Jan 2014* **

- **(NEW)** Add [Route Defenition](/doc/URLDefenition.md) Structures
- **(NEW)** Add Route-Variable Replacing
- **(NEW)** Add Route-Variable Extracting
- **(NEW)** Add Route-Matching
- **(NEW)** Add WebServer
- **(NEW)** Add Server-Side Routing
