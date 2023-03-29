import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/screens/onboarding/onboarding_controller.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/models/onboarding_item.dart';
import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreens extends StatefulWidget {
  OnboardingScreens({Key? key}) : super(key: key);

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final _responsiveService = ResponsiveService();
  final _controller = OnboardingController();

  final PageController _pageController = PageController();

  List<OnboardingItem> _items() {
    final appLoc = AppLocalizations.of(context)!;
    return [
      OnboardingItem(
        assetPath: "lib/src/resources/images/welcome.svg",
        title: appLoc.labelOnboardingTitle1,
        text:
        appLoc.labelOnboardingText1,
      ),
      OnboardingItem(
        assetPath: "lib/src/resources/images/save_and_grow.svg",
        title: appLoc.labelOnboardingTitle2,
        text:
        appLoc.labelOnboardingText2,
      ),
      OnboardingItem(
        assetPath: "lib/src/resources/images/open_account.svg",
        title: appLoc.labelOnboardingTitle3,
        text:
        appLoc.labelOnboardingText3,
      ),
      OnboardingItem(
        assetPath: "lib/src/resources/images/prepare.svg",
        title: appLoc.labelOnboardingTitle4,
        text: appLoc.labelOnboardingText4,
      ),
    ];
  }

  Future<void> finishOnboarding() async {
    await _controller.finishOnboarding();
    context.go("/welcome");
  }

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final items = _items();
    return Scaffold(
      appBar: AlcanciaToolbar(
        state: StateToolbar.logoLetters,
        logoHeight: _responsiveService.getHeightPixels(60, screenHeight),
        toolbarHeight: _responsiveService.getHeightPixels(60, screenHeight),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                onPageChanged: (index) => setState(() => pageIndex = index),
                itemBuilder: (ctx, index) {
                  return _buildPage(
                    item: items[index],
                    assetHeight: screenHeight / 3,
                  );
                },
              ),
            ),
            _buildBottomRow(items),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required OnboardingItem item, required double assetHeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SvgPicture.asset(
              item.assetPath,
              height: assetHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    item.title,
                    style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    item.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(List<OnboardingItem> items) {
    final appLoc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (pageIndex != items.length - 1) ...[
              TextButton(
                onPressed: () async {
                  await finishOnboarding();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: Text(appLoc.buttonSkip),
              ),
            ],
            SmoothPageIndicator(
              controller: _pageController,
              count: items.length,
              onDotClicked: (index) => _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.linear),
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: alcanciaLightBlue,
              ),
            ),
            if (pageIndex != items.length - 1) ...[
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(pageIndex + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                },
                child: Text(appLoc.buttonNext),
              ),
            ],
          ],
        ),
        if (pageIndex == items.length - 1) ... [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: AlcanciaButton(
              color: alcanciaLightBlue,
              width: double.infinity,
              height: _responsiveService.getHeightPixels(64, MediaQuery.of(context).size.height),
              buttonText: appLoc.buttonNext,
              onPressed: () async {
                await finishOnboarding();
              },
            ),
          ),
        ],
      ],
    );
  }
}
