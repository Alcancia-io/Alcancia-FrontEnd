import 'dart:async';

import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_action_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/auth_service_provider.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zendesk_messaging/zendesk_messaging.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final String androidChannelKey = dotenv.env['ANDROID_KEY_ZENDESK'] as String;
  final String iosChannelKey = dotenv.env['IOS_KEY_ZENDESK'] as String;
  int unreadMessageCount = 0;
  late Timer _refreshTimer;
  String _error = "";
  bool isLogin = false;
  DashboardController dashboardController = DashboardController();
  @override
  void initState() {
    super.initState();

    ZendeskMessaging.initialize(
      androidChannelKey: androidChannelKey,
      iosChannelKey: iosChannelKey,
    );

    _refreshTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      // Llama a setState para refrescar la pantalla y detectar notificaciones no leidas.
      if (isLogin) {
        setState(() {});
      }
    });
  }

  final Uri url = Uri.parse('https://www.alcancia.io/blog/aviso-de-privacidad');
  final Uri url2 =
      Uri.parse('https://www.alcancia.io/blog/terminos-condiciones');

  @override
  void dispose() {
    _refreshTimer.cancel();
    ZendeskMessaging.logoutUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider) ?? User.sampleUser;
    final authService = ref.watch(authServiceProvider);
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AlcanciaToolbar(
        state: StateToolbar.titleIcon,
        logoHeight: 38,
        title: appLoc.labelProfile,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
          child: Column(
            children: [
              _profileCard(context, user),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  context.push("/account");
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_outline_outlined),
                      ),
                      Text(
                        appLoc.labelMyAccount,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (!isLogin) {
                    await dashboardController.getUserToken().then((value) {
                      login(value.jwt, appLoc);
                    }).catchError((error) {
                      _error = error.toString();
                    });
                  } else {
                    ZendeskMessaging.show();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.headphones_outlined),
                      ),
                      Text(
                        appLoc.labelCustomerService,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 8),
                      FutureBuilder<int>(
                        future: _getUnreadMessageCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasError) {
                            return const Text(
                              "",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else if (snapshot.data! > 0) {
                            final unreadCount = snapshot.data;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  "$unreadCount",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right)
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.info_outline),
                      ),
                      Text(
                        appLoc.labelTermsAndConditions,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right)
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.info_outline),
                      ),
                      Text(
                        appLoc.labelPrivacyPolicy,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (_error.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AlcanciaButton(
                    foregroundColor: alcanciaLightBlue,
                    side: const BorderSide(color: alcanciaLightBlue),
                    color: Colors.transparent,
                    buttonText: appLoc.labelSignOut,
                    fontSize: 18,
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 4.0, bottom: 4.0),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlcanciaActionDialog(
                                acceptText: appLoc.buttonConfirm,
                                acceptColor: Colors.red,
                                cancelText: appLoc.buttonCancel,
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
                                        alcanciaSnackBar(
                                            context, appLoc.errorSignOut));
                                  }
                                  ref.read(userProvider.notifier).setUser(null);
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  appLoc.labelSignOutConfirmation,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ));
                          });
                    },
                    rounded: true,
                    icon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.logout_outlined),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getUnreadMessageCount() async {
    final messageCount = await ZendeskMessaging.getUnreadMessageCount();
    return messageCount;
  }

  Widget _profileCard(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
                    size: const Size.fromRadius(48), // Image radius
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

  void login(jwt, appLoc) {
    ZendeskMessaging.loginUserCallbacks(
        jwt: jwt!,
        onSuccess: (id, externalId) {
          setState(() {
            isLogin = true;
            ZendeskMessaging.show();
          });
        },
        onFailure: () {
          setState(() {
            isLogin = false;
            _error = appLoc.labelErrorCustomerService;
          });
        });
  }

  deleteToken() async {
    final StorageService storageService = StorageService();
    await storageService.deleteSecureData("token");
  }
}
