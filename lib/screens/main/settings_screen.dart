import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/utilities/utilities.dart';

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          ValueListenableBuilder(
            valueListenable: emojiController,
            builder: (context, TextEditingValue value, __) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(Utils.regexEmoji),
                      ],
                      controller: emojiController,
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
                      onPressed: emojiController.text !=
                                  widget.appState.player!.emoji &&
                              emojiController.text.isNotEmpty
                          ? () {
                              HapticFeedback.selectionClick();
                              widget.appState.player?.emoji =
                                  emojiController.text;
                              widget.appState.updateUser();
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
                      controller: usernameController,
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
                    onPressed: usernameController.text !=
                                widget.appState.player!.name &&
                            usernameController.text.isNotEmpty
                        ? () {
                            HapticFeedback.selectionClick();
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
          if (widget.appState.error != null &&
              widget.appState.error!.isNotEmpty)
            Text(widget.appState.error!),
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.heavyImpact();
              widget.appState.logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text("Abmelden"),
          ),
          ElevatedButton.icon(
            onPressed: () => {},
            icon: const Icon(Icons.delete_forever),
            label: const Text("Account löschen"),
          ),
        ],
      ),
    );
  }
}
