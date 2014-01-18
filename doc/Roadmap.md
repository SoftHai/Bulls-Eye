#Roadmap
```
Legend: [ ] Planned - [/] Progress - [X] Finished
```

- [X] URL Defenition
 - [X] Static Parts
 - [X] Variable Parts (Required / Optional)
 - [X] WildCard
 - [X] Query-Parameters (Required / Optional)

- [X] Server
 - [X] Routing
   - [X] Routing to Logic (e.g. Load data from database and return json)
   - [X] Routing to Files (e.g. pictures, css, js, html, ...)
   - [X] Handle routing Errors (e.g. NotFount, ...)

- [X] Replacing of Variables with Datas

**Milestone 1** (0.1.0 - 05 Jan 2014)

- [/] Bugfixes / Improvements
- Server
 - [X] Add Middleware Engine
 - [ ] Customizable Error Handling (404, ...)

**Milestone 2** (0.2.0 - Feb 2014)

- [ ] Bugfixes / Improvements
- Middleware
 - [ ] Vaidation
   - [ ] Route Variables
   - [ ] Query Variables
   - [ ] Post Data
  - [ ] feature toogle
   - [ ] GlobalContext
   - [ ] UserContext

**Milestone 3** (0.3.0)

- [ ] Middleware
 - [ ] Auth (Custom, OAuth, OpenID, ...)

**Milestone 4** (0.4.0)

- Middleware
 - [ ] Template Files pre processsing (using JS-Tamplate engines with Dart-JS-Bridge)
- Server
 - [ ] WebSocket support
   - [ ] WAMP-Protokoll
     - [ ] Using same Route defenition engine as WebServer
  - [ ] Apache Thrift
- [ ] ...

**Beta 1** (1.0.0-beta1)

**Stable** (1.0.0)