import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, this.error}) : super(key: key);

  final String? error;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AlcanciaToolbar(
        toolbarHeight: screenSize.height / 13,
        state: StateToolbar.logoLetters,
        logoHeight: screenSize.height / 13,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Column(
                children: [
                  Lottie.asset("lib/src/resources/lottie/error.json",
                      repeat: false, height: screenSize.height / 5),
                  Text(
                    appLoc.errorSomethingWentWrong,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Error: $error",
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AlcanciaButton(
                    buttonText: appLoc.goBackToMainMenu,
                    onPressed: () => context.go('/'),
                  width: double.infinity,
                  height: 64,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
