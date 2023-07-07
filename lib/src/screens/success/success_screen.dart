import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key? key, required this.message}) : super(key: key);

  final String message;
  final responsiveService = ResponsiveService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AlcanciaToolbar(
        toolbarHeight: responsiveService.getHeightPixels(90, screenHeight),
        state: StateToolbar.logoLetters,
        logoHeight: responsiveService.getHeightPixels(80, screenHeight),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Column(
                children: [
                  SvgPicture.asset("lib/src/resources/images/confetti.svg"),
                  SizedBox(
                    height: responsiveService.getHeightPixels(40, screenHeight),
                  ),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              AlcanciaButton(
                width: double.infinity,
                height: responsiveService.getHeightPixels(64, screenHeight),
                buttonText: appLoc.buttonUnderstood,
                onPressed: () {
                  context.go("/");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
