import '../../../lib/BullsEyeServer/bulls_eye_server.dart';
import '../../../lib/BullsEyeCommon/bulls_eye_common.dart';

class ServerLogic {
  
  bool homeRouteLogic(request, variables) 
  { 
    print("HOME"); 
    request.response.write('HOME');
    request.response.close();
    return true;
  }
  
  bool aboutRouteLogic(request, variables) 
  { 
    print("ABOUT"); 
    request.response.write('ABOUT');
    request.response.close();
    return true;
  }
  
}


void main() {
  
  // Route Defenition - Gobal Pathes
  var jsPath = new RouteDef("js/*");
  var cssPath = new RouteDef("css/*");
  
  // Route Defenition - Page(-Part)s
  var home = new RouteDef("");
  var about = new RouteDef("about");
  var todoList = new RouteDef("todos");
  var todoDetails = new RouteDef("todos/:ListID");
  var todoItemDetails = new RouteDef("todos/:ListID/:ItemID");
  
  // Route Defenition - API
  var api_todoList = new RouteDef(":Version/todos");
  var api_todoDetails = new RouteDef(":Version/todos/(:ListID)");
  var api_todoItem = new RouteDef(":Version/todos/:ListID/(:ItemID)");
  
  // Initialize Server
  var logic = new ServerLogic();
  
  var server = new Server();
  server..RegisterRoute(new LogicRoute(home, logic.homeRouteLogic, ["GET"]))
        ..RegisterRoute(new LogicRoute(about, logic.aboutRouteLogic, ["GET"]));
  
  server.start();
  
}
