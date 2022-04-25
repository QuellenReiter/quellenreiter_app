import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.index,
    required this.bottomNavCallback,
    required this.body,
    required this.title,
  }) : super(key: key);

  final int index;
  final Function(int) bottomNavCallback;
  final Widget body;
  final String title;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
        currentIndex: widget.index,
        onTap: widget.bottomNavCallback,
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.body,
    );
  }
}
