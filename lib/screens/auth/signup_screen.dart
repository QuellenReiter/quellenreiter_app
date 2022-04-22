import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(
      {Key? key, required this.loginTapped, required this.trySignUp})
      : super(key: key);
  final Function loginTapped;
  final Function trySignUp;
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
            ElevatedButton.icon(
              onPressed: () => widget.trySignUp("uname", "pw"),
              icon: const Icon(Icons.login),
              label: const Text("anmelden"),
            ),
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
