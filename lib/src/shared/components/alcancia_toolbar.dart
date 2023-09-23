import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

enum StateToolbar { logoNoletters, logoLetters, titleIcon, profileTitleIcon }

class AlcanciaToolbar extends StatelessWidget implements PreferredSizeWidget {
  const AlcanciaToolbar({
    Key? key,
    this.title,
    required this.state,
    this.userName,
    required this.logoHeight,
    this.showBackButton = false,
    this.toolbarHeight = kToolbarHeight,
  }) : super(key: key);

  final String? title;
  final String? userName;
  final double logoHeight;
  final bool showBackButton;
  final double toolbarHeight;
  /*
  logo-noletters
  logo-letters
  title-icon
  profile-title-icon
   */
  final StateToolbar state;
  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    final appLoc = AppLocalizations.of(context)!;
    switch (state) {
      case StateToolbar.logoNoletters:
        return AppBar(
          iconTheme: Theme.of(context).iconTheme,
          toolbarHeight: toolbarHeight,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0.3,
          title: AlcanciaLogo(
            height: logoHeight,
          ),
          centerTitle: true,
        );
      case StateToolbar.logoLetters:
        return AppBar(
          iconTheme: Theme.of(context).iconTheme,
          toolbarHeight: toolbarHeight,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0.3,
          title: AlcanciaLogo(
            letters: true,
            height: logoHeight,
          ),
          centerTitle: true,
        );
      case StateToolbar.titleIcon:
        return AppBar(
          iconTheme: Theme.of(context).iconTheme,
          toolbarHeight: toolbarHeight,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0.3,
          title: Text(
            "$title",
            style: txtTheme.subtitle1,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: AlcanciaLogo(
                height: logoHeight,
              ),
            ),
          ],
        );
      case StateToolbar.profileTitleIcon:
        return AppBar(
          iconTheme: Theme.of(context).iconTheme,
          toolbarHeight: toolbarHeight,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0.3,
          leadingWidth: 60,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AlcanciaLogo(),
          ),
          title: Text(
            appLoc.labelHelloName(userName ?? ""),
            style: txtTheme.subtitle1,
          ),
          centerTitle: false,
          actions: [
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: badges.Badge(
                badgeAnimation: badges.BadgeAnimation.scale(loopAnimation: true, animationDuration: Duration(milliseconds: 700)),
                badgeContent: SizedBox(
                  height: 8,
                  width: 8,
                ),
                child: AlcanciaButton(buttonText: appLoc.buttonWinFiveDollars, onPressed: () {
                  context.push("/referral");
                },
                  color: alcanciaMidBlue,
                ),
              ),
            )*/
          ],
        );
      default:
        return const Text("Default");
    }
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
