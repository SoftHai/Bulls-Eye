Bulls-Eye
=========

Bull's Eye is a Dart-IO Web-Server (like Node JS / Express). It should bring the speed of Dart to the server-side. To have an single language to program server and client.

Install
=========

Currently you have to use the source code from github.
In near future there will be a dartlang-pub-deployment for this. I will start with this when I reached my first Milestone (see road map below).

Lib
=========
The Lib is devided into 3 parts:
* Common: Here are functions which are required on client and server side (e.g. route defenitions, ...)
 * [RouteDefenition](https://github.com/SoftHai/Bulls-Eye/blob/master/doc/RoutingEngine.md)
* Server: Here are the server side specific implementations
 * [Router](https://github.com/SoftHai/Bulls-Eye/blob/master/doc/RoutingEngine.md)
* Client: Here are the client side specific impelmentations

State
=========
Very early alpha.
Implemented Features:
* Routing (Basics)

To get an idea of the state, take a look at the example and/or the tests.

Targets
=========
* be extendable (e.g. via plugins)
* be easy
* be fast


Roadmap
=========
* Routing Common (progress)
 * Add Query-Parameters
* Routing Server Side (progress)

**Milestone 1** (Jan 2014)

* Routing Client Side

**Milestone 2** (feb 2014)

* Add Middleware Engine
 * Add Vaidation

** Milestone 3**

* Middleware
 * Add Auth

** Milestone 4**

* Feature
* Feature
* Feature
* ...

FAQ
=========
*Why not using an available implementation?*

I know there are some projects out there which doing the same. But I want to build a server which fits more my needs and implements some features I missed on other implementations. <br/>
Another reason is to learn and study DART. It's like an case study to profe if it fits my requirements better than other languages (PHP, JS, Phython, Ruby, ...).
