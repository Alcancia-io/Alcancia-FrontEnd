import 'package:alcancia/src/screens/dashboard/dashboard_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import 'package:alcancia/src/features/swap/presentation/swap_screen.dart';
import 'package:alcancia/src/features/registration/presentation/otp_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
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
          name: "dashboard",
          path: "/dashboard",
          builder: (context, state) => DashboardScreen(),
        ),
        GoRoute(
          name: "registration",
          path: "/registration",
          builder: (context, state) => const RegistrationScreen(),
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
            password: state.extra! as String,
          ),
        ),
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
          } else {
            // return "/homescreen/0";
            return "/homescreen/0";
          }
          // return "/dashboard";
        }
        // means is not authenticated
        // return state.location != "/login" ? "/login" : null;
      },
    );
  },
);
