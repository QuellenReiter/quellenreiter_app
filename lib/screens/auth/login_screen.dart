import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/main_app_bar.dart';
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
        resizeToAvoidBottomInset: false,
        appBar: MainAppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          // padding: const EdgeInsets.all(40),
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    controller: usernameController,
                                    decoration: const InputDecoration(
                                      labelText: "Nutzername",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                    autofillHints: const [
                                      AutofillHints.username
                                    ],
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
                                    onEditingComplete: () =>
                                        TextInput.finishAutofillContext(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    obscureText: true,
                                    controller: passwordController,
                                    decoration: const InputDecoration(
                                      labelText: "Passwort",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Hero(
                        tag: "authButton",
                        child: ValueListenableBuilder(
                          valueListenable: passwordController,
                          builder: (context, TextEditingValue value, __) {
                            return ValueListenableBuilder(
                              valueListenable: usernameController,
                              builder: (context, TextEditingValue value, __) {
                                return ElevatedButton(
                                  onPressed: usernameController.text.length >=
                                              Utils.usernameMinLength &&
                                          passwordController.text.length > 7
                                      ? () {
                                          HapticFeedback.mediumImpact();
                                          widget.appState.tryLogin(
                                            usernameController.text,
                                            passwordController.text,
                                          );
                                        }
                                      : null,
                                  child: Text(
                                    "Anmelden",
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: "authSwitch",
                    child: TextButton(
                      onPressed: () {
                        widget.appState.route = Routes.signUp;
                        HapticFeedback.mediumImpact();
                      },
                      child: Text("Konto erstellen",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: DesignColors.pink,
                                  )),
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: "authFooter",
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    ClipPath(
                      clipper: DiagonalClipper(),
                      child: Container(
                        color: DesignColors.pink,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  HapticFeedback.heavyImpact();
                                  widget.appState.route = Routes.tutorial;
                                },
                                child: Image(
                                  height:
                                      MediaQuery.of(context).size.aspectRatio >
                                              (9 / 16)
                                          ? 100
                                          : null,
                                  image: AssetImage("assets/branding_low.png"),
                                ),
                              ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
