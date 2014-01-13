import 'package:unittest/mock.dart';
import 'dart:io';

class HttpHeadersMock extends Mock implements HttpHeaders {
  HttpHeadersMock(List<String> accept) {
    this.when(callsTo("[]", HttpHeaders.ACCEPT)).alwaysReturn(accept);
  }
}

class HttpRequestMock extends Mock implements HttpRequest {
  
  HttpRequestMock(String path, String method, List<String> httpHeaderAccept) {
    this.when(callsTo("get uri")).alwaysReturn(new Uri.file(path));
    this.when(callsTo("get method")).alwaysReturn(method);
    this.when(callsTo("get headers")).alwaysReturn(new HttpHeadersMock(httpHeaderAccept));
  }
  
}