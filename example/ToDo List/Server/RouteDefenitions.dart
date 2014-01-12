library softhai.Example.ToDo.Common;

import '../../../lib/BullsEyeCommon/bulls_eye_common.dart';

// ----------Variable Parts----------
var toDo = new Static("ToDo");
var version = new Version();
var listID = new Variable("ListID");
var itemID = new Variable("ItemID");
var searchQuery = new QVariable("q");
// ----------Route Defenition - Page----------

// Gobal Pathes
var jsPath = new Url("js/*", "JS File access");
var dartPath = new Url("dart/*", "Dart File access");
var cssPath = new Url("css/*", "CSS File access");

// Pages
var jshome = new Url("", "Home JavaScript");
var darthome = new Url("darthome", "Home Dart");
var about = new Url.fromObjects([new Static("about")], name: "Aboute Route");
var todoLists = new Url.fromObjects([toDo], name: "ToDo Lists Route");
var todoList = new Url.fromObjects([toDo, listID], name: "ToDo List Route");
var todoItem = new Url.fromObjects([toDo, listID, itemID], name: "ToDo Item Route");
var search = new Url.fromObjects([new Static("search")], queryParts: [searchQuery], name: "ToDo Item Route");

// ----------Route Defenition - API----------
var api_todoLists = new Url.fromObjects([version, toDo], name: "API: ToDo Lists Route");
var api_todoList = new Url.fromObjects([version, toDo, listID], name: "API: ToDo List Route");
var api_todoItem = new Url.fromObjects([version, toDo, listID, itemID], name: "API: ToDo Item Route");