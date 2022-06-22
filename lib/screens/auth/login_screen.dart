import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/error_banner.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Einloggen"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // padding: const EdgeInsets.all(40),
          children: [
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: DiagonalPathClipperTwo(),
                      child: Container(
                        color: DesignColors.pink,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(
                              image: AssetImage("assets/branding_low.png"),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    HapticFeedback.mediumImpact();
                                    if (!await launch(
                                        "https://quellenreiter.app")) {
                                      throw 'could not launch';
                                    }
                                  },
                                  child: Text(
                                    "QuellenReiter.app",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    HapticFeedback.mediumImpact();
                                    if (!await launch(
                                        "https://quellenreiter.app/Impressum/")) {
                                      throw 'could not launch';
                                    }
                                  },
                                  child: Text(
                                    "Impressum",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: DesignColors.lightGrey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    HapticFeedback.mediumImpact();
                                    if (!await launch(
                                        "https://quellenreiter.app/Datenschutz/")) {
                                      throw 'could not launch';
                                    }
                                  },
                                  child: Text(
                                    "Datenschutz",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: DesignColors.lightGrey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
