import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BalanceItem {
  BalanceItem(
      {required this.title, required this.value, required this.currency});

  String title;
  double value;
  String currency;
}

class BalanceCarousel extends StatefulWidget {
  const BalanceCarousel(
      {Key? key, required this.balance, required this.redirectToGraph})
      : super(key: key);
  final Balance balance;
  final VoidCallback redirectToGraph;
  @override
  State<BalanceCarousel> createState() => _BalanceCarouselState();
}

class _BalanceCarouselState extends State<BalanceCarousel> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appLoc = AppLocalizations.of(context)!;
    final totalBalanceItem = BalanceItem(
        title: appLoc.labelTotalBalance,
        value: widget.balance.total,
        currency: "USD");
    var carouselItems = [totalBalanceItem];
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: carouselItems.length,
          itemBuilder: (BuildContext context, int itemIndex, int _) {
            final balance = carouselItems[itemIndex];
            final balanceString = balance.value.toStringAsFixed(6);
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        balance.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 40,
                        child: IconButton(
                          onPressed: widget.redirectToGraph,
                          icon: const Icon(Icons.auto_graph_rounded),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: balance.value == 0
                        ? Text(
                            "\$0 ${balance.currency}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width / 14,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          )
                        : Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "\$${balanceString.substring(0, balanceString.lastIndexOf("."))}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width / 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${balanceString.substring(balanceString.lastIndexOf("."))} ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width / 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: balance.currency,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width / 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            scrollPhysics: carouselItems.length == 1
                ? const NeverScrollableScrollPhysics()
                : null,
            viewportFraction: 1,
            height: 80,
            onPageChanged: (int index, _) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        if (carouselItems.length > 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: carouselItems.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 7.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ]
      ],
    );
  }
}
