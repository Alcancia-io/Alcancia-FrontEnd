import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BalanceItem {
  BalanceItem({required this.title, required this.value, required this.currency});

  String title;
  double value;
  String currency;
}

class BalanceCarousel extends StatefulWidget {
  const BalanceCarousel({Key? key, required this.balance}) : super(key: key);
  final Balance balance;

  @override
  State<BalanceCarousel> createState() => _BalanceCarouselState();
}

class _BalanceCarouselState extends State<BalanceCarousel> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final totalBalanceItem = BalanceItem(title: "Balance Total", value: widget.balance.total, currency: "USD");
    final cUSDBalanceItem =
        BalanceItem(title: "Balance Celo USD", value: widget.balance.mcUSD + widget.balance.cUSD, currency: "CUSD");
    final usdcBalanceItem = BalanceItem(
        title: "Balance USD Coin", value: widget.balance.etherscan + widget.balance.aPolUSDC, currency: "USDC");
    final carouselItems = [totalBalanceItem, usdcBalanceItem, cUSDBalanceItem];
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
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
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      "\$${balance.value.toStringAsFixed(6)} ${balance.currency}",
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
          options: CarouselOptions(
              viewportFraction: 1,
              height: 80,
              onPageChanged: (int index, _) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 7.0,
                height: 7.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
