import 'package:alcancia/src/screens/dashboard/dashboard_screen.dart';
import 'package:alcancia/src/features/transactions-list/presentation/transactions_list_screen.dart';
import 'package:alcancia/src/features/user-profile/presentation/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlcanciaTabbar extends StatefulWidget {
  late int selectedIndex;
  AlcanciaTabbar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  final screens = [DashboardScreen(), TransactionsListScreen(), UserProfileScreen()];

  @override
  State<AlcanciaTabbar> createState() => _AlcanciaTabbarState();
}

class _AlcanciaTabbarState extends State<AlcanciaTabbar> {
  @override
  void initState() {
    super.initState();
  }

  BottomNavigationBarItem getTabItem(
    int tabIndex,
    String iconPath,
    String label,
  ) {
    var color;

    if (widget.selectedIndex == tabIndex) {
      // if item selected change icon color
      color = Theme.of(context).iconTheme.color;
    } else {
      color = null;
      label = "";
    }

    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        color: color,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    var ctx = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          selectedItemColor: ctx.iconTheme.color,
          onTap: (newTabIndex) {
              context.go('/homescreen/$newTabIndex');
          },
          // this will be needed when more than 3 items in the bar
          // type: BottomNavigationBarType.fixed,
          items: [
            getTabItem(
              0,
              "lib/src/resources/images/icon_home.svg",
              appLoc.labelTabHome,
            ),
            getTabItem(
              1,
              "lib/src/resources/images/icon_transactions.svg",
              appLoc.labelTabActivity,
            ),
            getTabItem(
              2,
              "lib/src/resources/images/user_profile.svg",
              appLoc.labelTabProfile,
            ),
          ],
        ),
      ),
      body: widget.screens[widget.selectedIndex],
    );
  }
}
