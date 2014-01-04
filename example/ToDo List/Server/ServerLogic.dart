library softhai.Example.ToDo.Server;

import '../../../lib/BullsEyeServer/bulls_eye_server.dart';

class ServerLogic {
  
  bool homeRouteLogic(RouteContext context) 
  { 
    print("HOME"); 
    context.request.response.write('HOME');
    context.request.response.close();
    return true;
  }
  
  bool aboutRouteLogic(RouteContext context) 
  { 
    print("ABOUT"); 
    context.request.response.write('ABOUT');
    context.request.response.close();
    return true;
  }
  
}