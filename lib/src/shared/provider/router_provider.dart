import 'package:alcancia/src/features/registration/presentation/phone_registration_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import 'package:alcancia/src/features/swap/presentation/swap_screen.dart';
import 'package:alcancia/src/features/registration/presentation/otp_screen.dart';
import 'package:alcancia/src/features/user-profile/presentation/account_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/features/registration/model/user_registration_model.dart';
import 'package:alcancia/src/screens/login/mfa_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/login_data_model.dart';
import 'package:alcancia/src/shared/models/otp_data_model.dart';
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
          builder: (context, state) => PhoneRegistrationScreen(userRegistrationData: state.extra as UserRegistrationModel),
        ),
        GoRoute(
          name: "swap",
          path: "/swap",
          builder: (context, state) => SwapScreen(),
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
          builder: (context, state) => MFAScreen(data: state.extra as LoginDataModel),
        )
      ],
      redirect: (context, state) async {
        print(state.location);
        // if (await fetchToken() && state.location != "/dashboard") {
        final isUserInDashboard = state.location == "/homescreen/0";
        final isTransactions = state.location == "/homescreen/1";
        final isProfile = state.location == "/homescreen/2";
        final isSwap = state.location == "/swap";
        final isTransactionDetail = state.location == "/transaction_detail";
        // final isUserInSwapScreen = state.location == "/homescreen/0";
        final isWelcome = state.location == "/";
        final isLogin = state.location == "/login";
        final isRegister = state.location == "/registration";
        final isPhoneRegistration = state.location == "/phone-registration";
        final isOTP = state.location == "/otp";
        final isAccount = state.location == "/account";
        final isMFA = state.location == "/mfa";

        if (await isUserAuthenticated()) {
          if (isUserInDashboard) {
            return null;
          } else if (isTransactions) {
            return null;
          } else if (isSwap) {
            return null;
          } else if (isTransactionDetail) {
            return null;
          } else if (isProfile) {
            return null;
          } else if (isAccount) {
            return null;
          } else {
            // return "/homescreen/0";
            return "/homescreen/0";
          }
          // return "/dashboard";
        } else {
          print("NOT AUTHE");
          if (isWelcome) {
            return null;
          } else if (isLogin) {
            return null;
          } else if (isRegister) {
            return null;
          } else if (isOTP) {
            return null;
          } else if (isPhoneRegistration) {
            return null;
          } else if (isMFA) {
            return null;
          } else {
            // return "/homescreen/0";
            return "/";
          }
        }
        return null;
      },
    );
  },
);
