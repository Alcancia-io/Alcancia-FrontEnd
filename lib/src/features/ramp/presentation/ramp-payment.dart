import 'package:ramp_flutter/ramp_flutter.dart';

class RampPaymentService {
  const RampPaymentService();

  presentRamp(double usdc, String userEmail, String userWalletAddress,
      String fiatCurrency) {
    Configuration configuration = Configuration();
    configuration.fiatCurrency = "EUR";
    configuration.fiatValue = "15";
    configuration.deepLinkScheme = "myawesomeapp";
    configuration.hostApiKey = "";
    RampFlutter.showRamp(
        configuration, onPurchaseCreated, onRampFailed, onRampClosed);
  }

  void onPurchaseCreated(Purchase purchase, String token, String url) {}

  void onRampFailed() {
    print('Failed');
  }

  void onRampClosed() {}
}
