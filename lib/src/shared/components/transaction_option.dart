import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionOption extends StatelessWidget {
  const TransactionOption({
    Key? key,
    required this.imageSrc,
    required this.title,
    required this.subtitle,
    required this.pill1,
    this.pill2,
    required this.onTap,
    this.comingSoon = false,
  }) : super(key: key);

  final String imageSrc;
  final String title;
  final String subtitle;
  final String pill1;
  final String? pill2;
  final void Function()? onTap;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final comingSoonColor = darkMode
        ? alcanciaMidBlue
        : alcanciaLightBlue;
    final appLoc = AppLocalizations.of(context)!;
    return Opacity(
      opacity: comingSoon ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: InkWell(
          splashFactory: InkSplash.splashFactory,
          splashColor: darkMode ? Colors.grey : Colors.red,
          borderRadius: BorderRadius.circular(10),
          onTap: comingSoon ? null : onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? alcanciaCardDark2
                  : alcanciaCardLight2,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    imageSrc,
                    height: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(subtitle),
                    ),
                    if (comingSoon) ... [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: comingSoonColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              appLoc.labelComingSoon,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ... [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: darkMode
                                    ? Color(0xFF9AFF47).withOpacity(0.2)
                                    : Color(0xFF31DE52).withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  pill1,
                                  style: TextStyle(
                                      color: darkMode
                                          ? Color(0xFF31DE52)
                                          : Colors.green),
                                ),
                              ),
                            ),
                          ),
                          if (pill2 != null) ... [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: darkMode
                                      ? Color(0xFF9AFF47).withOpacity(0.2)
                                      : Color(0xFF31DE52).withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    pill2!,
                                    style: TextStyle(
                                        color: darkMode
                                            ? Color(0xFF31DE52)
                                            : Colors.green),
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ]
                  ],
                ),
                Spacer(),
                Icon(Icons.chevron_right_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
