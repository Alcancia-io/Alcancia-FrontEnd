import 'package:alcancia/src/features/welcome/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/features/login/presentation/login_screen.dart';

class Router extends ChangeNotifier {
  final router = GoRouter(routes: [
    GoRoute(path: "/", builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: "login", builder: (context, state) => const LoginScreen()),
  ]);
}
