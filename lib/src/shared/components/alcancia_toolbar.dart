import 'package:flutter/material.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:go_router/go_router.dart';

enum StateToolbar { logoNoletters, logoLetters, titleIcon, profileTitleIcon }

class AlcanciaToolbar extends StatelessWidget with PreferredSizeWidget {
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
    switch (state) {
      case StateToolbar.logoNoletters:
        return AppBar(
          iconTheme: Theme.of(context).iconTheme,
          toolbarHeight: toolbarHeight,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0.3,
          title:
          AlcanciaLogo(
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
          title:
            AlcanciaLogo(
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              "lib/src/resources/images/profile.png",
              width: 38,
              height: 38,
            ),
          ),
          title: Text(
            "Hola, $userName",
            style: txtTheme.subtitle1,
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: AlcanciaLogo(
                height: logoHeight,
              ),
            ),
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
