Bulls-Eye
=========

[![Build Status](https://drone.io/github.com/SoftHai/Bulls-Eye/status.png)](https://drone.io/github.com/SoftHai/Bulls-Eye/latest)

Bull's Eye is a Dart-IO Web Application Framework (like Express on Node.js). 
It should bring the speed of Dart to the server-side. To have an single language to program server and client.

[Feature Tour](/doc/feature_overview.md)

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

// URL part definition incl. Validation rules
var todo = new Static("todo");
var listID = new Variable("ListID", extensions: { ValidationKey: isInt }); // Define the validation rule for the variable to be handled by the validation middleware
var itemID = new Variable("ItemID", isOptional: true, extensions: { ValidationKey: isInt }); // Define the validation rule for the variable to be handled by the validation middleware

// Route defenition
var jsPath = new Url("js/*"); // Add a wildcard '*' to match all routes they start with the defined route
var cssPath = new Url("css/*");
var home = new Url("");
var toDoListItemUrl = new Url.fromObj([todo, listID, itemID]); // use the URL Parts in several routes
var searchUrl = new Url("search?q&(MaxResults)"); // Define query variables 'q' and optional query variables 'MaxResults'

// Create Server
var server = new Server();

// Middleware
// Add complex middleware combinations which can be executed before, around and/or after the route logic.
server.middleware("PublicArea")..add(new Validation())
                                ..around((context) { /* e.g. loging */ })
                                ..after((context) { /* e.g. post processing */ });

server.middleware("SecureArea")..add(new Validation())
								..before((context) { /* e.g. Auth */ })
                                ..around((context) { /* e.g. loging */ })
                                ..after((context) { /* e.g. post processing */ });
// ... define more middleware combination if you need

// Define Routes
server..route("GET", cssPath, new LoadFile.fromUrl(basePath: "x:/project/css/"), contentTypes: ["text/css"]) // Only CSS allowed
      ..route("GET", jsPath, new LoadFile.fromUrl(basePath: "x:/project/js/")) // defining an optional basePath (basepath + wildcard = filepath)

      ..route("GET", home, new LoadFile.fromPath("client/home.html"), middleware: "PublicArea") // Use the middleware for public access

      ..route("GET", toDoListItemUrl, new ExecuteCode((context) {
      	//Logic to execute here
      }), middleware: "SecureArea"); // Use the middleware for secure access

      ..route("POST", toDoListItemUrl, new ExecuteCode((context) {
      	//Logic to execute here
      }), middleware: "SecureArea", extensions: { BodyValidatorKey: isJSON }); // Validate the body an check if it is a JSON body

      ..route("GET", searchUrl, new ExecuteCode((context) {
      	// Search logic to execute here
      }), middleware: "SecureArea"); // Use the middleware for secure access

// Start Server
server.start();
```

Documentation
=========
[Feature Tour](/doc/feature_overview.md)

The Lib is devided into 3 parts:
* Common: Here are functions which are required on client and server side (e.g. url defenitions, ...)
 * [URLDefenition](/doc/URLDefenition.md)
    * [validators](/doc/Validators.md) [Usage](/doc/URLVariableValidation.md)
* Server: Here are the server side specific implementations
 * [Server](/doc/Server/Server.md)
    * [Routing](/doc/Server/Server.md#route)
    * [Middleware](/doc/Server/Middleware.md)
      * [Validation](/doc/Server/Middleware_Validation.md)
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
* secure
* and fast

FAQ
=========
*Why not using an available implementation?*

I know there are some projects out there which doing the same. But I want to build a server which fits more my needs and implements some features I missed on other implementations. <br/>
