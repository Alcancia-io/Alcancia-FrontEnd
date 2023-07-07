import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/material.dart';

class AlcanciaNavbar extends StatelessWidget {
  const AlcanciaNavbar({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  Widget build(BuildContext context) {
    return AlcanciaToolbar(
      state: StateToolbar.profileTitleIcon,
      userName: username,
      logoHeight: 38,
    );
  }
}
