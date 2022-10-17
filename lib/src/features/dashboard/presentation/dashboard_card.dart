import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard({Key? key, required this.userProfit, required this.userBalance}) : super(key: key);
  double userProfit;
  double userBalance;

  @override
  Widget build(BuildContext context) {
    var ctx = Theme.of(context);
    var balance = userBalance == 0.0 ? 0 : userBalance.toStringAsFixed(3);
    var profit = userProfit == 0.0 ? 0 : userProfit.toStringAsFixed(3);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ctx.brightness == Brightness.dark
            ? alcanciaCardDark2
            : alcanciaCardLight2,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Balance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            child: Text(
              "\$${balance} USDC",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: const Text(
                  "Ganancias",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: Text(
                  "\$${profit} USDC",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),
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
