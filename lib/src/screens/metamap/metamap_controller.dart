import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:metamap_plugin_flutter/metamap_plugin_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MetaMapController {
  final metamapClientId = dotenv.env['METAMAP_CLIENT_ID'] as String;

  void showMatiFlow(String flowId) {
    print(flowId);
    MetaMapFlutter.showMetaMapFlow(metamapClientId, flowId, {});
    MetaMapFlutter.resultCompleter.future.then((result) =>
        Fluttertoast.showToast(
            msg: result is ResultSuccess
                ? "Success ${result.verificationId}"
                : "Cancelled",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM));
  }
}
