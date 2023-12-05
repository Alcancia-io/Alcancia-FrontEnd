import 'dart:io';

import 'package:alcancia/src/resources/colors/app_theme.dart';
import 'package:alcancia/src/shared/components/alcancia_error_widget.dart';
import 'package:alcancia/src/shared/provider/push_notifications_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alcancia/firebase_options.dart' as prod;
import 'package:alcancia/firebase_options-stage.dart' as stage;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/shared/provider/router_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:zendesk_messaging/zendesk_messaging.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

GlobalKey<NavigatorState> navigatorKey =
GlobalKey(debugLabel: "Main Navigator");

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  HttpOverrides.global = new MyHttpOverrides();
  await dotenv.load(fileName: ".env.dev");
  try {
    await Firebase.initializeApp(
      name: 'Alcancia-stage',
      options: stage.DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if(e is FirebaseException && e.code == 'duplicate-app') {
      debugPrint("Did you forget to recompile the Runner app, after changing environments?");
    }
    rethrow;
  }
  FlutterError.onError = (errorDetails) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Center(child: AlcanciaErrorWidget());
  };
  SystemChrome.setPreferredOrientations([
    DeviceOrientation
        .portraitUp, // Locks the device orientation to portrait mode
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  final PushNotificationProvider pushNotificationProvider =
  PushNotificationProvider();
  @override
  void initState() {
    super.initState();
    pushNotificationProvider.initNotifications();
    Intl.systemLocale = Platform.localeName;
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    var uri = dotenv.env['API_URL'] as String;

    final HttpLink httpLink = HttpLink(
      uri,
      defaultHeaders: <String, String>{'Authorization': 'Bearer '},
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        routerDelegate: router.routerDelegate,
        title: 'Alcancía',
        theme: AlcanciaTheme.lightTheme,
        darkTheme: AlcanciaTheme.darkTheme,
        themeMode: ThemeMode.system,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
