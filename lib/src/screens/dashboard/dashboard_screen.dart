import 'package:alcancia/src/screens/dashboard/dashboard_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';

import '../../shared/provider/user_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final DashboardController dashboardController = DashboardController();
  late List<Transaction> txns;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    () async {
      setState(() {
        _isLoading = true;
      });
      try {
        var userInfo = await dashboardController.fetchUserInformation();
        txns = userInfo.txns;
        ref.watch(userProvider.notifier).setUser(userInfo.user);
      } catch (err) {
        setState(() {
          _error = err.toString();
        });
      }
      setState(() {
        _isLoading = false;
      });
    }();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    if (_isLoading) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }
    if (_error != "") return SafeArea(child: Center(child: Text(_error)));
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AlcanciaNavbar(username: user!.name),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: DashboardCard(
                  userProfit: user.userProfit,
                  userBalance: user.balance,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Actividad",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AlcanciaButton(
                      buttonText: "Ver más",
                      onPressed: () {
                        context.push("/homescreen/1");
                      },
                      color: const Color(0x00FFFFFF),
                      rounded: true,
                      height: 24,
                    ),
                  ],
                ),
              ),
              AlcanciaTransactions(
                txns: txns,
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
