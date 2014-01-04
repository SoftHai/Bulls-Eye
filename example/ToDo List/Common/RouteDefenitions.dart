library softhai.Example.ToDo.Common;

import '../../../lib/BullsEyeCommon/bulls_eye_common.dart';

// ----------Variable Parts----------
var toDo = new Static("ToDo");
var version = new Version();
var listID = new Variable("ListID");
var itemID = new Variable("ItemID");

// ----------Route Defenition - Page----------

// Gobal Pathes
var jsPath = new RouteDef("js/*");
var cssPath = new RouteDef("css/*");

// Pages
var home = new RouteDef("");
var about = new RouteDef.fromObjects([new Static("about")], "Aboute Route");
var todoLists = new RouteDef.fromObjects([toDo], "ToDo Lists Route");
var todoList = new RouteDef.fromObjects([toDo, listID], "ToDo List Route");
var todoItem = new RouteDef.fromObjects([toDo, listID, itemID], "ToDo Item Route");

// ----------Route Defenition - API----------
var api_todoLists = new RouteDef.fromObjects([version, toDo], "API: ToDo Lists Route");
var api_todoList = new RouteDef.fromObjects([version, toDo, listID], "API: ToDo List Route");
var api_todoItem = new RouteDef.fromObjects([version, toDo, listID, itemID], "API: ToDo Item Route");