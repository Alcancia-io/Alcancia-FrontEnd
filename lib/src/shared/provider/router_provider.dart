import 'package:alcancia/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/registration/presentation/otp_screen.dart';
import 'package:alcancia/src/features/swap/presentation/swap_screen.dart';
import 'package:alcancia/src/features/transactions-list/presentation/transactions_list_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/features/withdraw/presentation/withdraw_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      name: "welcome",
      path: "/",
      // builder: (context, state) => const WelcomeScreen(),
      // builder: (context, state) => const TransactionDetail(),
      builder: (context, state) => const WelcomeScreen(),
      // builder: (context, state) => DashboardScreen(),
      // builder: (context, state) => HomeScreen(),
      // builder: (context, state) => const AlcanciaTabbar(),
      // builder: (context, state) => SwapScreen(),
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
    GoRoute(
      name: "withdraw",
      path: "/withdraw",
      builder: (context, state) => WithdrawScreen(),
    )
  ]);
});
