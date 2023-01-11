import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:metamap_plugin_flutter/metamap_plugin_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MetaMapController {
  final metamapClientId = dotenv.env['METAMAP_CLIENT_ID'] as String;

  void showMatiFlow(String flowId, String uid) {
    print(flowId);
    MetaMapFlutter.showMetaMapFlow(
        metamapClientId, flowId, {"uid": uid, "buttonColor": "4E76E5"});
    MetaMapFlutter.resultCompleter.future.then((result) =>
        Fluttertoast.showToast(
            msg: result is ResultSuccess
                ? "Verificación completada, revisión en proceso..."
                : "Cancelada",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM));
  }
}
