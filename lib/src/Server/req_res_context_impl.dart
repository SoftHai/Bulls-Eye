part of softhai.bulls_eye.Server;

class _UrlDataImpl implements UrlData {
  
  final common.Url definition;
  
  final Uri request;
  
  final UrlVariables variables;
  
  const _UrlDataImpl(this.definition, this.request, this.variables);
}

class _UrlVariablesImpl implements UrlVariables {
  
  final common.Url _definition;
  final Uri _request;
  ReadOnlyMap<UrlInputData> _path;
  ReadOnlyMap<UrlInputData> _query;
  
  ReadOnlyMap<UrlInputData> get path {
    if(this._path == null) {
      this._extractVariables();
    }
    
    return this._path;
  }
  
  ReadOnlyMap<UrlInputData> get query {
    if(this._query == null) {
      this._extractVariables();
    }
    
    return this._query;
  }
  
  _UrlVariablesImpl(this._definition, this._request);
  
  void _extractVariables() {
    var variables = this._definition.matcher.getMatches(this._request.toString());
    
    // Get Path Variables
    List<UrlInputData> pathData = new List<UrlInputData>();
    variables.routeVariables.result.forEach((k,v) => pathData.add(new _UrlInputData(k.name, v, k)));
    this._path = new ReadOnlyMap<UrlInputData>._internal(pathData);
    
    // Get Querys Varibles
    List<UrlInputData> queryData = new List<UrlInputData>();
    variables.queryVariables.result.forEach((k,v) => queryData.add(new _UrlInputData(k.name, v, k)));
    this._query = new ReadOnlyMap<UrlInputData>._internal(queryData);
  }
}

class _HeaderDataImpl implements RequestHeaderData {
  
  final HttpRequest _request;
  InputDataList<List<String>> _fields;
  InputDataList<Cookie> _cookies;
  
  InputDataList<List<String>> get fields {
    if(this._fields == null) {
      List<InputData<List<String>>> headerData = new List<InputData<List<String>>>();
      this._request.headers.forEach((k, v) => headerData.add(new _InputDataImpl(k, v)));
      this._fields = new InputDataList<List<String>>._internal(headerData);
    }
    
    return this._fields;
  }
  
  InputDataList<Cookie> get cookies{
    if(this._cookies == null) {
      List<InputData<Cookie>> cookieData = new List<InputData<Cookie>>();
      this._request.cookies.forEach((c) => cookieData.add(new _InputDataImpl(c.name, c)));
      this._cookies = new InputDataList<Cookie>._internal(cookieData);
    }
    
    return this._cookies;
  }
  
  _HeaderDataImpl(this._request);
}

class _RequestImpl implements Request {
  
  String method;
  
  UrlData url;
  
  RequestHeaderData header;
  
  final HttpBody body;
  
  _RequestImpl(HttpRequest request, common.Url urlDefinition, [this.body = null]) {
    this.method = request.method;
    this.url = new _UrlDataImpl(urlDefinition, request.uri, new _UrlVariablesImpl(urlDefinition, request.uri));
    this.header = new _HeaderDataImpl(request);
  }
}

class _ResponseImpl implements Response {
  
  final HttpResponse _response;
  ResponseBody _body = new _ResponseBodyImpl();
  
  int get statusCode => this._response.statusCode;
  void set statusCode(int value) { 
    this._response.statusCode = value; 
  }
  
  HttpHeaders get headers => this._response.headers;

  List<Cookie> get cookies => this._response.cookies;
  
  ResponseBody get body => this._body;
  
  _ResponseImpl(this._response);
}

class _ResponseBodyImpl implements ResponseBody {
  
  String ContentType = null;
  
  dynamic Data = null;
  
  _ResponseBodyImpl();
  
  void SetBody(String contentType, dynamic data) {
    this.ContentType = contentType;
    this.Data = data;
  }
  
  void TransformBody(String targetContentType, dynamic transform(data)) {
    this.ContentType = ContentType;
    this.Data = transform(this.Data);
  }
}

class _ReqResContextImpl implements ReqResContextNative {

  ErrorHandler _errorHandler = null;
  
  Request request;
  Response response;
  HttpRequest nativeRequest;

  Map<String, Object> data = new Map<String,Object>();

  _ReqResContextImpl(this.nativeRequest, common.Url urlDefinition, this._errorHandler, [HttpBody body = null]) {
    this.request = new _RequestImpl(this.nativeRequest, urlDefinition, body);
    this.response = new _ResponseImpl(this.nativeRequest.response);
  }
  
  void HandleError(Object ex) {
    if(ex is HttpRequestException) {
      this._errorHandler(ex);
    }
    else {
      this._errorHandler(new WrappedHttpRequestException(this, ex));
    }
  }
  
  dynamic operator[](String key) => this.data[key];
  
  void operator[]=(String key, dynamic value) => this.data[key] = value;
}