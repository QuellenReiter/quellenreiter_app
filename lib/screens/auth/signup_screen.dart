import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../utilities/utilities.dart';
import '../../widgets/error_banner.dart';

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
  late TextEditingController password2Controller;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emojiController = TextEditingController();
    password2Controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emojiController.dispose();
    password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Anmelden"),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Hero(
              tag: "authLogo",
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset(
                  'assets/logo-pink.png',
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ValueListenableBuilder(
                valueListenable: usernameController,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      inputFormatters: [
                        UsernameTextFormatter(),
                        FilteringTextInputFormatter.allow(Utils.regexUsername),
                      ],
                      autofillHints: const [AutofillHints.newUsername],
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Nutzername",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  );
                },
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ValueListenableBuilder(
                valueListenable: emojiController,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(Utils.regexEmoji),
                      ],
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
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ValueListenableBuilder(
                valueListenable: passwordController,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      autofillHints: const [AutofillHints.newPassword],
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Passwort",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const FractionallySizedBox(
              widthFactor: 0.8,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Merk dir dein Passwort gut, du wirst es nicht zurücksetzen können, wenn du es vergisst.",
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ValueListenableBuilder(
                valueListenable: password2Controller,
                builder: (context, TextEditingValue value, __) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      autofillHints: const [AutofillHints.newPassword],
                      obscureText: true,
                      controller: password2Controller,
                      decoration: const InputDecoration(
                        labelText: "Passwort wiederholen",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
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
                        return ValueListenableBuilder(
                          valueListenable: password2Controller,
                          builder: (context, TextEditingValue value, __) {
                            return ValueListenableBuilder(
                              valueListenable: emojiController,
                              builder: (context, TextEditingValue value, __) {
                                return ElevatedButton.icon(
                                  onPressed: (usernameController.text.length >=
                                                  Utils.usernameMinLength &&
                                              passwordController.text.length >
                                                  7 &&
                                              emojiController
                                                  .text.isNotEmpty) &&
                                          password2Controller.value ==
                                              passwordController.value
                                      ? () => widget.appState.trySignUp(
                                          usernameController.text,
                                          passwordController.text,
                                          emojiController.text)
                                      : null,
                                  icon: const Icon(Icons.login),
                                  label: const Text("anmelden"),
                                );
                              },
                            );
                          },
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
                onPressed: () => widget.appState.route = Routes.login,
                child: const Text("Einloggen"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
