import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    //print(result.data);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: pattern)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                AlcanciaToolbar(
                    state: StateToolbar.logoNoletters,
                    logoHeight: size.height / 12),

                //AlcanciaLogo(height: size.height / 12),
                Transform(
                  transform: Matrix4.translationValues(0, 30, 0),
                  child: Image(
                      image: const AssetImage(
                          "lib/src/resources/images/welcome_image.png"),
                      width: size.width),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(33),
                          topRight: Radius.circular(33))),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalization.labelWelcomeTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            appLocalization.labelWelcomeSubtitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                        const Spacer(),
                        AlcanciaButton(
                          color: alcanciaLightBlue,
                          width: responsiveService.getWidthPixels(
                              304, screenWidth),
                          height: responsiveService.getHeightPixels(
                              64, screenHeight),
                          buttonText: appLocalization.labelRegister,
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
                                    appLocalization.labelLogIn,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => context.push("/login")),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
