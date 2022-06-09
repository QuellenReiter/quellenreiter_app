import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return ListView(
      padding: const EdgeInsets.all(10),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        ValueListenableBuilder(
          valueListenable: emojiController,
          builder: (context, TextEditingValue value, __) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emojiController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(Utils.regexEmoji),
                    ],
                    maxLength: 1,
                    decoration: const InputDecoration(
                      hintText: "Gebe einen neuen Emoji ein.",
                      border: UnderlineInputBorder(
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
                  child: ElevatedButton.icon(
                    onPressed:
                        emojiController.text != widget.appState.player!.emoji &&
                                emojiController.text.isNotEmpty
                            ? () {
                                HapticFeedback.selectionClick();
                                FocusManager.instance.primaryFocus?.unfocus();
                                widget.appState.player?.emoji =
                                    emojiController.text;
                                widget.appState.updateUserData();
                              }
                            : null,
                    icon: const Icon(Icons.emoji_emotions),
                    label: const Text("Emoji ändern"),
                  ),
                ),
              ],
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: usernameController,
          builder: (context, TextEditingValue value, __) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    inputFormatters: [
                      UsernameTextFormatter(),
                      FilteringTextInputFormatter.allow(Utils.regexUsername),
                    ],
                    enableSuggestions: false,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    controller: usernameController,
                    autofillHints: const [AutofillHints.newUsername],
                    decoration: const InputDecoration(
                      hintText: "Gebe einen neuen Username ein.",
                      border: UnderlineInputBorder(
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
                ElevatedButton.icon(
                  onPressed:
                      usernameController.text != widget.appState.player!.name &&
                              usernameController.text.length >=
                                  Utils.usernameMinLength
                          ? () {
                              HapticFeedback.selectionClick();
                              FocusManager.instance.primaryFocus?.unfocus();
                              widget.appState.player?.name =
                                  usernameController.text;
                              widget.appState.updateUser();
                            }
                          : null,
                  icon: const Icon(Icons.switch_access_shortcut),
                  label: const Text("Username ändern."),
                ),
              ],
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.heavyImpact();
            widget.appState.logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text("Abmelden"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.heavyImpact();
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.only(top: 50),
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
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
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                DesignColors.red),
                          ),
                          onPressed: () {},
                          child: Text("Ich bin sicher."),
                        ),
                      ],
                    ),
                  );
                });
          },
          icon: const Icon(Icons.delete_forever),
          label: const Text("Account löschen"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DesignColors.red),
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 30), child: Divider()),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage("assets/branding_low.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Made in Berlin with ❤️ and ☕.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  if (!await launch("https://quellenreiter.app")) {
                    throw 'could not launch';
                  }
                },
                child: Text("QuellenReiter.app"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
