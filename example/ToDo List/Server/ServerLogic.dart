library softhai.Example.ToDo.Server;

import '../../../lib/BullsEyeServer/bulls_eye_server.dart';

class ServerLogic {
  
  bool aboutRouteLogic(ReqResContext context) 
  { 
    print("ABOUT"); 
    context.request.response.write('ABOUT');
    context.request.response.close();
    return true;
  }
  
}