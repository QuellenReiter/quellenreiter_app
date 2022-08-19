import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  final PageController _pageController = PageController(viewportFraction: 1);

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
    _pageController.dispose();

    super.dispose();
  }

  // next page function on submitted
  void nextPage({isUsernamePage = false}) async {
    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();

    if (isUsernamePage) {
      // check if username already exists
      bool usernameExists = await widget.appState.db.checkUsernameAlreadyExists(
          widget.appState,
          username: usernameController.text);
      if (usernameExists) {
        // show error
        HapticFeedback.heavyImpact();
        widget.appState.db.error = "Username schon vergeben.";
        HapticFeedback.heavyImpact();
        return;
      }
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
    );
  }

  Future<String?> usernameExists(String username) async {
    // check if username already exists
    bool usernameExists = await widget.appState.db.checkUsernameAlreadyExists(
        widget.appState,
        username: usernameController.text);
    if (usernameExists) {
      // show error
      HapticFeedback.heavyImpact();
      return "Username schon vergeben.";
    } else {
      return null;
    }
  }

  // next page function on submitted
  void previousPage() {
    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();

    _pageController.previousPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
    );
  }

  Widget createPageWithCenteredContent(Widget child) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Center(child: child),
    );
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
              child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      createPageWithCenteredContent(
                        ValueListenableBuilder(
                          valueListenable: emojiController,
                          builder: (context, TextEditingValue value, __) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Wähle deinen Emoji',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            color: DesignColors.backgroundBlue),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    onEditingComplete: nextPage,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          Utils.regexEmoji),
                                    ],
                                    controller: emojiController,
                                    decoration: const InputDecoration(
                                      counterText: "",
                                      labelText: "Emoji",
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
                                  const SizedBox(height: 20),
                                  // call nextPage if emoji is not empty
                                  if (emojiController.text.isNotEmpty)
                                    ElevatedButton(
                                      onPressed: nextPage,
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        widget.appState.route = Routes.login;
                                      },
                                      child: Wrap(
                                        children: [
                                          Text(
                                            "Du hast schon ein Konto? ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                    color: DesignColors
                                                        .backgroundBlue),
                                          ),
                                          Text(
                                            " Anmelden",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                    color: DesignColors.pink),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]);
                          },
                        ),
                      ),
                      createPageWithCenteredContent(
                        AutofillGroup(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: usernameController,
                                builder: (context, TextEditingValue value, __) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Wähle Username und Passwort',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  color: DesignColors
                                                      .backgroundBlue),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          inputFormatters: [
                                            UsernameTextFormatter(),
                                            FilteringTextInputFormatter.allow(
                                                Utils.regexUsername),
                                          ],
                                          autofillHints: const [
                                            AutofillHints.newUsername
                                          ],
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                            errorText: usernameController
                                                            .text.length <
                                                        3 &&
                                                    usernameController
                                                            .text.length >
                                                        0
                                                ? "Username muss mindestens 3 Zeichen lang sein"
                                                : null,
                                            labelText: "Username",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          keyboardType: TextInputType.name,
                                        ),
                                      ]);
                                },
                              ),
                              const SizedBox(height: 20),
                              ValueListenableBuilder(
                                valueListenable: passwordController,
                                builder: (context, TextEditingValue value, __) {
                                  return TextField(
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    autofillHints: const [
                                      AutofillHints.newPassword
                                    ],
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
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
                                    onEditingComplete: () =>
                                        TextInput.finishAutofillContext(),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              ValueListenableBuilder(
                                  valueListenable: passwordController,
                                  builder: (context, value, child) {
                                    return ValueListenableBuilder(
                                      valueListenable: password2Controller,
                                      builder: (context, TextEditingValue value,
                                          __) {
                                        return TextField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          autofillHints: const [
                                            AutofillHints.newPassword
                                          ],
                                          obscureText: true,
                                          controller: password2Controller,
                                          decoration: InputDecoration(
                                            errorText: passwordController
                                                        .text !=
                                                    password2Controller.text
                                                ? "Passwörter stimmen nicht überein"
                                                : passwordController
                                                                .text.length <
                                                            8 &&
                                                        passwordController
                                                                .text.length >
                                                            2
                                                    ? "Passwort muss mindestens 8 Zeichen lang sein."
                                                    : null,
                                            labelText: "Passwort wiederholen",
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: passwordController,
                                    builder:
                                        (context, TextEditingValue value, __) {
                                      return ValueListenableBuilder(
                                        valueListenable: usernameController,
                                        builder: (context,
                                            TextEditingValue value, __) {
                                          return ValueListenableBuilder(
                                            valueListenable:
                                                password2Controller,
                                            builder: (context,
                                                TextEditingValue value, __) {
                                              return ValueListenableBuilder(
                                                valueListenable:
                                                    emojiController,
                                                builder: (context,
                                                    TextEditingValue value,
                                                    __) {
                                                  return ElevatedButton(
                                                    onPressed: (usernameController
                                                                        .text
                                                                        .length >=
                                                                    Utils
                                                                        .usernameMinLength &&
                                                                passwordController
                                                                        .text
                                                                        .length >
                                                                    7 &&
                                                                emojiController
                                                                    .text
                                                                    .isNotEmpty) &&
                                                            password2Controller
                                                                    .value ==
                                                                passwordController
                                                                    .value
                                                        ? () async {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            // check if username is available
                                                            bool usernameExists = await widget
                                                                .appState.db
                                                                .checkUsernameAlreadyExists(
                                                                    widget
                                                                        .appState,
                                                                    username:
                                                                        usernameController
                                                                            .text);
                                                            if (usernameExists) {
                                                              // show error
                                                              HapticFeedback
                                                                  .heavyImpact();
                                                              widget.appState
                                                                  .showError(
                                                                      context,
                                                                      errorMsg:
                                                                          "Username bereits vergeben");
                                                              HapticFeedback
                                                                  .heavyImpact();

                                                              return;
                                                            }
                                                            // check if username is bad
                                                            bool usernameBad = await widget
                                                                .appState.db
                                                                .containsBadWord(
                                                                    usernameController
                                                                        .text);
                                                            if (usernameBad) {
                                                              // show error
                                                              HapticFeedback
                                                                  .heavyImpact();
                                                              widget.appState
                                                                  .showError(
                                                                      context,
                                                                      errorMsg:
                                                                          "Username enthält unerwünschte Wörter");
                                                              HapticFeedback
                                                                  .heavyImpact();

                                                              return;
                                                            }
                                                            TextInput
                                                                .finishAutofillContext();
                                                            showModalBottomSheet(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                isScrollControlled:
                                                                    true,
                                                                isDismissible:
                                                                    true,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return SafeArea(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          AnimationLimiter(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children:
                                                                              AnimationConfiguration.toStaggeredList(
                                                                            duration:
                                                                                const Duration(milliseconds: 800),
                                                                            childAnimationBuilder: (widget) =>
                                                                                SlideAnimation(
                                                                              horizontalOffset: 20.0,
                                                                              curve: Curves.elasticOut,
                                                                              child: FadeInAnimation(
                                                                                child: widget,
                                                                              ),
                                                                            ),
                                                                            children: [
                                                                              const Text(
                                                                                "🧠",
                                                                                style: TextStyle(fontSize: 100),
                                                                              ),
                                                                              Text(
                                                                                "Hast du dir dein Passwort gemerkt?",
                                                                                style: Theme.of(context).textTheme.headline2!.copyWith(color: DesignColors.backgroundBlue),
                                                                              ),
                                                                              Text(
                                                                                "Du kannst es nicht zurücksetzen, wenn du es vergisst.",
                                                                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: DesignColors.backgroundBlue),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      HapticFeedback.mediumImpact();
                                                                                      TextInput.finishAutofillContext();

                                                                                      Navigator.of(context).pop();
                                                                                      widget.appState.trySignUp(usernameController.text, passwordController.text, emojiController.text);
                                                                                    },
                                                                                    child: Text("Ja, weiter."),
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      HapticFeedback.mediumImpact();

                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text("Nein, zurück."),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          }
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
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    widget.appState.route = Routes.login;
                                  },
                                  child: Wrap(
                                    children: [
                                      Text(
                                        "Du hast schon ein Konto? ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                color: DesignColors
                                                    .backgroundBlue),
                                      ),
                                      Text(
                                        " Anmelden",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(color: DesignColors.pink),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
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
