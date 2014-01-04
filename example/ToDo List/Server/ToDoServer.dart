import '../../../lib/BullsEyeServer/bulls_eye_server.dart';
import '../Common/RouteDefenitions.dart';
import 'ServerLogic.dart';

void main() {
  
  // Initialize Server
  var logic = new ServerLogic();
  
  var server = new Server();
  server..RegisterRoute(new FileRoute.fromUri(cssPath, methods: ["GET"], contentTypes: ["text/css"])) // Only CSS allowed
        ..RegisterRoute(new FileRoute.fromUri(jsPath, methods: ["GET"]))
        ..RegisterRoute(new FileRoute.fromPath(home, "html/home.html", methods: ["GET"]))
        ..RegisterRoute(new LogicRoute(about, logic.aboutRouteLogic, methods: ["GET"]));
  
  server.start();
  
}
