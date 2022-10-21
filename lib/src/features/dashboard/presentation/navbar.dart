import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';

class AlcanciaNavbar extends ConsumerWidget {
  AlcanciaNavbar({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return AlcanciaToolbar(
      state: StateToolbar.profileTitleIcon,
      userName: "${user?.name}",
      logoHeight: 38,
    );
  }
}
