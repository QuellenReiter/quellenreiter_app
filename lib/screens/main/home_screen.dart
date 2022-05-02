import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/screens/main/friends_screen.dart';
import 'package:quellenreiter_app/screens/main/settings_screen.dart';
import 'package:quellenreiter_app/screens/main/start_screen.dart';

import '../../constants/constants.dart';
import 'archive_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Widget body;
  late String title;
  int index = 0;

  @override
  void initState() {
    switch (widget.appState.route) {
      case Routes.friends:
        index = 1;
        break;
      case Routes.archive:
        index = 2;
        break;
      case Routes.addFriends:
        index = 1;
        break;
      case Routes.settings:
        index = 3;
        break;
      default:
        index = 0;
    }
    super.initState();
  }

  void onTap(int indexTapped) {
    switch (indexTapped) {
      case 0:
        widget.appState.route = Routes.home;
        setState(() {
          index = 0;
        });
        break;
      case 1:
        widget.appState.route = Routes.friends;
        setState(() {
          index = 1;
        });
        break;
      case 2:
        widget.appState.route = Routes.archive;
        setState(() {
          index = 2;
        });
        break;
      case 3:
        widget.appState.route = Routes.settings;
        setState(() {
          index = 3;
        });

        break;
      default:
        widget.appState.route = Routes.home;
        setState(() {
          index = 0;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        body = StartScreen(
          appState: widget.appState,
        );
        title = "Büro";
        break;
      case 1:
        body = FriendsScreen(
          appState: widget.appState,
        );
        title = "Freund:innen";
        break;
      case 2:
        body = ArchiveScreen(
          appState: widget.appState,
        );
        title = "Archiv";
        break;
      case 3:
        body = SettingsScreen(
          appState: widget.appState,
        );
        title = "Einstellungen";
        break;
      default:
        body = StartScreen(
          appState: widget.appState,
        );
        title = "Büro";
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple[100],
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.rocket_launch),
            icon: Icon(Icons.rocket),
            label: 'Büro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_rounded),
            label: 'Freund:innen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: 'Archiv',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
        currentIndex: index,
        onTap: onTap,
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}
