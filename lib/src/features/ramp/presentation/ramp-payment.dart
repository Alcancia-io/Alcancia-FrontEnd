import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ramp_flutter/ramp_flutter.dart';

class RampPaymentService {
  const RampPaymentService();

  presentRamp(double? usdc, String? userEmail, String? userWalletAddress,
      String? fiatCurrency) {
    Configuration configuration = Configuration();
    configuration.fiatCurrency = "USD";
    configuration.userEmailAddress = "juandatorr_1999@hotmail.com";
    configuration.userAddress = "0x85fE9a50f74b048A26301A7B052cE2F92da6Bf00";
    print(usdc);
    // configuration.fiatValue = usdc.toString();
    configuration.deepLinkScheme = "Alcancía";
    configuration.swapAsset = "ETH_USDC";
    configuration.hostApiKey = dotenv.env['RAMP_STAGE_KEY'] as String;
    configuration.url = "https://ri-widget-staging.firebaseapp.com/";

    RampFlutter.showRamp(
        configuration, onPurchaseCreated, onRampFailed, onRampClosed);
  }

  void onPurchaseCreated(Purchase purchase, String token, String url) {
    print(purchase.id);
    print(purchase.status);
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
