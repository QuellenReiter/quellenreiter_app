import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.signUpTapped}) : super(key: key);
  final Function signUpTapped;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: Column(children: [
        Text("login not implemented."),
        TextButton(
          onPressed: () => widget.signUpTapped(Routes.signUp),
          child: Text("SignUp"),
        )
      ])),
    );
  }
}
