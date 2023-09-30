import 'package:alcancia/src/shared/components/alcancia_action_dialog.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/auth_service_provider.dart';
import 'package:alcancia/src/shared/provider/user_provider.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AlcanciaToolbar(
        state: StateToolbar.titleIcon,
        logoHeight: 38,
        title: appLoc.labelMyAccount,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
          child: Column(
            children: [
              // GestureDetector(
              //   onTap: () {
              //     // TODO: Change password
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).brightness == Brightness.dark
              //           ? alcanciaCardDark2
              //           : alcanciaCardLight2,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Row(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Icon(Icons.lock_outlined),
              //           ),
              //           Text(
              //             appLoc.labelChangePassword,
              //             style: Theme.of(context).textTheme.labelLarge,
              //           ),
              //           Spacer(),
              //           Icon(Icons.chevron_right)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const Spacer(),
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AlcanciaButton(
                      color: Colors.transparent,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      buttonText: appLoc.buttonDeleteAccount,
                      fontSize: 18,
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0, bottom: 4.0),
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
                                    await authService.deleteAccount();
                                    await deleteToken();
                                    context.goNamed("welcome");
                                    ref.invalidate(alcanciaUserProvider);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        alcanciaSnackBar(context,
                                            appLoc.errorDeleteAccount));
                                  }
                                  Navigator.pop(ctx);
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteToken() async {
    final StorageService storageService = StorageService();
    await storageService.deleteSecureData("token");
  }
}
