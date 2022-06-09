import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/error_banner.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Einloggen"),
        ),
        bottomSheet: widget.appState.db.error != null
            ? ErrorBanner(appState: widget.appState)
            : null,
        body: ListView(
          // padding: const EdgeInsets.all(40),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Hero(
              tag: "authLogo",
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset(
                  'assets/logo-pink.png',
                  width: 200,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ValueListenableBuilder(
                        valueListenable: usernameController,
                        builder: (context, TextEditingValue value, __) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: "Nutzername",
                                border: OutlineInputBorder(),
                              ),
                              autofillHints: const [AutofillHints.username],
                              enableSuggestions: false,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              inputFormatters: [
                                UsernameTextFormatter(),
                                FilteringTextInputFormatter.allow(
                                    Utils.regexUsername),
                              ],
                              keyboardType: TextInputType.visiblePassword,
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
                              decoration: const InputDecoration(
                                labelText: "Passwort",
                                border: OutlineInputBorder(),
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
            Hero(
              tag: "authButton",
              child: FractionallySizedBox(
                widthFactor: 0.4,
                child: ValueListenableBuilder(
                  valueListenable: passwordController,
                  builder: (context, TextEditingValue value, __) {
                    return ValueListenableBuilder(
                      valueListenable: usernameController,
                      builder: (context, TextEditingValue value, __) {
                        return ElevatedButton.icon(
                          onPressed: usernameController.text.length >=
                                      Utils.usernameMinLength &&
                                  passwordController.text.length > 7
                              ? () => widget.appState.tryLogin(
                                    usernameController.text,
                                    passwordController.text,
                                  )
                              : null,
                          icon: const Icon(Icons.login),
                          label: const Text("Einloggen"),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Hero(
              tag: "authSwitch",
              child: TextButton(
                onPressed: () => widget.appState.route = Routes.signUp,
                child: const Text("Anmelden"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
