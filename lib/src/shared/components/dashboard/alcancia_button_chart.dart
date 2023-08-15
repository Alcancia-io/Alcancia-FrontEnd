import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../resources/colors/colors.dart';
import '../../../screens/chart/line_chart_screen.dart';

class AlcanciaButtonChart extends StatefulWidget {
  const AlcanciaButtonChart({Key? key}) : super(key: key);

  @override
  _AlcanciaButtonChartState createState() => _AlcanciaButtonChartState();
}

class _AlcanciaButtonChartState extends State<AlcanciaButtonChart> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return SwipeableButtonView(
      buttonText: appLoc.labelButtonChart,
      buttontextstyle: TextStyle(
          fontSize: 18,
          color: (Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color.fromRGBO(219, 216, 216, 0.708))),
      buttonWidget: Icon(
        Icons.arrow_forward_ios_rounded,
        color: (Theme.of(context).brightness == Brightness.dark
            ? alcanciaFieldDark
            : Colors.grey),
      ),
      activeColor: (Theme.of(context).brightness == Brightness.dark
          ? alcanciaFieldDark
          : Colors.white),
      onWaitingProcess: () {
        Future.delayed(const Duration(seconds: 0),
            () => setState(() => isFinished = true));
      },
      isFinished: isFinished,
      onFinish: () async {
        await Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const LineChartScreen(),
              fullscreenDialog: true,
            ));
        setState(() {
          isFinished = false;
        });
      },
    );
  }
}
