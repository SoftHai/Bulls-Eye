#Server

The Bulls-Eye server is the main class in the server-side Bulls-Eye framework.

The server currently support the following functions:
* Defining route based on the URL defenition
* Adding middleware code
* Hosting the server


##Basics

###Creating a Bulls-Eye server
You can create an Bulls-Eye `Server` with the following constructors:
```dart
// Default constructor
Server({bool debug: false});
```
Default constructor parameter:
* **debug *(optional, default: false)* **: This is optional and controls curretly the log outputs to the console

###Custom Exception handling
You can register a custom exception handler by calling the function `exception` of the `Server` object:
```dart
void exception(bool handler(HttpRequestException ex))
```
In the custom exception handler you can handle the exception in your way. By returning `false` or `null` the default exception handling will handle the exception. Returning `true` means that the custom code has handled the exception.

###The ReqResContext
The `ReqResContext` is an object which is created for each incoming call. It has the following properties:
* **request**: Contains all Data of the request
  * **method**: Return the Mothod of the request
  * **route**: Contains informations about the current executed route
    * **extensions**: Cointains the registered extensions of the current route
    * **definition**: contains the `Url` definition of the current route
    * **request**: Contains the requested `Uri` of the current request
    * **variables *(InputData)* **: Contains the extracted variables of the current URL.
  * **header**: Contains the request header
    * **fields *(InputData)* **: The header fields (e.g. content-type, ...)
    * **cookies *(InputData)* **: The cookies
  * **body *(InputData)* **: Contains the body data (if `parseBody` of the route was set to `true`).
* **response**: Contains the informations about response.
  * **Header**: The header of the response
  * **Cookies**: The cookies of the response
  * **Body**: The body data of the response
* **data**: This is an map where you can store data to reuse it over the call executing (e.g. store user data in an Auth-Middleware and use it in your route logic or store the database connection during the route executing).
* **handleError(error)**: Use this function to handle an Error by the global error handler (First Middleware handler than Server handler).

####InputData
`InputData` is a special class which has 3 fields (`key`, `value`, `isValidated`)
* `key`: Contains the key of the input value (e.g. Variablename, Header-Key, Cookie-Name, ...)
* `value`: contains the data of this input
* `isValidated`: Defines if the value was validated (e.g. by the [validation middleware](/Middleware_Validation.md))
* `isValid`: Defines if the values is valid or not (default = false)

If the input is not yet validated, you can validate the value and set the `isValidated` and `isValid` by calling `validated([isValid])`. This way you have to validated the inputs only one time and you can store if you already validated this input or not. This protects you before multiple validation of the same input.

####Native Request Object
The `ReqResContext` was created to give a high level access to the required informations. But perhaps there are sometimes reason where you need the native `HttpRequest` / `HttpResponse` objects. Than you can cast the context into `ReqResContextNative` and you can access the native request object by the property `nativeReqwuest`.

##Route

The basic workflow of Bulls-Eye is as followed:
![Bais Server Workflow](img/Bulls-Eye-Server - Basic.png);

You have to define which routes (URLs) your Bulls-Eye server should handle. to do this, you have to call the function `route` of the `Server`class:
```dart
route(String method, common.Url url, RouteLogic logic, {List<String> contentTypes, String middleware, Map<String, dynamic> extensions, String parseBody});
```
Parameter:
* **method**: The method defines which HTTP method the route should handle (GET, PUT, DELETE, ...)
* **url**: An instance of an `URL` object which defines which URL the route should handle ([see here](../URLDefenitions.dart))
* **logic**: Defines which route logic should be executed if the defined URL was called ([see later](#route-logic)).
* **contentTypes *(optional, default null)* **: Defines optional which contentType on this route are allowed (Content Negotiation). This way you can define that an API request only support JSON or that the call to the home route only supports HTML.
* **middleware *(optional, default null)* **: Defines which middleware defenition should be executed with this route ([see here](#middleware))
* **extensions *(optional, default null)* **: Can be used by plugins to add custom extensions to the definition (e.g. [Validation](middleware_validation.md)))
* **parseBody *(optional, default false)* **: defines if the body of the request should be parsed (e.g. on POST) or if it should be ignored (e.g. on GET)

###Route Logic
Currently Bulls-Eye supports 2 route logics:
* `LoadFile`: This route logic loads a file from the file system and returns this to the client.
* `ExecuteCode`: Executes some custom code (like loading data from the database).
* `Custom`: You can create custom route logics objects to reuse your code.

####LoadFile
`LoadFile` has the following named constructors:
```dart
LoadFile.fromWildcard({String basePath});

LoadFile.fromPath(String filePath);
```
* **fromWildcard**: This route logic requires and `URL` definition with an wildcard. It takes the whole wildcard part and loads the file from this path (e.g. you have the URL defenition `/css/*` and the client makes a call to the url `/css/lib/bootstrap/css/bootstrap.css` than the route logic takes the wildcard part `lib/bootstrap/css/bootstrap.css` and looks for this in the file system). This is useful to deliver the CSS ans JS files.
* **fromPath**: This route logic takes a fix path to a file, which sould be delivered on call. This is helpful to deliver HTML files (e.g. the `index.html` on the home call).

####Execute Code

`ExecuteCode` has the following constructor:
```dart
ExecuteCode(bool CodeCall(ReqResContext context));
```
It takes a function handle to the code, which should be execute if the URL is called.

####Custom Route Logic

You can create custom reusable route logic by implementing the following interface:
```dart
abstract class RouteLogic {

  void execute(ReqResContext context);
}
```
Functions:
* **execute**: will be called when the route logic comes to execute.
