import 'package:ramp_flutter/ramp_flutter.dart';

class RampPaymentService {
  const RampPaymentService();

  presentRamp(double usdc, String userEmail, String userWalletAddress,
      String fiatCurrency) {
    Configuration configuration = Configuration();
    configuration.fiatCurrency = "USD";
    configuration.userEmailAddress = "juandatorr_1999@hotmail.com";
    configuration.userAddress = userWalletAddress;
    configuration.fiatValue = usdc.toStringAsFixed(2);
    configuration.deepLinkScheme = "Alcancía";
    configuration.swapAsset = "ETH_USDC";
    configuration.hostApiKey = "";

    RampFlutter.showRamp(
        configuration, onPurchaseCreated, onRampFailed, onRampClosed);
  }

  void onPurchaseCreated(Purchase purchase, String token, String url) {
    print(purchase);
    print(token);
    print(url);
  }

  void onRampFailed() {
    print('Failed');
  }

  void onRampClosed() {
    print("ramp closed");
  }
}
