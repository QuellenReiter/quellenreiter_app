import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_information_parser.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_router_delegate.dart';

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

void main() {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Workmanager().registerOneOffTask(
  //     "com.quellenreiter.backgroundtask", "simpleTask",
  //     tag: "com.quellenreiter.backgroundtask",
  //     initialDelay: const Duration(seconds: 5),
  //     constraints: Constraints(networkType: NetworkType.connected));
  runApp(const QuellenreiterApp());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class QuellenreiterApp extends StatefulWidget {
  const QuellenreiterApp({Key? key}) : super(key: key);

  @override
  State<QuellenreiterApp> createState() => _QuellenreiterAppState();
}

class _QuellenreiterAppState extends State<QuellenreiterApp> {
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    startBackgroundTasks(_enabled);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      setState(
        () {
          _events.insert(0, new DateTime.now());
        },
      );
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void startBackgroundTasks(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }

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
