import 'package:alcancia/main.dart';
import 'package:alcancia/src/features/registration/presentation/phone_registration_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/registration/model/graphql_config.dart';
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
import 'package:alcancia/src/screens/metamap/address_screen.dart';
import 'package:alcancia/src/screens/onboarding/onboarding_screens.dart';
import 'package:alcancia/src/screens/success/success_screen.dart';
import 'package:alcancia/src/screens/successful_transaction/successful_transaction.dart';
import 'package:alcancia/src/screens/swap/swap_screen.dart';
import 'package:alcancia/src/screens/transfer/transfer_screen.dart';
import 'package:alcancia/src/screens/withdraw/withdraw_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/graphql/queries/is_authenticated_query.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/checkout_model.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isUserAuthenticated() async {
  StorageService service = StorageService();
  var token = await service.readSecureData("token");
  GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "$token");
  GraphQLClient client = graphQLConfiguration.clientToQuery();
  var result = await client.query(QueryOptions(document: gql(isAuthenticatedQuery)));
  return !result.hasException;
  // print(result.hasException);
}

Future<bool> _finishedOnboarding() async {
  final preferences = await SharedPreferences.getInstance();
  final finished = preferences.getBool("finishedOnboarding");
  return finished == true;
}

final routerProvider = Provider<GoRouter>(
  (ref) {
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
              selectedIndex: int.parse(state.params['id'] as String),
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
          builder: (context, state) =>
              PhoneRegistrationScreen(userRegistrationData: state.extra as UserRegistrationModel),
        ),
        GoRoute(
          name: "swap",
          path: "/swap",
          builder: (context, state) => const SwapScreen(),
        ),
        GoRoute(
          name: "transaction_detail",
          path: "/transaction_detail",
          builder: (context, state) => TransactionDetail(txn: state.extra as Transaction),
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
          builder: (context, state) => MFAScreen(data: state.extra as LoginDataModel),
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
          builder: (context, state) => const WithdrawScreen(),
        ),
        GoRoute(
          name: "success",
          path: "/success",
          builder: (context, state) => SuccessScreen(message: state.extra as String),
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
      ],
      redirect: (context, state) async {
        final loginLoc = state.namedLocation("login");
        final loggingIn = state.subloc == loginLoc;
        final createAccountLoc = state.namedLocation("registration");
        final welcomeLoc = state.namedLocation("welcome");
        final mfaLoc = state.namedLocation("mfa");
        final isMfa = state.subloc == mfaLoc;
        final otp = state.namedLocation("otp");
        final isOtp = state.subloc == otp;
        final phoneRegistration = state.namedLocation("phone-registration");
        final isPhoneRegistration = state.subloc == phoneRegistration;
        final isStartup = state.subloc == welcomeLoc;
        final creatingAccount = state.subloc == createAccountLoc;
        final loggedIn = await isUserAuthenticated();
        final home = state.namedLocation("homescreen", params: {"id": "0"});
        final forgotPassword = state.namedLocation('forgot-password');
        final isForgotPassword = state.subloc == forgotPassword;
        final finishedOnboarding = await _finishedOnboarding();
        final onboardingLoc = state.namedLocation('onboarding');
        final isOnboarding = state.subloc == onboardingLoc;
        if (!loggedIn && !finishedOnboarding && !isOnboarding) return onboardingLoc;
        if (!loggedIn &&
            !loggingIn &&
            !creatingAccount &&
            !isStartup &&
            !isMfa &&
            !isPhoneRegistration &&
            !isOtp &&
            !isForgotPassword &&
            !isOnboarding) return welcomeLoc;
        if (loggedIn && (loggingIn || creatingAccount || isStartup)) return home;
        return null;
      },
    );
  },
);
