import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ramp_flutter/ramp_flutter.dart';

class RampPayment extends StatelessWidget {
  const RampPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _presentRamp,
        child: const Text("Present Ramp"),
      ),
    );
  }

  void _presentRamp() {
    Configuration configuration = Configuration();
    configuration.fiatCurrency = "EUR";
    configuration.fiatValue = "15";
    configuration.deepLinkScheme = "myawesomeapp";
    RampFlutter.showRamp(
        configuration, onPurchaseCreated, onRampFailed, onRampClosed);
  }

  void onPurchaseCreated(Purchase purchase, String token, String url) {}

  void onRampFailed() {
    print('Failed');
  }

  void onRampClosed() {}
}
