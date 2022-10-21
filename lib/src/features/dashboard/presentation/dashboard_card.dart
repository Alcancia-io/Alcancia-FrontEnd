import 'dart:async';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:cron/cron.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardCard extends ConsumerWidget {
  DashboardCard({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Timer? timer;
    var ctx = Theme.of(context);
    var user = ref.watch(userProvider);

    print(user);
    var balance = user?.balance;
    var balanceFormatted = "0";
    if (balance != 0) balanceFormatted = balance!.toStringAsFixed(18);

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
              "\$${ref.watch(userProvider)?.balance} USDC",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
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
          )
        ],
      ),
    );
  }
}
