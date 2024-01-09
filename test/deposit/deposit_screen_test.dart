import 'package:alcancia/main.dart';
import 'package:alcancia/src/screens/deposit/crypto_deposit_screen.dart';
import 'package:alcancia/src/screens/deposit/deposit_screen.dart';
import 'package:alcancia/src/screens/swap/swap_screen.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Test DepositScreen', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: routerMockDepositTest,
      localizationsDelegates: const [AppLocalizations.delegate],
      locale: const Locale("en"),
    ));
    //Verify image load async
    await tester.pumpAndSettle();

    // Verify that the DepositScreen has the correct title.
    expect(find.text('Deposit'),
        findsOneWidget); // Replace 'Deposit' with the expected title

    // Verify that both DepositOptions are displayed.
    expect(find.byType(DepositScreen), findsNWidgets(2));

    // Verify that the AppBar contains the title.
    expect(find.text('Deposit'), findsOneWidget);

    // Verify that the logo is displayed in the AppBar.
    expect(find.byType(AlcanciaToolbar), findsOneWidget);

    // Verify that the 'Coming Soon!' text is not displayed initially.
    expect(find.text('Coming Soon!'), findsNothing);

    // Tap on the first DepositOption and navigate to the corresponding screen.
    await tester.tap(find.text('Bank Deposits'));
    await tester.pump(); // Wait for navigation transition
    expect(find.byType(AlcanciaToolbar),
        findsOneWidget); // Verify that the logo is displayed in the AppBar of Swap Screen

    // Tap on the second DepositOption, which is 'Coming Soon!', and verify the message.
    await tester.tap(find.text('Crypto Deposits'));
    await tester.pump(); // Wait for navigation transition
    expect(find.byType(AlcanciaToolbar), findsOneWidget);
  });
}

final routerMockDepositTest = GoRouter(
  initialLocation: "/",
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      name: "deposit",
      path: "/",
      builder: (context, state) => const ProviderScope(child: DepositScreen()),
    ),
    GoRoute(
      name: "swap",
      path: "/swap",
      builder: (context, state) => const ProviderScope(child: SwapScreen()),
    ),
    GoRoute(
      name: "crypto-deposit",
      path: "/crypto-deposit",
      builder: (context, state) =>
          const ProviderScope(child: CryptoDepositScreen()),
    ),
  ],
  redirect: (context, state) async {},
);
