import 'dart:async';
import '../../../lib/server.dart';

class ServerLogic {
  
  Future aboutRouteLogic(ReqResContext context) 
  { 
    print("ABOUT"); 
    (context as ReqResContextNative).nativeRequest.response.write('ABOUT');
    (context as ReqResContextNative).nativeRequest.response.close();
  }
  
}