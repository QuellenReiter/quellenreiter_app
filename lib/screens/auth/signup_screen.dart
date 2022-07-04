import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utilities/utilities.dart';
import '../../widgets/main_app_bar.dart';

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
        resizeToAvoidBottomInset: false,
        appBar: MainAppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ValueListenableBuilder(
                        valueListenable: usernameController,
                        builder: (context, TextEditingValue value, __) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              style: Theme.of(context).textTheme.bodyText2,
                              enableSuggestions: false,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              inputFormatters: [
                                UsernameTextFormatter(),
                                FilteringTextInputFormatter.allow(
                                    Utils.regexUsername),
                              ],
                              autofillHints: const [AutofillHints.username],
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
                              enableSuggestions: false,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    Utils.regexEmoji),
                              ],
                              keyboardType: TextInputType.visiblePassword,
                              controller: emojiController,
                              decoration: const InputDecoration(
                                counterText: "",
                                labelText: "Wähle einen Emoji",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.all(10),
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
                              style: Theme.of(context).textTheme.bodyText2,
                              autofillHints: const [AutofillHints.newPassword],
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
                            ),
                          );
                        },
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
                              style: Theme.of(context).textTheme.bodyText2,
                              autofillHints: const [AutofillHints.newPassword],
                              obscureText: true,
                              controller: password2Controller,
                              decoration: const InputDecoration(
                                labelText: "Passwort wiederholen",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Hero(
                        tag: "authButton",
                        child: ValueListenableBuilder(
                          valueListenable: passwordController,
                          builder: (context, TextEditingValue value, __) {
                            return ValueListenableBuilder(
                              valueListenable: usernameController,
                              builder: (context, TextEditingValue value, __) {
                                return ValueListenableBuilder(
                                  valueListenable: password2Controller,
                                  builder:
                                      (context, TextEditingValue value, __) {
                                    return ValueListenableBuilder(
                                      valueListenable: emojiController,
                                      builder: (context, TextEditingValue value,
                                          __) {
                                        return ElevatedButton(
                                          onPressed: (usernameController
                                                              .text.length >=
                                                          Utils
                                                              .usernameMinLength &&
                                                      passwordController
                                                              .text.length >
                                                          7 &&
                                                      emojiController
                                                          .text.isNotEmpty) &&
                                                  password2Controller.value ==
                                                      passwordController.value
                                              ? () => showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isDismissible: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      decoration: BoxDecoration(
                                                        color: DesignColors
                                                            .lightBlue,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                      ),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Hast du dir dein Passwort gemerkt? Du kannst es nicht zurücksetzen, wenn du es vergisst.",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4!
                                                                .copyWith(
                                                                    color:
                                                                        DesignColors
                                                                            .red),
                                                          ),
                                                          Flexible(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    widget.appState.trySignUp(
                                                                        usernameController
                                                                            .text,
                                                                        passwordController
                                                                            .text,
                                                                        emojiController
                                                                            .text);
                                                                  },
                                                                  child: Text(
                                                                      "Ja, weiter."),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      "Nein, zurück."),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  })
                                              : null,
                                          child: Text(
                                            "Registrieren",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                          ),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Hero(
                        tag: "authSwitch",
                        child: TextButton(
                          onPressed: () => widget.appState.route = Routes.login,
                          child: Text(
                            "Anmelden",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(color: DesignColors.pink),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Hero(
              tag: "authFooter",
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3.7,
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
                              Image(
                                height:
                                    MediaQuery.of(context).size.aspectRatio >
                                            (9 / 16)
                                        ? 100
                                        : null,
                                image: AssetImage("assets/branding_low.png"),
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
