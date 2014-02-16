#Middleware - Validation

You can use the Middleware `Validation` to validate you validation specification you can use on serveral position:
* **[URL](../URLVariableValidation.md)**
 * Path Variables
 * Query Variables
* **Header**
* **Cookies**
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
There will come special validators for different body types:
 * FileUpload (single, Multi)
 * FormData
 * JSON-Data
 * Other


##Adding the Validation Middleware

To use the validation middleware, define the validators for the different input data (URL Variables, Header, Cookies, Body, ...) and create a middleware which use the `Validation` Before-Hook.

Use this Middleware as early as possible in the middleware channel to protect as lot code as possible before bad requests.

```dart
server..middleware("Middleware").add(new Validation());
```
