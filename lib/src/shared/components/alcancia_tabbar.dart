import 'package:alcancia/src/screens/dashboard/dashboard_screen.dart';
import 'package:alcancia/src/features/transactions-list/presentation/transactions_list_screen.dart';
import 'package:alcancia/src/features/user-profile/presentation/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AlcanciaTabbar extends StatefulWidget {
  late int selectedIndex;
  AlcanciaTabbar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

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
    Widget currentScreenPage = const Text("");

    switch (widget.selectedIndex) {
      case 0:
        currentScreenPage = DashboardScreen();
        break;
      case 1:
        currentScreenPage = TransactionsListScreen();
        break;
      case 2:
        currentScreenPage = UserProfileScreen();
        break;
    }

    return Scaffold(
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          selectedItemColor: ctx.iconTheme.color,
          onTap: (newTabIndex) {
            setState(() {
              context.go('/homescreen/$newTabIndex');
              widget.selectedIndex = newTabIndex;
            });
          },
          // this will be needed when more than 3 items in the bar
          // type: BottomNavigationBarType.fixed,
          items: [
            getTabItem(
              0,
              "lib/src/resources/images/icon_home.svg",
              "Inicio",
            ),
            getTabItem(
              1,
              "lib/src/resources/images/icon_transactions.svg",
              "Actividad",
            ),
            getTabItem(
              2,
              "lib/src/resources/images/user_profile.svg",
              "Perfil",
            ),
          ],
        ),
      ),
      body: currentScreenPage,
    );
  }
}
