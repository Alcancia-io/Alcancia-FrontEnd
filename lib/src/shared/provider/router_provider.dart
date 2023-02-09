import 'package:alcancia/main.dart';
import 'package:alcancia/src/features/registration/presentation/phone_registration_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import 'package:alcancia/src/features/registration/presentation/otp_screen.dart';
import 'package:alcancia/src/features/user-profile/presentation/account_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/screens/checkout/checkout.dart';
import 'package:alcancia/src/screens/forgot_password/forgot_password.dart';
import 'package:alcancia/src/screens/login/mfa_screen.dart';
import 'package:alcancia/src/screens/metamap/address_screen.dart';
import 'package:alcancia/src/screens/swap/swap_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/models/transaction_model.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<bool> isUserAuthenticated() async {
  StorageService service = StorageService();
  var token = await service.readSecureData("token");
  GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
  GraphQLClient client = graphQLConfiguration.clientToQuery();
  var result = await client.query(QueryOptions(document: gql(isAuthenticated)));
  return !result.hasException;
  // print(result.hasException);
}

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      navigatorKey: navigatorKey,
      // debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: "welcome",
          path: "/",
          builder: (context, state) => WelcomeScreen(),
        ),
        GoRoute(
          name: "login",
          path: "/login",
          builder: (context, state) => LoginScreen(),
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
          builder: (context, state) => AccountScreen(),
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
          builder: (context, state) => SwapScreen(),
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
            txnInput: state.extra as TransactionInput,
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
        )
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

        if (!loggedIn &&
            !loggingIn &&
            !creatingAccount &&
            !isStartup &&
            !isMfa &&
            !isPhoneRegistration &&
            !isOtp &&
            !isForgotPassword) return welcomeLoc;
        if (loggedIn && (loggingIn || creatingAccount || isStartup)) return home;
        return null;
      },
    );
  },
);
