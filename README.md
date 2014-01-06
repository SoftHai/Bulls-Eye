Bulls-Eye
=========

[![Build Status](https://drone.io/github.com/SoftHai/Bulls-Eye/status.png)](https://drone.io/github.com/SoftHai/Bulls-Eye/latest)

Bull's Eye is a Dart-IO Web-Server (like Node JS / Express). It should bring the speed of Dart to the server-side. To have an single language to program server and client.

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
import 'package:bulls_eye/BullsEyeCommon/bulls_eye_common.dart'; // For route defenition
import 'package:bulls_eye/BullsEyeServer/bulls_eye_server.dart'; // For using the web server
```
**Note:** *I will change this in future to 'bulls_eye/common.dart' and  'bulls_eye/server.dart'*

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

// Define Routes
server..RegisterRoute(new FileRoute.fromUri(cssPath, methods: ["GET"], contentTypes: ["text/css"])) // Only CSS allowed
      ..RegisterRoute(new FileRoute.fromUri(jsPath, methods: ["GET"]))
      ..RegisterRoute(new FileRoute.fromPath(home, "html/home.html", methods: ["GET"]))
      ..RegisterRoute(new LogicRoute(toDoListItemRoute, (context) {
        //Logic to execute here
      }, methods: ["GET"]));
	 ..RegisterRoute(new LogicRoute(searchRoute, (context) {
        // Search logic to execute here
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
 * WebServer
* Client: Here are the client side specific impelmentations

To get an idea of the state, take a look at the example, doc and/or the tests.

Changelog / Roadmap
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
Another reason is to learn and study DART. It's like an case study to prove if it fits my requirements better than other languages (PHP, JavaScript, Python, Ruby...).
