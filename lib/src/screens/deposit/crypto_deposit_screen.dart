import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/deposit_info_item.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CryptoDepositScreen extends ConsumerWidget {
  const CryptoDepositScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AlcanciaToolbar(
        title: appLoc.labelDeposit,
        state: StateToolbar.titleIcon,
        logoHeight: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: QrImageView(
                data: user!.walletAddress,
                size: MediaQuery.of(context).size.width / 1.2,
                dataModuleStyle: QrDataModuleStyle(
                  color:
                      darkMode ? Colors.white.withOpacity(0.9) : Colors.black,
                ),
                eyeStyle: QrEyeStyle(
                    color:
                        darkMode ? Colors.white.withOpacity(0.9) : Colors.black,
                    eyeShape: QrEyeShape.square),
                embeddedImage: AssetImage(darkMode
                    ? "lib/src/resources/images/icon_alcancia_dark_no_letters.png"
                    : "lib/src/resources/images/icon_alcancia_light_no_letters.png"),
                embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(screenSize.width / 8, screenSize.width / 6.4)),
              ),
            ),
            DepositInfoItem(
              title: appLoc.labelAddress,
              subtitle: user.walletAddress,
              supportsClipboard: true,
              clipboardAlertText: appLoc.alertAddressCopied,
            ),
            DepositInfoItem(title: appLoc.labelNetwork, subtitle: "Polygon"),
            DepositInfoItem(title: appLoc.labelCoin, subtitle: "USDC"),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AlcanciaButton(
                width: double.infinity,
                height: 64,
                buttonText: appLoc.goBackToMainMenu,
                onPressed: () => context.go('/'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
