import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final QuellenreiterRouteInformationParser _routeInformationParser =
      QuellenreiterRouteInformationParser();

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
                fontSize: 12,
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
