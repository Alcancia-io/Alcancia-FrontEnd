import 'package:alcancia/src/features/login/presentation/login_screen.dart';
import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      name: "welcome",
      path: "/",
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) => LoginScreen(),
    ),
  ]);
});
