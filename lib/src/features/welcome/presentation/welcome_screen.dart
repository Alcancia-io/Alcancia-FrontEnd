import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var pattern = getPattern(isDarkMode);
    return Query(
      options: QueryOptions(document: gql(meQuery)),
      builder: (QueryResult<Object?> result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return const Text('Loading...');
        }
        print(result.data);
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: pattern)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SvgPicture.asset(
                      isDarkMode
                          ? "assets/images/icon_alcancia_dark.svg"
                          : "assets/images/icon_alcancia_light.svg",
                      height: size.height / 12),
                  Transform(
                    transform: Matrix4.translationValues(0, 30, 0),
                    child: Image(
                        image:
                            const AssetImage("assets/images/welcome_image.png"),
                        width: size.width),
                  ),
                  Expanded(
                      child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(33),
                            topRight: Radius.circular(33))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Descubre una nueva forma de ahorrar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Construye tu portafolio de ahorro basado en crypto",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                          ),
                          const Spacer(),
                          CupertinoButton.filled(
                            child: const Text("Registrate"),
                            onPressed: () {},
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿Ya tienes cuenta?",
                                textAlign: TextAlign.center,
                              ),
                              CupertinoButton(
                                  child: const Text(
                                    "Inicia sesión",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () =>
                                      GoRouter.of(context).go("/login")),
                            ],
                          )
                        ],
                      ),
                    )),
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
