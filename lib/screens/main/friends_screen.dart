import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key, this.query = ""}) : super(key: key);

  /// The query used to search for friends.
  final String query;
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () => {},
            child: Icon(Icons.add),
          ),
        ),
      ),
      Center(
        child: Text("Friends not implemented."),
      ),
    ]);
  }
}
