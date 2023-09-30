import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_container.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InvestmentInfo extends StatefulWidget {
  final List<Map<String, String>> items;

  const InvestmentInfo({Key? key, required this.items}) : super(key: key);

  @override
  State<InvestmentInfo> createState() => _InvestmentInfoState();
}

class _InvestmentInfoState extends State<InvestmentInfo> {
  final PageController _pageController = PageController();
  final ResponsiveService responsiveService = ResponsiveService();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final txtTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 100, right: 26, bottom: 34, left: 26),
      child: AlcanciaContainer(
        borderRadius: 8,
        color: Theme.of(context).brightness == Brightness.dark
            ? alcanciaCardDark
            : alcanciaFieldLight,
        top: 36,
        right: 26,
        left: 26,
        bottom: 24,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: DefaultTextStyle(
                style: txtTheme.subtitle2 as TextStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 3, bottom: 3, right: 10, left: 10),
                      decoration:
                          pageIndex == 0 ? _activeBoxDecoration() : null,
                      child: Text(
                        appLoc.labelAssets,
                        style: pageIndex == 0
                            ? const TextStyle(color: Colors.white)
                            : null,
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 10),
                        decoration: pageIndex == 1 ? _activeBoxDecoration() : null,
                        child: Text(
                          appLoc.labelProtocol,
                          style: pageIndex == 1 ? const TextStyle(color: Colors.white) : null,
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 390,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  onPageChanged: (index) => setState(() => pageIndex = index),
                  itemBuilder: (ctx, index) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.items[index]["bold"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: txtTheme.bodyText1?.color),
                          ),
                          TextSpan(
                              text: widget.items[index]['regular'],
                              style: txtTheme.bodyText1),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildBottomRow(),
            const Spacer(),
            AlcanciaButton(
              buttonText: appLoc.buttonUnderstood,
              color: alcanciaLightBlue,
              width: double.infinity,
              height: responsiveService.getHeightPixels(64, screenHeight),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _activeBoxDecoration() {
    return const BoxDecoration(
      color: Color(0xff4E76E5),
      borderRadius: BorderRadius.all(Radius.circular(24)),
    );
  }

  Widget _buildBottomRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmoothPageIndicator(
              controller: _pageController,
              count: widget.items.length,
              onDotClicked: (index) {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: alcanciaLightBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
