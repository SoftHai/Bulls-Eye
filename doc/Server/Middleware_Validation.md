#Middleware - Validation

You can use the Middleware `Validation` to validate you validation specification you can use on serveral position:
* **Header**
* **Cookies**
* **[URL](../URLVariableValidation.md)**
 * Path Variables
 * Query Variables
* **Body**

The target of the Validation Middleware is to validate **ALL** inputs comming from the request into your web server.

To validate the inputs, you can use a bunch of predefined [Validators](../Validators.md).

##URL Validation

[See here](../URLVariableValidation.md)

##Header-Field Validation

To add header field validation you have to use the `extensions` paramter of the route definition:
```dart
server.route("GET", url, logic,
			 extensions: { HeaderValidationKey:
              		 	header({ "Header-Field-Key": Validator,
                          		  /* more ... */
                                  })
                         })
```

You can use as vaidator all validators from [here](../Validators.md);

##Cookie Validation

To add cookie validation you have to use the `extensions` paramter of the route definition:
```dart
server.route("GET", url, logic,
			 extensions: { CookieValidationKey:
              		 	cookie({ "Cookie-Key": Validator,
                          		  /* more ... */
                                  })
                         })
```

You can use as vaidator all validators from [here](../Validators.md);

##Body Validation

To add body validation you have to use the `extensions` paramter of the route definition:
```dart
server.route("GET", url, logic,
			 extensions: { BodyValidationKey: Validator })
```

###Body Validators

####formData

You can use this validator to validate the data of an transfered web form. Also the file Uploads can be validated here.
```dart
Validator formData({ "formdata-Key": Validator,
                     /* more ... */
                     });
```

You can use as vaidator all validators from [here](../Validators.md) and:

* **isFile**

 Validates if a formdata field is a file upload
 ```dart
 Validator isFile([List<String> allowedExtensions]);
 ```

####isBinary

Validates if the post data are binary data
```dart
Validator isBinary;
```

####isJson

Validates if the post data are JSON data
```dart
Validator isJson;
```

####isText

Validates if the post data are plain text data
```dart
Validator isText;
```

##Adding the Validation Middleware

To use the validation middleware, define the validators for the different input data (URL Variables, Header, Cookies, Body, ...) and create a middleware which use the `Validation` Before-Hook.

Use this Middleware as early as possible in the middleware channel to protect as lot code as possible before bad requests.

```dart
server..middleware("Middleware").add(new Validation());
```

##Handling Validation Errors

You can handle validation exsception in the global exception handling. By default a `ValidationException` is handled as BAD REQUEST.

```dart
server.exception((HttpRequestException ex) {
  if(ex is ValidationException) {
  	// Handle the exception here
    return true; // Handled
  }

  return false; // Unhandled, handle by default
});
```
The `ValidationException` has the following members:
* `request`: The native `HttpRequest` object
* `reason`: The reason for the bad request / invalid
* `section`: Defines during which validation section a invalidation was found (one of this constants: `ValidationSection_Header`, `ValidationSection_Cookie`, `ValidationSection_URLPathVar`, `ValidationSection_URLQueryVar`, `ValidationSection_Body`)
* `inputData`: In invalid input data
