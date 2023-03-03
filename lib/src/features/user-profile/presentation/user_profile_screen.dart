import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_action_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/auth_service_provider.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserProfileScreen extends ConsumerWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  final Uri url = Uri.parse('https://landing.alcancia.io/privacypolicy');
  final Uri url2 = Uri.parse('https://landing.alcancia.io/termsandconditions');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider) ?? User.sampleUser;
    final authService = ref.watch(authServiceProvider);
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
          child: Column(
            children: [
              AlcanciaToolbar(
                state: StateToolbar.titleIcon,
                logoHeight: 38,
                title: appLoc.labelProfile,
              ),
              _profileCard(context, user),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  context.push("/account");
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.person_outline_outlined),
                      ),
                      Text(
                        appLoc.labelMyAccount,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _launchUrl(url2);
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.info_outline),
                      ),
                      Text(
                        appLoc.labelTermsAndConditions,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _launchUrl(url);
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.info_outline),
                      ),
                      Text(
                        appLoc.labelPrivacyPolicy,
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
                  child: AlcanciaButton(
                    foregroundColor: alcanciaLightBlue,
                    side: BorderSide(color: alcanciaLightBlue),
                    buttonText: appLoc.labelSignOut,
                    fontSize: 18,
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 4.0, bottom: 4.0),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlcanciaActionDialog(
                                child: Text(
                                  appLoc.labelSignOutConfirmation,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                acceptText: appLoc.labelConfirm,
                                acceptColor: Colors.red,
                                cancelText: appLoc.labelCancel,
                                acceptAction: () async {
                                  try {
                                    await authService.logout();
                                    await deleteToken();
                                    ref
                                        .read(userProvider.notifier)
                                        .setUser(null);

                                    context.go("/");
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        AlcanciaSnackBar(context,
                                            appLoc.errorSignOut));
                                  }
                                  ref.read(userProvider.notifier).setUser(null);
                                });
                          });
                    },
                    rounded: true,
                    icon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.delete_forever),
                    ),
                  )),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(48), // Image radius
                    child: Image.asset(
                      "lib/src/resources/images/profile.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "${user.name} ${user.surname}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(user.email),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  deleteToken() async {
    final StorageService _storageService = StorageService();
    await _storageService.deleteSecureData("token");
  }
}
