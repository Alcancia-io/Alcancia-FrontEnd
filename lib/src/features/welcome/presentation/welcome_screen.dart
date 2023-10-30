import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_logo.dart';
import 'package:alcancia/src/shared/components/alcancia_square_title.dart';
import 'package:alcancia/src/shared/services/auth_service.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../screens/registration.dart/registration_stepper.dart';
import '../../registration/presentation/registration_screen.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key, this.errorEmail}) : super(key: key);
  final bool? errorEmail;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    var pattern = getPattern(context);
    final ResponsiveService responsiveService = ResponsiveService();
    final appLocalization = AppLocalizations.of(context)!;
    Future.delayed(const Duration(seconds: 2), () {
      if (ref
          .watch(emailsInUseProvider)
          .contains(FirebaseAuth.instance.currentUser?.email)) {
        FirebaseAuth.instance.signOut();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: appLocalization.labelAlcanError,
          desc: appLocalization.labelEmailUsedFriendlyError,
          btnOkOnPress: () {},
        ).show();
      }
    });
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
          child: Stack(
            children: [
              Positioned(
                  bottom: screenHeight * 0.45,
                  child: Image(
                      image: const AssetImage(
                          "lib/src/resources/images/welcome_image.png"),
                      width: size.width)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: size.width,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(33),
                          topRight: Radius.circular(33))),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 32.0, left: 32.0, right: 32.0, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalization.labelWelcomeTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight / 23),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            appLocalization.labelWelcomeSubtitle,
                            style: const TextStyle(
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
                          buttonText: appLocalization.buttonRegister,
                          onPressed: () {
                            context.push('/stepper-registration',
                                extra: RegistrationParam(
                                    user: null, isCompleteRegistration: false));
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
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => context.push("/login")),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AlcanciaSquareTitle(
                                onTap: () async {
                                  await ThirdPartyAuthService()
                                      .signInWithGoogle()
                                      .then((value) {
                                    context.push("/stepper-registration",
                                        extra: RegistrationParam(
                                            user: value.user!,
                                            isCompleteRegistration: false));
                                  });
                                },
                                imagePath:
                                    "lib/src/resources/images/icons8-google-48.png"),
                            const SizedBox(
                              width: 25,
                            ),
                            const AlcanciaSquareTitle(
                                onTap: null,
                                imagePath:
                                    "lib/src/resources/images/icons8-apple-48.png"),
                          ],
                        ),
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
