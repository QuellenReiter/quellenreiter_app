import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/utilities/utilities.dart';
import 'package:quellenreiter_app/widgets/custom_bottom_sheet.dart';
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: AnimationLimiter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                          height: 10,
                        ),
                        ValueListenableBuilder(
                          valueListenable: usernameController,
                          builder: (context, TextEditingValue value, __) {
                            return Row(
                              children: [
                                Flexible(
                                  child: AutofillGroup(
                                    child: TextField(
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      inputFormatters: [
                                        UsernameTextFormatter(),
                                        FilteringTextInputFormatter.allow(
                                            Utils.regexUsername),
                                      ],
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      controller: usernameController,
                                      autofillHints: const [
                                        AutofillHints.newUsername
                                      ],
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        hintText:
                                            "Gebe einen neuen Username ein",
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
                                        ? () async {
                                            widget.appState.route =
                                                Routes.loading;
                                            HapticFeedback.selectionClick();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            widget.appState.player?.name =
                                                usernameController.text;
                                            await widget.appState.updateUser();
                                            widget.appState.route =
                                                Routes.settings;
                                          }
                                        : null,
                                    icon: const Icon(
                                        Icons.switch_access_shortcut),
                                    label: const Text("Username ändern"),
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    controller: emojiController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          Utils.regexEmoji),
                                    ],
                                    maxLength: 1,
                                    decoration: const InputDecoration(
                                      hintText: "Gebe einen neuen Emoji ein",
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
                                                  widget
                                                      .appState.player!.emoji &&
                                              emojiController.text.isNotEmpty
                                          ? () async {
                                              widget.appState.route =
                                                  Routes.loading;
                                              HapticFeedback.selectionClick();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              widget.appState.player?.emoji =
                                                  emojiController.text;
                                              await widget.appState
                                                  .updateUserData();
                                              widget.appState.route =
                                                  Routes.settings;
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
                        const SizedBox(
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
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    CustomBottomSheet.showCustomBottomSheet(
                                      context: context,
                                      scrollable: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
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
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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

                                                    widget.appState
                                                        .deleteAccount();
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
                                                            .all<Color>(
                                                                DesignColors
                                                                    .green),
                                                  ),
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .selectionClick();
                                                    Navigator.of(context).pop();
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
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  label: Text(
                                    "Account löschen",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            DesignColors.red),
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),

                        // toggle to allow notifications
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_active,
                                color: DesignColors.backgroundBlue,
                              ),
                              Text(
                                " Benachrichtigungen erlauben? ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: DesignColors.backgroundBlue),
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
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          DesignColors.pink),
                                ),
                                onPressed: () {
                                  HapticFeedback.heavyImpact();

                                  widget.appState.prefs
                                      .remove("tutorialPlayed");
                                  widget.appState.route = Routes.tutorial;
                                },
                                child: Text("Tutorial spielen",
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (MediaQuery.of(context).size.height > 1000)
                const SizedBox(
                  height: 200,
                ),
              SizedBox(
                // height: min(MediaQuery.of(context).size.height / 2, 400),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    ClipPath(
                      clipper: DiagonalClipper(),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        // clipBehavior: Clip.antiAlias,
                        color: DesignColors.pink,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: (MediaQuery.of(context).size.width *
                                          0.145) /
                                      2),
                              RotationTransition(
                                turns: const AlwaysStoppedAnimation(-8 / 360),
                                child: Center(
                                  child: Text(
                                    "Made in Berlin with ❤️ and ☕ and Steuergeld.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: (MediaQuery.of(context).size.width *
                                          0.145) /
                                      2),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image(
                                      height: MediaQuery.of(context)
                                                  .size
                                                  .aspectRatio >
                                              (9 / 16)
                                          ? 100
                                          : null,
                                      width: MediaQuery.of(context)
                                                  .size
                                                  .aspectRatio >
                                              (9 / 16)
                                          ? null
                                          : MediaQuery.of(context).size.width -
                                              40,
                                      image: const AssetImage(
                                          "assets/branding_low.png"),
                                    ),
                                    Wrap(
                                      runAlignment: WrapAlignment.center,
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            if (!await launchUrl(PublicURLs
                                                .quellenreiterWebsite)) {
                                              throw 'could not launch';
                                            }
                                          },
                                          child: Text(
                                            "QuellenReiter.app",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        DesignColors.lightGrey),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            if (!await launchUrl(
                                                PublicURLs.supportUrl)) {
                                              throw 'could not launch';
                                            }
                                          },
                                          child: Text(
                                            "Support",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        DesignColors.lightGrey),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            if (!await launchUrl(
                                                PublicURLs.impressum)) {
                                              throw 'could not launch';
                                            }
                                          },
                                          child: Text(
                                            "Impressum",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        DesignColors.lightGrey),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            if (!await launchUrl(
                                                PublicURLs.privacyPolicy)) {
                                              throw 'could not launch';
                                            }
                                          },
                                          child: Text(
                                            "Datenschutz",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        DesignColors.lightGrey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
