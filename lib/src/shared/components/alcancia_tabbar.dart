import 'package:alcancia/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:alcancia/src/features/transactions-list/presentation/transactions_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaTabbar extends StatefulWidget {
  const AlcanciaTabbar({Key? key}) : super(key: key);

  @override
  State<AlcanciaTabbar> createState() => _AlcanciaTabbarState();
}

class _AlcanciaTabbarState extends State<AlcanciaTabbar> {
  var selectedIndex = 0;

  BottomNavigationBarItem getTabItem(
    int tabIndex,
    String iconPath,
    String label,
  ) {
    var color;

    if (selectedIndex == tabIndex) {
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

    switch (selectedIndex) {
      case 0:
        currentScreenPage = DashboardScreen();
        break;
      case 1:
        currentScreenPage = TransactionsListScreen();
        break;
    }

    return Scaffold(
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: ctx.iconTheme.color,
          onTap: (newTabIndex) {
            setState(() {
              selectedIndex = newTabIndex;
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
          ],
        ),
      ),
      body: currentScreenPage,
    );
  }
}
