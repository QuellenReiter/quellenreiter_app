import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../utilities/utilities.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: ValueListenableBuilder(
                        valueListenable: usernameController,
                        builder: (context, TextEditingValue value, __) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: "Nutzername",
                                border: const OutlineInputBorder(),
                                errorText:
                                    Utils.checkIfEmpty(usernameController),
                              ),
                              autofillHints: const [AutofillHints.username],
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
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Passwort",
                                border: const OutlineInputBorder(),
                                errorText:
                                    Utils.checkIfEmpty(passwordController),
                              ),
                              autofillHints: const [AutofillHints.password],
                              onEditingComplete: () =>
                                  TextInput.finishAutofillContext(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.appState.error == null
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: SelectableText(
                      widget.appState.error!,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
            ValueListenableBuilder(
              valueListenable: passwordController,
              builder: (context, TextEditingValue value, __) {
                return ValueListenableBuilder(
                  valueListenable: usernameController,
                  builder: (context, TextEditingValue value, __) {
                    return ElevatedButton.icon(
                      onPressed: usernameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty
                          ? () => widget.appState.tryLogin(
                                usernameController.text,
                                passwordController.text,
                              )
                          : null,
                      icon: const Icon(Icons.login),
                      label: const SelectableText("Einloggen"),
                    );
                  },
                );
              },
            ),
            TextButton(
              onPressed: () => widget.appState.route = Routes.signUp,
              child: const Text("Anmelden"),
            ),
          ],
        ),
      ),
    );
  }
}
