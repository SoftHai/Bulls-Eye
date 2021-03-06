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
   - [X] Handle routing Errors (e.g. NotFound, ...)

- [X] Replacing of Variables with Datas

**Milestone 1** (0.1.0 - 05 Jan 2014)

- [X] Bugfixes / Improvements
- Server
 - [X] Add Middleware Engine
 - [X] Customizable Error Handling (404, ...)

**Milestone 2** (0.2.0 - 05 Feb 2014)

- [X] Bugfixes / Improvements
- Middleware
 - [X] (#7) Vaidation
    - [X] Path Variables
    - [X] Query Variables
    - [X] Body Data
    - [X] Header Data
    - [X] Cookies

**Milestone 3** (0.3.0 - 27 Feb 2013)

- [ ] Bugfixes / Improvements
- Middleware
  - Validation
    - [ ] Add more Validators (MinStrLen, MaxStrLen, numGreater, numSmaller, ...)
  - [ ] Sanitizer
  - [ ] feature toogle
    - [ ] GlobalContext
    - [ ] UserContext
  
**Milestone 4** (0.4.0)

- [ ] Bugfixes / Improvements
- Middleware
 - [ ] Auth (Custom, OAuth, OpenID, ...)
 - [ ] Statistic Collector
   - [ ] Collect (Caller, URL, Browser, SourceURL, ...)
   - [ ] Custom Statistic Handler (e.g. store to database, ...) 
 - [ ] Template Files post processsing (using JS-Tamplate engines with Dart-JS-Bridge)
- Server
 - [ ] WebSocket support
   - [ ] WAMP-Protokoll
     - [ ] Using same Route defenition engine as WebServer
  - [ ] Apache Thrift
- [ ] ...

**Beta 1** (1.0.0-beta1)

**Stable** (1.0.0)
