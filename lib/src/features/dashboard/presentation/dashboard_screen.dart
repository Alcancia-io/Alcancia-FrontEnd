import 'package:alcancia/src/features/dashboard/data/dashboard_controller.dart';
import 'package:alcancia/src/features/dashboard/presentation/dashboard_card.dart';
import 'package:alcancia/src/features/dashboard/presentation/navbar.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider);
    return userInfo.when(data: (user) {
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
                AlcanciaNavbar(username: user.name,),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DashboardCard(userProfit: user.userProfit, userBalance: user.balance,),
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
                          // context.push("/homescreen/1");
                          context.go("/homescreen/1");
                        },
                        color: const Color(0x00FFFFFF),
                        rounded: true,
                        height: 24,
                      ),
                    ],
                  ),
                ),
                AlcanciaTransactions(
                  transactions: user.transactions,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      );
    }, error: (error, stack) {
      return Center(child: Text(error.toString()));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
