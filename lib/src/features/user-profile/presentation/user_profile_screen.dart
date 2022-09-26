import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_action_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/auth_service_provider.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/graphql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends ConsumerWidget {
  UserProfileScreen({Key? key}) : super(key: key);
  final Uri url = Uri.parse('https://flutter.dev');

  final GraphqlService _gqlService = GraphqlService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final authService = ref.watch(authServiceProvider(_gqlService));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
          child: Column(
            children: [
              AlcanciaToolbar(
                state: StateToolbar.titleIcon,
                logoHeight: 38,
                title: "Perfil",
              ),
              _profileCard(context, user!),
              GestureDetector(
                onTap: () {
                  _launchUrl();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.info_outline),
                      ),
                      Text(
                        "Términos y condiciones",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlcanciaActionDialog(
                              child: Text("¿Seguro que quieres borrar tu cuenta?\nEsta acción no se puede deshacer.", style: Theme.of(context).textTheme.titleLarge,),
                              acceptText: "Confirmar",
                              acceptColor: Colors.red,
                              cancelText: "Cancelar",
                              acceptAction: () async {
                                try {
                                  print("logging out");
                                  await authService.deleteAccount();
                                  context.go("/");
                                } catch (e) {
                                  print("error");
                                }
                              });
                        });
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 4.0, bottom: 4.0),
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      splashFactory: NoSplash.splashFactory),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.delete_forever),
                      ),
                      Text("Borrar cuenta")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlcanciaActionDialog(
                              child: Text("¿Seguro que quieres cerrar sesión?", style: Theme.of(context).textTheme.titleLarge,),
                              acceptText: "Confirmar",
                              acceptColor: Colors.red,
                              cancelText: "Cancelar",
                              acceptAction: () async {
                                try {
                                  print("logging out");
                                  await authService.logout();
                                  context.go("/");
                                } catch (e) {
                                  print("error");
                                }
                              });
                        });
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 4.0, bottom: 4.0),
                      foregroundColor: alcanciaLightBlue,
                      side: const BorderSide(color: alcanciaLightBlue),
                      splashFactory: NoSplash.splashFactory),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.power_settings_new),
                      ),
                      Text("Cerrar sesión")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? alcanciaCardDark2
              : alcanciaCardLight2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0, right: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "lib/src/resources/images/profile.png",
                  width: 100,
                  height: 100,
                ),
              ),
              Text(
                "${user.name} ${user.surname}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(user.email),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
