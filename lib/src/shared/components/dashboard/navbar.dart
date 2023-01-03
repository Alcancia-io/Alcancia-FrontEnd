import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';

class AlcanciaNavbar extends StatelessWidget {
  AlcanciaNavbar({Key? key, required this.username}) : super(key: key);
  String username;

  @override
  Widget build(BuildContext context) {
    return AlcanciaToolbar(
      state: StateToolbar.profileTitleIcon,
      userName: username,
      logoHeight: 38,
    );
  }
}
