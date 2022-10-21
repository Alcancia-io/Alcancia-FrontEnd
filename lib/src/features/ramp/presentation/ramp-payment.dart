import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ramp_flutter/ramp_flutter.dart';

class RampPaymentService {
  const RampPaymentService();

  presentRamp(double? usdc, String? userEmail, String? userWalletAddress,
      String? fiatCurrency) {
    Configuration configuration = Configuration();
    configuration.fiatCurrency = "USD";
    configuration.userEmailAddress = userEmail;
    configuration.userAddress = userWalletAddress;
    configuration.fiatValue = usdc?.toStringAsFixed(2);
    configuration.deepLinkScheme = "alcancia";
    configuration.swapAsset = "CELO_CUSD";
    configuration.hostApiKey = dotenv.env['RAMP_STAGE_KEY'];
    configuration.url = "https://ri-widget-staging.firebaseapp.com/";
    configuration.hostAppName = "Alcancia";
    hostLogoUrl:
    'https://i.ibb.co/dDWZP4H/Untitled-design-15.png';
    variant:
    'auto';
    RampFlutter.showRamp(
        configuration, onPurchaseCreated, onRampFailed, onRampClosed);
  }

  void onPurchaseCreated(Purchase purchase, String token, String url) {
    print(purchase.id);
    print(purchase.status);
    print(token);
    print(purchase.toString());
    inspect(purchase);
    print(url);
  }

  void onRampFailed() {
    print('Failed');
  }

  void onRampClosed() {
    print("ramp closed");
  }
}
