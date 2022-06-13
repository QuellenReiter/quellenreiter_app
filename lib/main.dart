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
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            bottomAppBarColor: DesignColors.pink,
            // textTheme: TextTheme(

            //     // Small text for light backgrounds.
            //     bodyText2: TextStyle(
            //       color: DesignColors.black,
            //       fontFamily: 'Oswald',
            //     ),

            //     // Small text for blue backgrounds.
            //     bodyText1: TextStyle(
            //       // default all text widget
            //       fontFamily: 'Oswald',
            //       color: DesignColors.lightBlue,
            //     ),

            //     // Title in for appBar.
            //     headline1: TextStyle(
            //       fontFamily: 'Bangers',
            //       color: DesignColors.lightBlue,
            //     ),

            //     // Huge text in bangers font.
            //     headline3: TextStyle(
            //       fontFamily: 'Bangers',
            //       color: DesignColors.lightGrey,
            //     ),

            //     // Large font for subtitles on blue backgrounds.
            //     subtitle1: TextStyle(
            //       fontFamily: 'Oswald',
            //       color: DesignColors.lightBlue,
            //     ),

            //     // X-Large font for subtitles on light backgrounds.
            //     subtitle2: TextStyle(
            //       fontFamily: 'Oswald',
            //     ),

            //     // Large font for subtitles on light backgrounds.
            //     headline2: TextStyle(
            //       fontFamily: 'Oswald',
            //     )),
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
