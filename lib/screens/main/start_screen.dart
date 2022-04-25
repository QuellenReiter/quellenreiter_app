import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, this.query = ""}) : super(key: key);

  /// The query used to search for friends.
  final String query;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("StartScreen"),
      ),
    );
  }
}
