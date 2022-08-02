import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/utilities/utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController emojiController;
  late TextEditingController usernameController;

  // TODO add controller for name controller
  /// Initialize [emojiController] to safe the emoji.
  @override
  void initState() {
    emojiController = widget.appState.player?.emoji == null
        ? TextEditingController()
        : TextEditingController(text: widget.appState.player?.emoji);
    usernameController = widget.appState.player?.name == null
        ? TextEditingController()
        : TextEditingController(text: widget.appState.player?.name);
    super.initState();
  }

  @override
  void dispose() {
    emojiController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 300),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 30.0,
                    curve: Curves.elasticOut,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder(
                      valueListenable: usernameController,
                      builder: (context, TextEditingValue value, __) {
                        return Row(
                          children: [
                            Flexible(
                              child: TextField(
                                style: Theme.of(context).textTheme.bodyText2,
                                inputFormatters: [
                                  UsernameTextFormatter(),
                                  FilteringTextInputFormatter.allow(
                                      Utils.regexUsername),
                                ],
                                enableSuggestions: false,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                controller: usernameController,
                                autofillHints: const [
                                  AutofillHints.newUsername
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Gebe einen neuen Username ein.",
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ElevatedButton.icon(
                                onPressed: usernameController.text !=
                                            widget.appState.player!.name &&
                                        usernameController.text.length >=
                                            Utils.usernameMinLength
                                    ? () {
                                        HapticFeedback.selectionClick();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        widget.appState.player?.name =
                                            usernameController.text;
                                        widget.appState.updateUser();
                                      }
                                    : null,
                                icon: const Icon(Icons.switch_access_shortcut),
                                label: const Text("Username ändern."),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder(
                      valueListenable: emojiController,
                      builder: (context, TextEditingValue value, __) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextField(
                                style: Theme.of(context).textTheme.bodyText2,
                                controller: emojiController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      Utils.regexEmoji),
                                ],
                                maxLength: 1,
                                decoration: const InputDecoration(
                                  hintText: "Gebe einen neuen Emoji ein.",
                                  counterText: "",
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
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton.icon(
                                  onPressed: emojiController.text !=
                                              widget.appState.player!.emoji &&
                                          emojiController.text.isNotEmpty
                                      ? () {
                                          HapticFeedback.selectionClick();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          widget.appState.player?.emoji =
                                              emojiController.text;
                                          widget.appState.updateUserData();
                                        }
                                      : null,
                                  icon: const Icon(Icons.emoji_emotions),
                                  label: const Text("Emoji ändern"),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              widget.appState.logout();
                            },
                            icon: const Icon(Icons.logout),
                            label: Text(
                              "Abmelden",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: const EdgeInsets.only(top: 50),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.warning_amber_rounded,
                                              color: DesignColors.red,
                                              size: 200,
                                            ),
                                            Text(
                                              "Willst du deinen Account wirklich für immer löschen?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<
                                                                      Color>(
                                                                  DesignColors
                                                                      .red),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();

                                                      widget.appState.db
                                                          .deleteAccount(
                                                              widget.appState);
                                                    },
                                                    child: Text("Ja",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<
                                                                      Color>(
                                                                  DesignColors
                                                                      .green),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .selectionClick();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("nein",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.delete_forever),
                              label: Text(
                                "Account löschen",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        DesignColors.red),
                              ),
                            ),
                          ),
                        ]),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              DesignColors.red),
                        ),
                        onPressed: () {
                          HapticFeedback.heavyImpact();

                          widget.appState.prefs.remove("tutorialPlayed");
                          widget.appState.route = Routes.tutorial;
                        },
                        child: Text("Tutorial anzeigen",
                            style: Theme.of(context).textTheme.headline5),
                      ),
                    ),
                    // toggle to allow notifications
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: DesignColors.backgroundBlue,
                        ),
                        Text(
                          " Benachrichtigungen erlauben? ",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: DesignColors.backgroundBlue),
                        ),
                        Switch(
                          value: widget.appState.notificationsAllowed,
                          onChanged: (bool value) {
                            HapticFeedback.mediumImpact();
                            widget.appState.notificationsAllowed = value;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
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
                top: 5,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(-8 / 360),
                  child: Center(
                    child: Text(
                      "Made in Berlin with ❤️ and ☕ and Steuergeld.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: DesignColors.backgroundBlue),
                    ),
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
                          height:
                              MediaQuery.of(context).size.aspectRatio > (9 / 16)
                                  ? 100
                                  : null,
                          image: const AssetImage("assets/branding_low.png"),
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
                                    .copyWith(color: DesignColors.lightGrey),
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
                                    .copyWith(color: DesignColors.lightGrey),
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
    );
  }
}
