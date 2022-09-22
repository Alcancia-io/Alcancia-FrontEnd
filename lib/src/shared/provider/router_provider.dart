import 'package:alcancia/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/ramp/presentation/ramp-payment.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import 'package:alcancia/src/features/transactions-list/presentation/transactions_list_screen.dart';
import 'package:alcancia/src/features/swap/presentation/swap_screen.dart';
import 'package:alcancia/src/features/registration/presentation/otp_screen.dart';
import 'package:alcancia/src/features/swap/presentation/swap_screen.dart';
import 'package:alcancia/src/features/transactions-list/presentation/transactions_list_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<bool> fetchToken() async {
  StorageService service = StorageService();
  var token = await service.readSecureData("token");
  GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token as String);
  GraphQLClient client = graphQLConfiguration.clientToQuery();
  var result = await client.query(QueryOptions(document: gql(meQuery)));
  return !result.hasException;
  // print(result.hasException);
}

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      debugLogDiagnostics: true,
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
        if (await fetchToken()) {
          return state.location != "/dashboard" ? "/dashboard" : null;
          // return "/dashboard";
        }
        // means is not authenticated
        return state.location != "/login" ? "/login" : null;
      },
    );
  },
);
