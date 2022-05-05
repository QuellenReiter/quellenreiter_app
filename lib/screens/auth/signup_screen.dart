import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../utilities/utilities.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController emojiController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emojiController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: ValueListenableBuilder(
                valueListenable: usernameController,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      autofillHints: const [AutofillHints.newUsername],
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Nutzername",
                        border: const OutlineInputBorder(),
                        errorText: Utils.checkIfEmpty(usernameController),
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: ValueListenableBuilder(
                valueListenable: passwordController,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      autofillHints: const [AutofillHints.newPassword],
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Passwort",
                        border: const OutlineInputBorder(),
                        errorText: Utils.checkIfEmpty(passwordController),
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: ValueListenableBuilder(
                valueListenable: emojiController,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: emojiController,
                      decoration: const InputDecoration(
                        labelText: "Wähle ein Emoji",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => widget.appState.trySignUp(
                  usernameController.text,
                  passwordController.text,
                  emojiController.text),
              icon: const Icon(Icons.login),
              label: const Text("anmelden"),
            ),
            TextButton(
              onPressed: () => widget.appState.route = Routes.login,
              child: Text("Einloggen"),
            )
          ],
        ),
      ),
    );
  }
}
