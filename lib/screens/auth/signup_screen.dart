import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key, required this.loginTapped}) : super(key: key);
  final Function loginTapped;
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => widget.loginTapped(Routes.login),
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
