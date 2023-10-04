import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_error_widget.dart';
import 'package:alcancia/src/shared/components/alcancia_transaction_item.dart';
import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlcanciaTransactions extends ConsumerWidget {
  final double? height;
  final String bottomText;

  const AlcanciaTransactions({
    Key? key,
    required this.bottomText,
    this.height,
  }) : super(key: key);

  Color emptyTransactionsColor(ThemeData theme) {
    return theme.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userValue = ref.watch(alcanciaUserProvider);
    final appTheme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    return userValue.when(data: (user) {
      if (user.transactions!.isEmpty) {
        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.brightness == Brightness.dark
                ? alcanciaCardDark2
                : alcanciaCardLight2,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  "lib/src/resources/images/no_transactions.png",
                  color: emptyTransactionsColor(appTheme),
                  height: 80,
                ),
              ),
              Text(
                appLoc.labelNoTransactions,
                textAlign: TextAlign.center,
                style: TextStyle(color: emptyTransactionsColor(appTheme)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  bottomText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: emptyTransactionsColor(appTheme)),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox(
        height: height,
        child: ListView.builder(
          itemCount: user.transactions!.length,
          itemBuilder: (BuildContext context, int index) {
            var txn = user.transactions![index];
            return AlcanciaTransactionItem(
              user: user,
              txn: txn,
            );
          },
        ),
      );
    }, error: (error, _) {
      return const AlcanciaErrorWidget();
    }, loading: () {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    });
  }
}
