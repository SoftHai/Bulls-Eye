import '../../../lib/BullsEyeServer/bulls_eye_server.dart';
import 'RouteDefenitions.dart';
import 'ServerLogic.dart';

void main() {
  
  // Create Server Logic
  var logic = new ServerLogic();
  
  // Init Server
  var server = new Server(debug: true);
  
  // Register routes
  server..RegisterRoute(new FileRoute.fromUri(cssPath, methods: ["GET"], contentTypes: ["text/css"])) // Only CSS allowed
        ..RegisterRoute(new FileRoute.fromUri(jsPath, methods: ["GET"]))
        ..RegisterRoute(new FileRoute.fromUri(dartPath, methods: ["GET"]))
        ..RegisterRoute(new FileRoute.fromPath(jshome, "client/jshome.html", methods: ["GET"]))
        ..RegisterRoute(new FileRoute.fromPath(darthome, "client/darthome.html", methods: ["GET"]))
        ..RegisterRoute(new LogicRoute(about, logic.aboutRouteLogic, methods: ["GET"]));
  
  // Start Server
  server.start();
  
}
