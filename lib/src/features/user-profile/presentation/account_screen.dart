import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_action_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/auth_service_provider.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:alcancia/src/shared/models/alcancia_models.dart';

class AccountScreen extends ConsumerWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                title: appLoc.labelMyAccount,
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Change password
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? alcanciaCardDark2
                        : alcanciaCardLight2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.lock_outlined),
                        ),
                        Text(
                          appLoc.labelChangePassword,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AlcanciaButton(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    buttonText: appLoc.labelDeleteAccount,
                    fontSize: 18,
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 4.0, bottom: 4.0),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlcanciaActionDialog(
                              acceptText: appLoc.labelConfirm,
                              acceptColor: Colors.red,
                              cancelText: appLoc.labelCancel,
                              acceptAction: () async {
                                try {
                                  await authService.deleteAccount();
                                  context.goNamed("welcome");
                                  ref.read(userProvider.notifier).setUser(null);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      AlcanciaSnackBar(context,
                                          appLoc.errorDeleteAccount));
                                }
                              },
                              child: Text(
                                appLoc.labelDeleteAccountConfirmation,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            );
                          });
                    },
                    rounded: true,
                    icon: const Padding(
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
}
