#Routing Engine

##Route Definition
The route defenition is located in the COMMON namespace. This is because the definition will be used in Client-Side (replacing Variables against data) and on the Server-Side (Parsing the route and extracting the Variables).

The route definition in BullsEye supports different styles:<br/>

* Objects
* Mixed (Objects, Strings)
* Single String

All styles have its own adventages and disadvantages. Internal the routes are working with the objects. So all strings are converted / parsed to objects.

Style with the best performance:
* Objects

Style with the best readablility:
* Single String

**So which style do you should use?** <br/>
It depends on which features of the routing engine you want to use. <br/>
* If you interested in readability and you want only to use the features this style supports, than use the "Single String Style".
* If you interested in performance and you want to use all features, the routing engine offers to you, than you schould use the "Objects Style"
* All other can use the "Mixed Style" to have the power of both worlds.

###Supported URL-Part

A URL-Part is all between two '/'. The following parts are supported:
* **Static**: This is an static string part of an URL (e.g. /`ToDo`/:ID)
* **Variable**: This in an part of the URL which is variable (e.g. an ID of an entity -> /ToDo/`:ID`).
 * **Version**: Version ins an special build-in variable which is used for API URLs which has an Version-Part in it (e.g. "`v1`/ToDo/:ID"). It will be used in feature for vaidating different versions.
* **Wildcard**: A Wildcard means that the rest of the URL be be what ever. Thats interesting if you have an folder with Lib-Files like \*.js or \*.css files which you want to handle all over the same logic (e.g. "/lib/JS/`*`")

###Object-Style

All parts of an URL are seperated in single objects: <br/>
**Example**<br/>
```dart
    // this produce the URL "ToDo/:ToDoListID/:ToDoItemID"
    var toDoItem = new RouteDef([new Static("ToDo"),
                             new Variable("ToDoListID"),
                             new Variable("ToDoItemID")]);
```

The following Objects are supported:
* **Static**: Takes a string in the constructor
* **Variable**: Takes a string (variable name) and an optional bool-Flag if it is an optinonal variable or not (default not optional)
* **Version**: Takes no parameter. Variable name is `Version` and optinal is `FALSE`
* **WildCard**: Takes no parameter. represent an *.

The Advantage is that it has the best performace (because the strings has not to be parsed) and you can use all feature that will be add in the future (e.g. vaidation, ...). <br/>
The disadvantage is that it has not a good readability.

###Single-String-Style

In the Single-String-Style you pass only a string to the RouteDef Object and that will be split and parsed into the objects: <br/>
**Example** <br/>
```dart
    var toDoItem = new RouteDef("ToDo/:ToDoListID/:ToDoItemID");
```

You can represent the parts as string in the following way:
* **Static**: any string between two '/'
* **Variable**: a variable starts with an ':'. To mark an variable as optional, surround it with round barkecks (e.g. "Foo/`(:variable)`/Bar")
 * **Version**: A Variable with the Name `Version` will be automatically parsed into an Version-Object.
* **WildCard**: a '*' defines that there can comes what ever

###Mixed-Style
In the Mixed-Style you can combine both worlds. But it makes most sence if you have more static than variable parts:<br/>
**Example**<br/>
```dart
    var path = new RouteDef(["Part1/Part2/Part3/",
                            new Variable("Var"),
                            "Part4/Part5/"]);
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
