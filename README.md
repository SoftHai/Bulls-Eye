Bulls-Eye
=========

[![Build Status](https://drone.io/github.com/SoftHai/Bulls-Eye/status.png)](https://drone.io/github.com/SoftHai/Bulls-Eye/latest)

Bull's Eye is a Dart-IO Web-Server (like Node JS / Express). It should bring the speed of Dart to the server-side. To have an single language to program server and client.

Install
=========

Currently you have to use the source code from github.
In near future there will be a dartlang-pub-deployment for this. I will start with this when I reached my first Milestone (see road map below).

Example
=========
```dart

// Route defenition
var jsPath = new RouteDef("js/*");
var cssPath = new RouteDef("css/*");
var home = new RouteDef("");
var ToDoListItemRoute = new RouteDef("ToDo/:ListID/(:ItemID)");

// Create Server
var server = new Server();

// Define Routes
server..RegisterRoute(new FileRoute.fromUri(cssPath, methods: ["GET"], contentTypes: ["text/css"])) // Only CSS allowed
      ..RegisterRoute(new FileRoute.fromUri(jsPath, methods: ["GET"]))
      ..RegisterRoute(new FileRoute.fromPath(home, "html/home.html", methods: ["GET"]))
      ..RegisterRoute(new LogicRoute(ToDoListItemRoute, (context) {
        //Logic to execute here
      }, methods: ["GET"]));

// Start Server
server.start();
```

Lib Doc
=========
The Lib is devided into 3 parts:
* Common: Here are functions which are required on client and server side (e.g. route defenitions, ...)
 * [RouteDefenition](https://github.com/SoftHai/Bulls-Eye/blob/master/doc/RouteDefenition.md)
* Server: Here are the server side specific implementations
 * [Router](https://github.com/SoftHai/Bulls-Eye/blob/master/doc/Router.md)
* Client: Here are the client side specific impelmentations

To get an idea of the state, take a look at the example, doc and/or the tests.

Roadmap
=========
See [here](https://github.com/SoftHai/Bulls-Eye/blob/master/doc/Roadmap.md)

Targets
=========
* be extendable (e.g. via plugins)
* be easy
* be fast

FAQ
=========
*Why not using an available implementation?*

I know there are some projects out there which doing the same. But I want to build a server which fits more my needs and implements some features I missed on other implementations. <br/>
Another reason is to learn and study DART. It's like an case study to prove if it fits my requirements better than other languages (PHP, JS, Phython, Ruby, ...).
