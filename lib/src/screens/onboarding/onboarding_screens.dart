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

class OnboardingScreens extends StatefulWidget {
  OnboardingScreens({Key? key}) : super(key: key);

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final _responsiveService = ResponsiveService();
  final _controller = OnboardingController();

  final PageController _pageController = PageController();

  final items = [
    const OnboardingItem(
      assetPath: "lib/src/resources/images/welcome.svg",
      title: "Bienvenido",
      text:
          "Sabemos que quieres lograr muchas metas, por eso, en Alcancía nos encargamos de ayudarte a crecer tu capital",
    ),
    const OnboardingItem(
      assetPath: "lib/src/resources/images/save_and_grow.svg",
      title: "Ahorra y crece",
      text:
          "Ahorra en Alcancía y los diferentes protocolos que utilizamos para diversificar el riesgo y generar rentabilidad",
    ),
    const OnboardingItem(
      assetPath: "lib/src/resources/images/open_account.svg",
      title: "Abre tu cuenta",
      text:
          "No te preocupes, en Alcancía nos encargamos de todo para que tu dinero crezca mientras tu te enfocas en lo importante",
    ),
    const OnboardingItem(
      assetPath: "lib/src/resources/images/prepare.svg",
      title: "Preparáte",
      text: "Solo necesitas tu documento de identificación y una selfie.\n¡Así de fácil!",
    ),
  ];

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
            _buildBottomRow(),
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

  Widget _buildBottomRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (pageIndex != items.length - 1) ...[
              TextButton(
                onPressed: () async {
                  await _controller.finishOnboarding();
                  context.push("/registration");
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text("Saltar"),
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
                child: const Text("Siguiente"),
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
              buttonText: "Registrate",
              onPressed: () async {
                await _controller.finishOnboarding();
                context.push('/registration');
              },
            ),
          ),
        ],
      ],
    );
  }
}
