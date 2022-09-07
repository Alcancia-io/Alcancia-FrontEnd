import 'package:alcancia/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:alcancia/src/features/registration/presentation/registration_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_tabbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      name: "welcome",
      path: "/",
      builder: (context, state) => const WelcomeScreen(),
      // builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: "homescreen",
      path: "/homescreen",
      builder: (context, state) => const AlcanciaTabbar(),
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
  ]);
});
