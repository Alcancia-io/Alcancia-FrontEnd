import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BalanceItem {
  BalanceItem({required this.title, required this.value, required this.currency});

  String title;
  double value;
  String currency;
}

class DashboardCard extends ConsumerWidget {
  DashboardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = Theme.of(context);
    final userBalance = ref.watch(balanceProvider);

    final totalBalanceItem = BalanceItem(title: "Balance Total", value: userBalance.total, currency: "USD");
    final cUSDBalanceItem =
        BalanceItem(title: "Balance Celo USD", value: userBalance.mcUSD + userBalance.cUSD, currency: "CUSD");
    final usdcBalanceItem =
        BalanceItem(title: "Balance USD Coin", value: userBalance.etherscan + userBalance.aPolUSDC, currency: "USDC");
    final carouselItems = [totalBalanceItem, usdcBalanceItem, cUSDBalanceItem];
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark ? alcanciaCardDark2 : alcanciaCardLight2,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: carouselItems.length,
            itemBuilder: (BuildContext context, int itemIndex, int _) {
              final balance = carouselItems[itemIndex];
              return SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      balance.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: Text(
                        "\$${balance.value} ${balance.currency}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(viewportFraction: 1, height: 100),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AlcanciaButton(
                    buttonText: "Depositar",
                    onPressed: () {
                      context.push("/swap");
                    },
                    width: 116,
                    height: 38,
                    color: alcanciaMidBlue,
                  ),
                  AlcanciaButton(
                    buttonText: "Retirar",
                    onPressed: () {},
                    width: 116,
                    height: 38,
                    color: alcanciaMidBlue,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
