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

#Roadmap
```
Legend: [ ] Planned - [/] Progress - [X] Finished
```

- [X] Route Defenition
 - [X] Static Parts
 - [X] Variable Parts (Required / Optional)
 - [X] WildCard
 - [X] Query-Parameters (Required / Optional)

- [X] WebServer
 - [X] Routing
   - [X] Routing to Logic (e.g. Load data from database and return json)
   - [X] Routing to Files (e.g. pictures, css, js, html, ...)
   - [X] Handle routing Errors (e.g. NotFount, ...)

- [X] Replacing of Variables with Datas

**Milestone 1** (0.1.0 - 05 Jan 2014)

- Bugfixes / Improvements
- WebServer
 - [ ] Routing Server Side
   - [ ] Routing to Template Files (using JS-Tamplate engines with Dart-JS-Bridge)
 - [ ] Customizable Error Handling (404, ...)

**Milestone 2** (0.2.0 - Feb 2014)

- [ ] Add Middleware Engine
- [ ] Add Vaidation
  - [ ] Route Variables
  - [ ] Query Variables
  - [ ] Post Data

**Milestone 3** (0.3.0)

- [ ] Middleware
 - [ ] Add Auth (Custom, OAuth, OpenID, ...)

**Milestone 4** (0.4.0)

- [ ] WebSocket Server
 - [ ] WAMP-Protokoll
   - [ ] Using same Route defenition engine
- [ ] feature toogles engine
- [ ] ...

**Beta 1** (1.0.0-beta1)

**Stable** (1.0.0)