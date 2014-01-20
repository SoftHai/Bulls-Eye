Bulls-Eye
=========

[![Build Status](https://drone.io/github.com/SoftHai/Bulls-Eye/status.png)](https://drone.io/github.com/SoftHai/Bulls-Eye/latest)

Bull's Eye is a Dart-IO Web Application Framework (like Express on Node.js). 
It should bring the speed of Dart to the server-side. To have an single language to program server and client.

![Example Workflow](/doc/Server/img/Bulls-Eye-Server - Middleware.png)

[Bulls-Eye on Dart Package Manager](http://pub.dartlang.org/packages/bulls_eye)

Install
=========

You can get Bulls-Eye from the Dart Pub Manager.<br/>
**Get the Package**
* Add the dependancy 'bulls_eye' to your pubspec.yaml
 * Via the DartEditor dialog
 * By adding the following to the file:
   ```
   dependencies:
       bulls_eye: any
   ```
* Update your depandancies by running `pub install`

**Use the Package**
```dart
import 'package:bulls_eye/common.dart'; // For URL defenition
import 'package:bulls_eye/server.dart'; // For using the web server
```

Example
=========
```dart

// Route defenition
var jsPath = new RouteDef("js/*"); // Add a wildcard '*' to match all routes they start with the defined route
var cssPath = new RouteDef("css/*");
var home = new RouteDef("");
var toDoListItemRoute = new RouteDef("ToDo/:ListID/(:ItemID)"); // Define route variables 'ListID' and optional route variables 'ItemID'
var searchRoute = new RouteDef("search?q&(ResultCount)"); // Define query variables 'q' and optional query variables 'ResultCount'

// Create Server
var server = new Server();

// Middleware
// Add some middleware code which can be executed before, around and/or after the route logic.
server.middleware("Example")..before((context) => print("do something before the route logic (e.g. validation, auth, ...)"))
                         ..after((context) => print("do something after the route logic"))
                         ..around((context, ctrl) {
                             print("do something before ...");
                             return ctrl.next()
                                        .then((_) => print("and after the route logic (e.g. logging, performance tests, ...)"));
                           });
// ... define more middleware combination if you need

// Define Routes
server..route("GET", cssPath, new LoadFile.fromUrl(), contentTypes: ["text/css"]) // Only CSS allowed
      ..route("GET", jsPath, new LoadFile.fromUrl())
      ..route("GET", jshome, new LoadFile.fromPath("client/jshome.html"))
      ..route("GET", darthome, new LoadFile.fromPath("client/darthome.html"), middleware: "Example") // Use the middleware defenition where you need
      ..route("GET", about, new ExecuteCode((context) {
      	//Logic to execute here
      }));
      ..route("GET", searchRoute, new ExecuteCode((context) {
      	// Search logic to execute here
      }));

// Start Server
server.start();
```

Lib Doc
=========
The Lib is devided into 3 parts:
* Common: Here are functions which are required on client and server side (e.g. url defenitions, ...)
 * [URLDefenition](/doc/URLDefenition.md)
* Server: Here are the server side specific implementations
 * [Server](/doc/Server/Server.md)
    * [Routing](/doc/Server/Server.md#route)
    * [Middleware](/doc/Server/Server.md#middleware)
* Client: Here are the client side specific impelmentations

To get an idea of the state, take a look at the example, doc and/or the tests.

Changelog
=========
See [here](/CHANGELOG.md)

Roadmap
=========
See [here](/doc/Roadmap.md)

Targets
=========
Building a Web Application Framework specialize for RESTful, Webservices and SinglePage WebApplications. 

It should be:
* extendable
* easy
* and fast

FAQ
=========
*Why not using an available implementation?*

I know there are some projects out there which doing the same. But I want to build a server which fits more my needs and implements some features I missed on other implementations. <br/>
Another reason is to learn and study DART. It's like an case study to prove if it fits my requirements better than other languages (PHP, JavaScript, Python, Ruby...).
