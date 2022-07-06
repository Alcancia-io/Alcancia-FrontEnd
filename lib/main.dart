import 'package:alcancia/screens/welcome/screen.dart';
import 'package:alcancia/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const uri = "http://localhost:3000/graphql";

    final HttpLink httpLink = HttpLink(uri,
        defaultHeaders: <String, String>{'Authorization': 'Bearer'});

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return MaterialApp(
      title: 'Alcancía',
      theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: alcanciaBgLight,
          primaryColor: alcanciaBgLight,
          cardColor: alcanciaBgLight,
          backgroundColor: alcanciaBgLight),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: alcanciaBgDark,
          primaryColor: alcanciaBgDark,
          cardColor: alcanciaBgDark,
          backgroundColor: alcanciaBgDark),
      themeMode: ThemeMode.system,
      home: GraphQLProvider(client: client, child: const WelcomeScreen()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sample'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
