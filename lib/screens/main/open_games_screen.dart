import 'package:flutter/material.dart';

class OpenGamesScreen extends StatefulWidget {
  const OpenGamesScreen({Key? key}) : super(key: key);

  @override
  State<OpenGamesScreen> createState() => _OpenGamesScreenState();
}

class _OpenGamesScreenState extends State<OpenGamesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offene Spiele"),
      ),
      body: Center(child: Text("list of all open games here.")),
    );
  }
}
