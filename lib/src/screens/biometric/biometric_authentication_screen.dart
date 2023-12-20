import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/provider/auth_service_provider.dart';
import 'package:alcancia/src/shared/services/biometric_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BiometricAuthenticationScreen extends ConsumerStatefulWidget {
  const BiometricAuthenticationScreen({super.key});

  @override
  ConsumerState<BiometricAuthenticationScreen> createState() => _BiometricAuthenticationScreenState();
}

class _BiometricAuthenticationScreenState extends ConsumerState<BiometricAuthenticationScreen> {

  @override
  void initState() {
    super.initState();
    final biometricService = ref.read(biometricServiceProvider.notifier);
    _authenticate(biometricService);
  }

  Future<void> _authenticate(biometricService) async {
    int attemptsBiometric = 0;
    while (attemptsBiometric < 3 && await biometricService.isAppEnrolled()) {
      await biometricService.authenticate();
      final biometricState = ref.read(biometricServiceProvider);
      if (biometricState == true) {
        return;
      } else {
        attemptsBiometric++;
      }
    }

    if (attemptsBiometric >= 3) {
      await ref.read(authServiceProvider).logout();
      context.go("/welcome");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Icon(CupertinoIcons.lock_fill, size: 128, color: darkMode ? Colors.white : Colors.black),
          ),
          Text(
            appLoc.labelBiometricAuthenticationDescription,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
