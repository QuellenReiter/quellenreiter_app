import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_information_parser.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_router_delegate.dart';

void main() {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const QuellenreiterApp());
}

class QuellenreiterApp extends StatefulWidget {
  const QuellenreiterApp({Key? key}) : super(key: key);

  @override
  State<QuellenreiterApp> createState() => _QuellenreiterAppState();
}

class _QuellenreiterAppState extends State<QuellenreiterApp> {
  final QuellenreiterRouterDelegate _routerDelegate =
      QuellenreiterRouterDelegate();

  String _appBadgeSupported = 'Unknown';

  final QuellenreiterRouteInformationParser _routeInformationParser =
      QuellenreiterRouteInformationParser();

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // link to the API
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routeInformationParser: _routeInformationParser,
      routerDelegate: _routerDelegate,
      builder: (ctx, child) {
        return Theme(
          child: child!,
          data: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                // Set your transitions here:
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            brightness: Brightness.light,
            primarySwatch: DesignColors.pinkSwatch,
            bottomAppBarColor: DesignColors.pink,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              elevation: 20,
              unselectedLabelStyle: TextStyle(
                color: DesignColors.backgroundBlue,
                fontFamily: 'Bangers',
                fontSize: 15,
              ),
              selectedLabelStyle: TextStyle(
                color: DesignColors.pink,
                fontFamily: 'Bangers',
                fontSize: 18,
              ),
            ),
            textTheme: const TextTheme(
              // Small text for light backgrounds.
              headline2: TextStyle(
                color: DesignColors.backgroundBlue,
                fontFamily: 'Bangers',
                fontSize: 30,
              ),
              headline4: TextStyle(
                color: Colors.white,
                fontFamily: 'Bangers',
                fontSize: 25,
              ),
              headline5: TextStyle(
                color: Colors.white,
                fontFamily: 'Bangers',
                fontSize: 20,
              ),
              headline1: TextStyle(
                color: Colors.white,
                fontFamily: 'Bangers',
                fontSize: 40,
              ),
              subtitle1: TextStyle(
                color: Colors.white,
                fontFamily: 'Oswald',
                fontSize: 20,
              ),
              bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: 'Oswald',
                fontSize: 16,
              ),
              bodyText2: TextStyle(
                color: DesignColors.black,
                fontFamily: 'Oswald',
                fontSize: 14,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: DesignColors.backgroundBlue,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: DesignColors.backgroundBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              titleTextStyle: TextStyle(
                fontFamily: 'Bangers',
                fontSize: 30,
              ),
            ),
            // fill back inside all TextFormField
            inputDecorationTheme: const InputDecorationTheme(
              isDense: true,
            ),
          ),
        );
      },
    );
  }
}
