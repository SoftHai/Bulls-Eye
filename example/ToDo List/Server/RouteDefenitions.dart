library softhai.Example.ToDo.Common;

import '../../../lib/BullsEyeCommon/bulls_eye_common.dart';

// ----------Variable Parts----------
var toDo = new Static("ToDo");
var version = new Version();
var listID = new Variable("ListID");
var itemID = new Variable("ItemID");

// ----------Route Defenition - Page----------

// Gobal Pathes
var jsPath = new RouteDef("js/*", "JS File access");
var dartPath = new RouteDef("dart/*", "Dart File access");
var cssPath = new RouteDef("css/*", "CSS File access");

// Pages
var jshome = new RouteDef("", "Home JavaScript");
var darthome = new RouteDef("darthome", "Home Dart");
var about = new RouteDef.fromObjects([new Static("about")], name: "Aboute Route");
var todoLists = new RouteDef.fromObjects([toDo], name: "ToDo Lists Route");
var todoList = new RouteDef.fromObjects([toDo, listID], name: "ToDo List Route");
var todoItem = new RouteDef.fromObjects([toDo, listID, itemID], name: "ToDo Item Route");

// ----------Route Defenition - API----------
var api_todoLists = new RouteDef.fromObjects([version, toDo], name: "API: ToDo Lists Route");
var api_todoList = new RouteDef.fromObjects([version, toDo, listID], name: "API: ToDo List Route");
var api_todoItem = new RouteDef.fromObjects([version, toDo, listID, itemID], name: "API: ToDo Item Route");