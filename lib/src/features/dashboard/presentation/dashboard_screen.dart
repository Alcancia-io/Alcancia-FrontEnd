import 'package:alcancia/src/features/login/domain/login_service.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    readToken() async {
      await _storageService.readSecureData("token");
    }

    print(readToken());

    return const Scaffold(
        body: SafeArea(
      child: Text("dashboard screen"),
    ));
  }
}
