#Routing Engine

##Route Definition
The route defenition is located in the COMMON namespace. This is because the definition will be used in Client-Side (replacing Variables against data) and on the Server-Side (Parsing the route and extracting the Variables).

The route defenition is presented by the object `RouteDef`.

You can create a route defenition by passing the route in different styles to the RouteDef Constructors. The following styles (constructors) are supported:<br/>

* Objects (Constructor: `RouteDef.fromObjects(...)`)
* Mixed  (Constructor: `RouteDef.fromMixed(...)`)
* String (Constructor: `RouteDef(...)`)

All styles have its own adventages and disadvantages (see below).

Optional you can pass a Route-Name for the `RouteDef`. By default that will be the route string (`route.toString()`). This name will be used in Exceptions, Outputs and so one. <br/>
Its easier to recognize a route named "ToDo List Item" than "/ToDo/:List/:item". Especially with many long routes.

###Supported URL-Part

A URL-Part is all between two '/'. The following parts are supported:
* **Static**: This is an static string part of an URL (e.g. /`ToDo`/:ID)
* **Variable**: This in an part of the URL which is variable (e.g. an ID of an entity -> /ToDo/`:ID`).c
* **Wildcard**: A Wildcard means that the rest of the URL be be what ever. Thats interesting if you have an folder with Lib-Files like \*.js or \*.css files which you want to handle all over the same logic (e.g. "/lib/JS/`*`")
 * **QueryVariables**: This are additional URL query data (e.g. /search/?`q=searchword`)

####Special URL-Variable-Parts

You can create own special variables by inherit from the class `Variable`. That can be useful to have variables which interact better with features. <br/>
e.g. there is an special Variable `Version`. It is used for API URLs to know which version is called and to use the right validation for this Version (Part1/`v1`/Part3/Part4/...) and to know which Version of return data you have to response. <br/>
And there will be some other features in the future which make use of this.

###Object-Style

All parts of an URL are seperated in single objects: <br/>
**Example**<br/>
```dart
// this produce the URL "ToDo/:ToDoListID/(:ToDoItemID)"
var toDoItem = new RouteDef.fromObjects([
                      new Static("ToDo"),
                      new Variable("ToDoListID"),
                      new Variable("ToDoItemID", true)]
                      queryParts: [new QVariable("q")],
                      name: "Optional Name");
```

The following Objects are supported:
* **Static**: Takes a string in the constructor
* **Variable**: Takes a string (variable name) and an optional bool-Flag if it is an optinonal variable or not (default not optional)
* **WildCard**: Takes no parameter. represent an *.
* **QVariable**: Takes a string (variable name) and an optional bool-Flag if it is an optinonal variable or not (default not optional)

The Advantage is that it has the best performace (because the strings has not to be parsed) and you can use all feature that will be add in the future (e.g. vaidation, ...). <br/>
The disadvantage is that it has not a good readability but you can solve this by adding a commet with the String-Style (see example above).

###String-Style

In the String-Style you pass only a string to the RouteDef Object and that will be split and parsed into the objects: <br/>
**Example** <br/>
```dart
var toDoItem = new RouteDef("ToDo/:ToDoListID/:ToDoItemID?q");
```

You can represent the parts as string in the following way:
* **Static**: any string between two '/'
* **Variable**: a variable starts with an ':'. To mark an variable as optional, surround it with round barkecks (e.g. "Foo/`(:variable)`/Bar")
* **WildCard**: a '*' defines that there can comes what ever
* **QueryVariable**: Add the query variables without the '=value' part (e.g. search?`var1`&`var2`)

####Customizing the String-Style

The default configuration use the folowing values:
* Variable-Start: `:`
* Variable-End: ` `
* Variable-Optional-Start: `(`
* Variable-Optional-End: `)`
* WildCard: `*`

A URL-Defenition with the default config looks like this: <br/>
`Part1/:Var/(:OptVar)/Part3/*`

You can change this by executing the `RouteDefConfig` constructor: <br/>
`var custConfig = new RouteDefConfig.Costumize("{", "}", "!", "", "%");` <br/>
**Attantion:** This must be happens before you create any `RouteDef`. Otherwise the `RouteDef`until this code will use the default.

After that, the URL-Defenition use the following style:<br/>
`Part1/{Var}/!{OptVar}/Part3/%?QVar1&{QVar2}`

This is useful if you migrate from another engine to bullseye and you want to copy and past the URL defenition.

###Mixed-Style
In the Mixed-Style you can combine both worlds. But it makes most sence if you have more static than variable parts:<br/>
**Example**<br/>
```dart
var path = new RouteDeffromMixed([
                           "Part1/Part2/Part3/",
                            new Variable("Var"),
                            "Part4/Part5",
                            new QVariable("q")]);
```

###Warnings

####Several Optional Variables in a row
If you use 2 or more optional variables in a row than the variable parsing could have problems: <br/>
**Example**: <br/>
`"/Part1/(:OptVar1)/(:OptVar2)/Part2/Part3"`

That would match an extract the following URLs: <br/>
`"Part1/Var1/Part2/Part3"` -> OptVar1 = Var1, OptVar2 = Var1 <br/>
`"Part1/Var2/Part2/Part3"` -> OptVar1 = Var2, OptVar2 = Var2 <br/>
`"Part1/Var1/Var2/Part2/Part3"` -> OptVar1 = Var1, OptVar2 = Var2 <br/>

If you need several optional parameters in the url, devide these by a static part: <br/>
**Example**: <br/>
`"/Part1/(:OptVar1)/Part3/(:OptVar2)/Part3/Part4"`

####Optional Variables combined with WildCard
If you use an Optinal-Variable together with an WildVard than you could have the following problems: <br/>
**Example**: <br/>
`"/Part1/(:OptVar1)/*"`

That would match an extract the following URLs: <br/>
`"Part1/Var1/Foo/Bar"` -> OptVar1 = Var1 <br/>
`"Part1/Foo/Bar"` -> OptVar1 = Foo

To protect this, put an static part between the variable and the wildcard: <br/>
**Example**: <br/>
`"/Part1/(:OptVar1)/Part2/*"`

###FAQ

*So which style do you should use?* <br/>

It depends on which features of the routing engine you want to use. <br/>
* If you interested in readability and you want only to use the features this style supports, than use the "String Style".
* If you interested in performance and you want to use all features, the routing engine offers to you (e.g. build in validation), than you schould use the "Objects Style"
* All other can use the "Mixed Style" to have the power of both worlds.
