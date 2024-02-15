import 'dart:io';

import 'package:alcancia/main.dart';
import 'package:alcancia/src/features/registration/presentation/phone_registration_screen.dart';
import 'package:alcancia/src/screens/account_verification.dart';
import 'package:alcancia/src/screens/biometric/biometric_authentication_screen.dart';
import 'package:alcancia/src/screens/login/login_screen.dart';
import 'package:alcancia/src/features/registration/presentation/otp_screen.dart';
import 'package:alcancia/src/features/user-profile/presentation/account_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/screens/checkout/checkout.dart';
import 'package:alcancia/src/screens/deposit/crypto_deposit_screen.dart';
import 'package:alcancia/src/screens/deposit/deposit_screen.dart';
import 'package:alcancia/src/screens/error/error_screen.dart';
import 'package:alcancia/src/screens/forgot_password/forgot_password.dart';
import 'package:alcancia/src/screens/login/mfa_screen.dart';
import 'package:alcancia/src/screens/maintenance/maintenance_screen.dart';
import 'package:alcancia/src/screens/metamap/address_screen.dart';
import 'package:alcancia/src/screens/network_error/network_error_screen.dart';
import 'package:alcancia/src/screens/onboarding/onboarding_screens.dart';
import 'package:alcancia/src/screens/referral/referral_screen.dart';
import 'package:alcancia/src/screens/required_update/required_update_screen.dart';
import 'package:alcancia/src/screens/success/success_screen.dart';
import 'package:alcancia/src/screens/successful_transaction/successful_transaction.dart';
import 'package:alcancia/src/screens/swap/swap_screen.dart';
import 'package:alcancia/src/screens/transfer/transfer_screen.dart';
import 'package:alcancia/src/screens/withdraw/crypto_withdraw_screen.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_options_screen.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/checkout_model.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:alcancia/src/shared/models/success_screen_model.dart';
import 'package:alcancia/src/shared/services/biometric_service.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:alcancia/src/shared/services/version_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/screens/transaction_detail/transaction_detail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../screens/chart/line_chart_screen.dart';

Future<bool> isUserAuthenticated() async {
  StorageService service = StorageService();
  UserService userService = UserService();
  try {
    var result = await userService.getUser();
    if (result.hasException) {
      final graphQLErrors = result.exception?.graphqlErrors;
      final linkException = result.exception?.linkException?.originalException;
      if (graphQLErrors != null && graphQLErrors.isNotEmpty) {
        return false;
      } else if (linkException != null &&
          linkException.toString().contains("CERTIFICATE_VERIFY_FAILED")) {
        return Future.error("CERTIFICATE_VERIFY_FAILED");
      }
    }
    return true;
  } catch (e) {
    await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    await service.deleteSecureData("token");
    rethrow;
  }
  // print(result.hasException);
}

Future<String> getCurrentlySupportedAppVersion() async {
  VersionService service = VersionService();
  var result = await service.getCurrentlySupportedAppVersion();
  if (result.hasException) {
    return Future.error(result.exception?.graphqlErrors[0].message ??
        "Exception getting latest supported version");
  }
  return result.data?['getCurrentlySupportedAppVersionGraphQLObject']['version']
      as String;
}

Future<String> getCurrentBuildNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.buildNumber;
}

Future<bool> checkNetwork() async {
  bool isConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
    }
  } on SocketException catch (_) {
    isConnected = false;
  }
  return isConnected;
}

Future<bool> _finishedOnboarding() async {
  final preferences = await SharedPreferences.getInstance();
  final finished = preferences.getBool("finishedOnboarding");
  return finished == true;
}

final routerProvider = Provider<GoRouter>(
  (ref) {
    final biometricService = ref.watch(biometricServiceProvider.notifier);

    return GoRouter(
      initialLocation: "/",
      navigatorKey: navigatorKey,
      // debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: "welcome",
          path: "/",
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          name: "login",
          path: "/login",
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: "homescreen",
          path: "/homescreen/:id",
          builder: (context, state) {
            return AlcanciaTabbar(
              selectedIndex: int.parse(state.pathParameters['id'] as String),
            );
          },
        ),
        GoRoute(
          name: "account",
          path: "/account",
          builder: (context, state) => const AccountScreen(),
        ),
        GoRoute(
          name: "registration",
          path: "/registration",
          builder: (context, state) => const RegistrationScreen(),
        ),
        GoRoute(
          name: "phone-registration",
          path: "/phone-registration",
          builder: (context, state) => PhoneRegistrationScreen(
              userRegistrationData: state.extra as UserRegistrationModel),
        ),
        GoRoute(
          name: "swap",
          path: "/swap",
          builder: (context, state) => const SwapScreen(),
        ),
        GoRoute(
          name: "transaction_detail",
          path: "/transaction_detail",
          builder: (context, state) =>
              TransactionDetail(txn: state.extra as Transaction),
        ),
        GoRoute(
          name: "otp",
          path: "/otp",
          builder: (context, state) => OTPScreen(
            otpDataModel: state.extra as OTPDataModel,
          ),
        ),
        GoRoute(
          name: "mfa",
          path: "/mfa",
          builder: (context, state) =>
              MFAScreen(data: state.extra as LoginDataModel),
        ),
        GoRoute(
          name: "checkout",
          path: "/checkout",
          builder: (context, state) => Checkout(
            checkoutData: state.extra as CheckoutModel,
          ),
        ),
        GoRoute(
          name: "user-address",
          path: "/user-address",
          builder: (context, state) => AddressScreen(
            wrapper: state.extra as Map,
          ),
        ),
        GoRoute(
          name: 'forgot-password',
          path: '/forgot-password',
          builder: (context, state) => const ForgotPassword(),
        ),
        GoRoute(
          name: "withdraw",
          path: "/withdraw",
          builder: (context, state) => const WithdrawOptionsScreen(),
        ),
        GoRoute(
          name: "fiat-withdrawal",
          path: "/fiat-withdrawal",
          builder: (context, state) => const WithdrawScreen(),
        ),
        GoRoute(
          name: "crypto-withdrawal",
          path: "/crypto-withdrawal",
          builder: (context, state) => const CryptoWithdrawScreen(),
        ),
        GoRoute(
          name: "success",
          path: "/success",
          builder: (context, state) =>
              SuccessScreen(model: state.extra as SuccessScreenModel),
        ),
        GoRoute(
          name: "onboarding",
          path: "/onboarding",
          builder: (context, state) => const OnboardingScreens(),
        ),
        GoRoute(
          name: "successful-transaction",
          path: "/successful-transaction",
          builder: (context, state) => SuccessfulTransaction(
            transferResponse: state.extra as TransferResponse,
          ),
        ),
        GoRoute(
          name: "transfer",
          path: "/transfer",
          builder: (context, state) => const TransferScreen(),
        ),
        GoRoute(
          name: "deposit",
          path: "/deposit",
          builder: (context, state) => const DepositScreen(),
        ),
        GoRoute(
          name: "crypto-deposit",
          path: "/crypto-deposit",
          builder: (context, state) => const CryptoDepositScreen(),
        ),
        GoRoute(
          name: "referral",
          path: "/referral",
          builder: (context, state) => const ReferralScreen(),
        ),
        GoRoute(
          name: "line-chart",
          path: "/line-chart",
          builder: (context, state) => const LineChartScreen(),
        ),
        GoRoute(
          name: "update-required",
          path: "/update-required",
          builder: (context, state) => RequiredUpdateScreen(),
        ),
        GoRoute(
          name: "account-verification",
          path: "/account-verification",
          builder: (context, state) => const AccountVerificationScreen(),
        ),
        GoRoute(
          name: "network-error",
          path: "/network-error",
          builder: (context, state) => const NetworkErrorScreen(),
        ),
        GoRoute(
          name: "biometric-authentication",
          path: "/biometric-authentication",
          builder: (context, state) => const BiometricAuthenticationScreen(),
        ),
        GoRoute(
          name: "maintenance",
          path: "/maintenance",
          builder: (context, state) => const MaintenanceScreen(),
        )
      ],
      redirect: (context, state) async {
        try {
          final loggingIn = state.matchedLocation == "/login";
          final isMfa = state.matchedLocation == "/mfa";
          final isOtp = state.matchedLocation == "/otp";
          final isAccountVerification =
              state.matchedLocation == "/account-verification";
          final isPhoneRegistration =
              state.matchedLocation == "/phone-registration";
          final isStartup = state.matchedLocation == "/";
          final creatingAccount = state.matchedLocation == "/registration";
          final loggedIn = await isUserAuthenticated();
          final isForgotPassword = state.matchedLocation == "/forgot-password";
          final finishedOnboarding = await _finishedOnboarding();
          final isOnboarding = state.matchedLocation == "/onboarding";

          final isNetworkConnected = await checkNetwork();
          if (!isNetworkConnected) return "/network-error";

          final buildNumber = await getCurrentBuildNumber();
          String supportedVersion = await getCurrentlySupportedAppVersion();
          supportedVersion = supportedVersion.replaceAll("'", "");
          final isSupportedVersion = int.parse(buildNumber) >=
              (int.tryParse(supportedVersion.split(".").last) ?? 1000000);
          if (!isSupportedVersion) return "/update-required";
          if (!loggedIn && !finishedOnboarding && !isOnboarding)
            return "/onboarding";
          if (!loggedIn &&
              !loggingIn &&
              !creatingAccount &&
              !isStartup &&
              !isMfa &&
              !isPhoneRegistration &&
              !isOtp &&
              !isForgotPassword &&
              !isOnboarding &&
              !isAccountVerification) return "/";
          if (loggedIn && (loggingIn || creatingAccount || isStartup)) {
            final biometricState = ref.read(biometricServiceProvider);
            if (await biometricService.isAppEnrolled() && !biometricState) {
              ref.read(biometricLockProvider.notifier).state = true;
            }
            return "/homescreen/0";
          }
        } catch (e) {
          if (e.toString().contains("CERTIFICATE_VERIFY_FAILED")) {
            return "/maintenance";
          }
          return null;
        }
      },
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  },
);
