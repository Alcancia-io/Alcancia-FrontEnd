import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardCard extends ConsumerWidget {
  DashboardCard({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    var ctx = Theme.of(context);
    String balance = user?.balance == 0.0 ? "0" : user?.balance.toStringAsFixed(3) ?? "0";
    final appLoc = AppLocalizations.of(context)!;
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
            children: [
              Text(
                appLoc.labelBalance,
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
              appLoc.labelBalanceValue(balance),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          Query(
            options: QueryOptions(
              document: gql(userProfit),
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              // if (result.hasException) {
              //   return Text("error");
              // }
              if (result.isLoading) {
                return CircularProgressIndicator();
              }
              var userProfit = result.data?['getUserProfit'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      appLoc.labelProfits,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    child: Text(
                      appLoc.labelProfitsValue("0"),
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
                        buttonText: appLoc.labelDeposit,
                        onPressed: () {
                          context.push("/swap");
                        },
                        width: 116,
                        height: 38,
                        color: alcanciaMidBlue,
                      ),
                      AlcanciaButton(
                        buttonText: appLoc.labelWithdraw,
                        onPressed: () {},
                        width: 116,
                        height: 38,
                        color: alcanciaMidBlue,
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
