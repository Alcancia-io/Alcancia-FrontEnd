import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var pattern = getPattern(context);
    return Query(
        options: QueryOptions(document: gql(meQuery)),
        builder: (QueryResult<Object?> result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          //if (result.hasException) {
          //  return Text(result.exception.toString());
          //}
          if (result.isLoading) {
            return Scaffold(
              body: Center(
                child: AlcanciaLogo(
                  height: 120,
                ),
              ),
            );
          }
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
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      AlcanciaToolbar(
                          state: StateToolbar.logoNoletters,
                          logoHeight: size.height / 12),

                      //AlcanciaLogo(height: size.height / 12),
                      Transform(
                        transform: Matrix4.translationValues(0, 30, 0),
                        child: Image(
                            image: const AssetImage(
                                "lib/src/resources/images/welcome_image.png"),
                            width: size.width),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.5,
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
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.01),
                                child: Text(
                                  "Construye tu portafolio de ahorro basado en crypto",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              AlcanciaButton(
                                color: alcanciaLightBlue,
                                width: 308,
                                height: size.height * 0.06,
                                buttonText: "Regístrate",
                                onPressed: () {
                                  context.push('/registration');
                                },
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.01),
                                child: Row(
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
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () =>
                                            context.push("/login")),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
