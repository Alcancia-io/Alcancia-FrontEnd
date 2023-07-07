import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_logo.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    var pattern = getPattern(context);
    final ResponsiveService responsiveService = ResponsiveService();
    final appLocalization = AppLocalizations.of(context)!;
    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.center, colors: pattern)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                  bottom: screenHeight * 0.45,
                  child:
                      Image(image: const AssetImage("lib/src/resources/images/welcome_image.png"), width: size.width)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: size.width,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(33), topRight: Radius.circular(33))),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalization.labelWelcomeTitle,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 23),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            appLocalization.labelWelcomeSubtitle,
                            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                        const Spacer(),
                        AlcanciaButton(
                          color: alcanciaLightBlue,
                          width: responsiveService.getWidthPixels(304, screenWidth),
                          height: responsiveService.getHeightPixels(64, screenHeight),
                          buttonText: appLocalization.buttonRegister,
                          onPressed: () {
                            context.push('/registration');
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: responsiveService.getHeightPixels(
                            8,
                            screenHeight,
                          )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                appLocalization.labelExistingAccount,
                                textAlign: TextAlign.center,
                              ),
                              CupertinoButton(
                                  child: Text(
                                    appLocalization.buttonLogIn,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => context.push("/login")),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AlcanciaLogo(
                  height: size.height / 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
