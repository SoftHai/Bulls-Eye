import '../../../lib/BullsEyeServer/bulls_eye_server.dart';
import '../Common/RouteDefenitions.dart';
import 'ServerLogic.dart';

void main() {
  
  // Initialize Server
  var logic = new ServerLogic();
  
  var server = new Server();
  server..RegisterRoute(new LogicRoute(home, logic.homeRouteLogic, ["GET"]))
        ..RegisterRoute(new LogicRoute(about, logic.aboutRouteLogic, ["GET"]));
  
  server.start();
  
}
