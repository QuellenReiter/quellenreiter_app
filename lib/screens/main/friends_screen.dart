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
    return Container(
      child: Center(child: Text("Friends not implemented.")),
    );
  }
}
