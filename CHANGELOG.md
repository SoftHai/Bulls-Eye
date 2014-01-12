#Changelog
```
Legend: (NEW) New Feature - (IMP) Improvement - (FIX) Bugfix
```

##Version 0.1.0-Alpha
**Release date: 05 Jan 2014**

- **(NEW)** Add [Route Defenition](https://github.com/SoftHai/Bulls-Eye/blob/master/doc/RouteDefenition.md) Structures
- **(NEW)** Add Route-Variable Replacing
- **(NEW)** Add Route-Variable Extracting
- **(NEW)** Add Route-Matching
- **(NEW)** Add WebServer
- **(NEW)** Add Server-Side Routing

##Version 0.2.0-Alpha
**Release date: not released**

**Breaking Changes (reason: fits more the defined names of an url, reduce name conflicts between url defenition and routing engine)**
- Class `RouteDef` was renamed in `Url`
- Class `RoutePart` was renamed in `PathPart`
- Class `RouteDefConfig` was renamed in `UrlDefConfig`
- Class `UriMatcher` was renamed in `UrlMatcher`
- Class `LogicRoute` was renamed in `ExecuteCode` and refactored to implement RouteLogic
- Class `FileRoute` was renamed in `LoadFile` and refactored to implement RouteLogic

**Breaking Changes**
- Method `RegisterRoute` of the class `Server` was renamed in `route`