Bulls-Eye
=========

Bull's Eye is a Dart-IO Web-Server (like Node JS / Express). It should bring the speed of Dart to the server-side. To have an single language to program server and client.

Why not using an available implementation?
I know there are some idetical projects out there which doing the same. But I want to build a server which fits more my needs and implements so features I missed on other implementations.
Another reason is to learn and study DART. It like an case study to profe if it fits my requirements better than other languages (PHP, JS, Phython, Ruby, ...).

Lib
=========
The Lib is devided into 3 parts:
* Common: Here are functions which are required on client and server side (e.g. route defenitions, ...)
* Server: Here are the server side specific implementations
* Client: Here are the client side specific impelmentations

State
=========
Very early alpha.
Implemented Features:
* Routing (Basic)

To get an idea of the state, take a look at the example and/or the tests.

Targets
=========
* be extendable (e.g. via plugins)
* be easy
* be fast


Roadmap
=========
* Routing Common (progress)
* Routing Server Side
* Routing Client Side
* Add Middleware (Auth, ...)
* Feature
* Feature
* Feature
* ...
